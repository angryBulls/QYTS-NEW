//
//  TSSpeechRecognizer.m
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSSpeechRecognizer.h"
#import "TSDBManager.h"
#import "TSDBManager+RecognizerResultJudge.h"

// ifly class
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "iflyMSC/IFlySpeechError.h"
#import "RecognizerFactory.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "ISRDataHelper.h"
#import "PcmModel.h"
#import "PcmPlayer.h"
#import "TTSConfig.h"
#define GRAMMAR_TYPE_BNF @"bnf"

@interface TSSpeechRecognizer ()
@property (nonatomic, strong) TSDBManager *dbManager;

// ifly properties
//语法识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, copy) NSString *engineType; //引擎类型
@property (nonatomic, copy)  NSString *grammarType; //语法类型
@property (nonatomic, copy) NSString *localgrammerId; //本地识别生成的grammarID
@property (nonatomic, strong) IFlyDataUploader *uploader;
@property (nonatomic, strong) NSMutableString *curResult; //当前session的结果
@property (nonatomic) BOOL isCanceled;
@property (nonatomic ,copy) NSString *date ;
@property (nonatomic, strong) NSMutableArray *pcmArrs;
@property (nonatomic, strong) PcmPlayer *player;


@end

@implementation TSSpeechRecognizer

-(NSMutableArray *)pcmArrs{
    if (_pcmArrs == nil) {
        _pcmArrs = [NSMutableArray array];
    }
    return _pcmArrs;
}

-(PcmPlayer *)player{
    if (_player == nil) {
        _player = [[PcmPlayer alloc] init];
    }
    return _player;
}

+ (instancetype)defaultInstance {
    
    static dispatch_once_t onceToken;
    static TSSpeechRecognizer *speechRecognizer = nil;
    
    dispatch_once(&onceToken, ^{
        speechRecognizer = [[self alloc] init];
    });
    return speechRecognizer;
}


-(void)refreshFMDB{
    
    _dbManager = [[TSDBManager alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self p_setupSpeechRecognizer];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeArr) name:TSremoveArr object:nil];
    }
    
    return self;
}

-(void)removeArr{
    
    [self.pcmArrs removeAllObjects];
    
}

- (void)p_setupSpeechRecognizer {
    [self p_setupIfly];
    
    [self p_buildIflyGrammer];
}

/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @
 */
- (void)onVolumeChanged:(int)volume {
//    NSString *currentVolume = [NSString stringWithFormat:@"音量：%d",volume];
    if ([self.delegate respondsToSelector:@selector(onVolumeChanged:)]) {
        [self.delegate onVolumeChanged:volume];
    }
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 */
- (void)onBeginOfSpeech {
    DDLog(@"正在录音");
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 */
- (void)onEndOfSpeech {
    DDLog(@"停止录音");
    if ([self.delegate respondsToSelector:@selector(onEndOfSpeech)]) {
        [self.delegate onEndOfSpeech];
    }
}

/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   error   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void)onError:(IFlySpeechError *)error {
    DDLog(@"error=%d",[error errorCode]);
    
    NSString *text ;
    if (self.isCanceled) {
        text = @"识别取消";
    } else if (error.errorCode == 0 ) {
        if (self.curResult.length==0 || [self.curResult hasPrefix:@"nomatch"]) {
            text = @"无匹配结果";
        } else {
            text = @"识别成功";
        }
    } else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
    }
    
    DDLog(@"%@",text);
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   results      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 */
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSMutableString * resultString = [[NSMutableString alloc]init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
        
        if([self.engineType isEqualToString:[IFlySpeechConstant TYPE_LOCAL]]) {
            NSString * resultFromJson =  [ISRDataHelper stringFromJson:result];
            [resultString appendString:resultFromJson];
        } else {
            NSString * resultFromJson =  [ISRDataHelper stringFromABNFJson:result];
            [resultString appendString:resultFromJson];
        }
    }
    
    if (isLast) {

    }
    [self.curResult appendString:resultString];
    
    DDLog(@"result is:%@",self.curResult);
    
    // 保存当前识别结果
    NSDictionary *resultDict = [TSToolsMethod dictionaryWithJsonString:[dic allKeys][0]];

    [self.dbManager saveOneResultDataWithDict:resultDict saveDBStatusSuccessBlock:^(NSDictionary *insertDBDict) {
        if ([self.delegate respondsToSelector:@selector(onResultsString:insertDBDict:recognizerResult:)]) {
            NSString *returnString = [_dbManager appendResultStringWithDict:insertDBDict];
            DDLog(@"returnString is:%@", returnString);
            
            [_pcmArrs removeLastObject];
            
            [self.delegate onResultsString:returnString insertDBDict:insertDBDict recognizerResult:YES];
        }
    } saveDBStatusFailBlock:^(NSString *error) {
        
        [self.delegate onResultsString:self.curResult insertDBDict:@{} recognizerResult:NO];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:_pcmArrs forKey:@"pcmArr"];
        if ([self.delegate respondsToSelector:@selector(backPcmModelDic:)]) {
            [self.delegate backPcmModelDic:dic];
        }
        
        
    } saveDBStatusWrongBlock:^(NSString *error) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:_pcmArrs forKey:@"pcmArr"];
        if ([self.delegate respondsToSelector:@selector(backPcmModelDic:)]) {
            [self.delegate backPcmModelDic:dic];
        }
        
    }];
    
//    DDLog(@"dbManager info is:%@", dbManager);
}

/**
 * @fn      onCancal
 * @brief   取消识别回调
 *
 */
- (void)onCancel {
    DDLog(@"正在取消");
}

#pragma mark - ifly set up method
- (void)p_setupIfly {
    self.iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"asr"];
    [self.iFlySpeechRecognizer setParameter:@"1" forKey:@"asr_wbest"];
    self.isCanceled = NO;
    self.curResult = [[NSMutableString alloc] init];
    self.engineType = [IFlySpeechConstant TYPE_LOCAL];
    self.grammarType = GRAMMAR_TYPE_BNF;
    self.localgrammerId = nil;
    self.uploader = [[IFlyDataUploader alloc] init];
    [self p_buildIflyGrammer];
}

- (void)p_buildIflyGrammer {
    NSString *grammarContent = nil;
    NSString *documentsPath = nil;
    NSArray *appArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([appArray count] > 0) {
        documentsPath = [appArray objectAtIndex:0];
    }
    NSString *appPath = [[NSBundle mainBundle] resourcePath];
    [TSToolsMethod createDirec:@"grm"];
    
    if([self.engineType isEqualToString: [IFlySpeechConstant TYPE_LOCAL]])
    {
        //grammar build path
        NSString *grammBuildPath = [documentsPath stringByAppendingString:@"/grm"];
        
        //aitalk resource path
        NSString *aitalkResourcePath = [[NSString alloc] initWithFormat:@"fo|%@/aitalkResource/common.mp3",appPath];
        
        //bnf resource
        NSString *bnfFilePath = [[NSString alloc] initWithFormat:@"%@/bnf/5V5Basketball.bnf",appPath];
        TSDBManager *dbManager = [[TSDBManager alloc] init];
        NSDictionary *gameTableDict = [dbManager getObjectById:GameId fromTable:GameTable];
        if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3X3 加载的bnf
            bnfFilePath = [[NSString alloc] initWithFormat:@"%@/bnf/3X3Basketball.bnf",appPath];
        }
        
        grammarContent = [TSToolsMethod readFile:bnfFilePath];
        
        [[IFlySpeechUtility getUtility] setParameter:@"asr" forKey:[IFlyResourceUtil ENGINE_START]];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        [_iFlySpeechRecognizer setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
        [_iFlySpeechRecognizer setParameter:self.engineType forKey:[IFlySpeechConstant ENGINE_TYPE]];
        
        [_iFlySpeechRecognizer setParameter:grammBuildPath forKey:[IFlyResourceUtil GRM_BUILD_PATH]];
        
        [_iFlySpeechRecognizer setParameter:aitalkResourcePath forKey:[IFlyResourceUtil ASR_RES_PATH]];
        [self.iFlySpeechRecognizer setParameter:@"asr" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
        [_iFlySpeechRecognizer setParameter:@"utf-8" forKey:@"result_encoding"];
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
//        [_iFlySpeechRecognizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    }
    
    //开始构建
    [_iFlySpeechRecognizer buildGrammarCompletionHandler:^(NSString *grammerID, IFlySpeechError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![error errorCode]) {
                DDLog(@"上传成功");
            } else {
                DDLog(@"上传失败");
                DDLog(@"errorCode=%d",[error errorCode]);
            }
            
            if ([self.engineType isEqualToString: [IFlySpeechConstant TYPE_LOCAL]]) {
                _localgrammerId = grammerID;
                [_iFlySpeechRecognizer setParameter:_localgrammerId  forKey:[IFlySpeechConstant LOCAL_GRAMMAR]];
            }
        });
    } grammarType:self.grammarType grammarContent:grammarContent];
}

//保存录音文件
-(void)p_saveVedio{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    _date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"date = %@",_date);
    
    IFlySpeechRecognizer *fly =   [IFlySpeechRecognizer sharedInstance];
    
    [fly setParameter:[NSString stringWithFormat:@"%@.pcm",_date] forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    PcmModel *play = [[PcmModel alloc] init];
    play.areadlyPlay = NO;
    play.saveIn = YES;
    play.pcmPath = [NSString stringWithFormat:@"%@/%@.pcm",path,_date];
    
    [self.pcmArrs addObject:play];
 
}
//读取录音文件
-(void)p_readVedioWithPath:(NSString *)path{
    [self.player stop];
    DDLog(@"current pcm path is:%@", path);
    TTSConfig *instance = [TTSConfig sharedInstance];
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    self.player = [[PcmPlayer alloc] initWithFilePath:path sampleRate:[instance.sampleRate integerValue]];
    [_player play];
    
}

//删除录音文件

-(void)deleteVedioWithPath:(NSString *)path{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([path hasSuffix:@".pcm"]) {
        NSString *fileDir = [NSString stringWithFormat:@"%@/%@",path,path];
        BOOL bRet = [fileMgr fileExistsAtPath:fileDir];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:fileDir error:&err];
        }
    }
    
}
//删除所有录音文件
-(void)deleteAllVedios{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileList= [fileMgr contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileList)
    {
        
        if ([fileName hasSuffix:@".pcm"]) {
            NSString *fileDir = [NSString stringWithFormat:@"%@/%@",path,fileName];
            BOOL bRet = [fileMgr fileExistsAtPath:fileDir];
            if (bRet) {
                NSError *err;
                [fileMgr removeItemAtPath:fileDir error:&err];
            }
        }
    }

}


#pragma mark - return method ************************************************************************
- (void)startListening {
    BOOL ret = [IFlySpeechRecognizer.sharedInstance startListening];
    if (ret) {
        DDLog(@"识别开启成功");
        [self p_saveVedio];
        [self.curResult setString:@""];
    } else {
        DDLog(@"启动识别服务失败，请稍后重试");//可能是上次请求未结束
    }
    
}
- (void)stopListening {
    
    [IFlySpeechRecognizer.sharedInstance stopListening];
    DDLog(@"结束识别");
    
}
- (void)cancel {
    
    [IFlySpeechRecognizer.sharedInstance cancel];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TSremoveArr object:nil];
}

@end
