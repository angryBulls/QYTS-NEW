//
//  ManualTSView.m
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ManualTSView.h"
#import "CustomUIButton.h"
#import "TSSpeechRecognizer.h"
#import "TSDBManager+RecognizerResultJudge.h"

@interface ManualTSView ()
@property (nonatomic, copy) InsertDBSuccessBlock insertDBSuccessBlock;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *centerView;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *topBtnArray;
@property (nonatomic, strong) NSMutableArray *centerBtnArray;
@property (nonatomic, strong) NSMutableArray *bottomBtnArray;

@property (nonatomic, weak) UILabel *numbLab;

@property (nonatomic, strong) NSMutableDictionary *insertDBDict;
@end

@implementation ManualTSView
#pragma mark - lazy method *********************************************
- (NSMutableDictionary *)insertDBDict {
    if (!_insertDBDict) {
        _insertDBDict = [NSMutableDictionary dictionary];
    }
    return _insertDBDict;
}

- (NSMutableArray *)topBtnArray {
    if (!_topBtnArray) {
        _topBtnArray = [NSMutableArray array];
    }
    return _topBtnArray;
}

- (NSMutableArray *)centerBtnArray {
    if (!_centerBtnArray) {
        _centerBtnArray = [NSMutableArray array];
    }
    return _centerBtnArray;
}

- (NSMutableArray *)bottomBtnArray {
    if (!_bottomBtnArray) {
        _bottomBtnArray = [NSMutableArray array];
    }
    return _bottomBtnArray;
}

- (instancetype)initWithFrame:(CGRect)frame insertDBSuccessBlock:(InsertDBSuccessBlock)insertDBSuccessBlock {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _insertDBSuccessBlock = insertDBSuccessBlock;
    [self p_addSubViews];
    
    return self;
}

- (void)p_addSubViews {
    // add cover view
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_coverEventTouch)];
    [cover addGestureRecognizer:tap];
    [self addSubview:cover];
    
    // add back ground view
    CGFloat bgViewX = W(3);
    CGFloat bgViewY = H(130);
    CGFloat bgViewW = cover.width - 2*bgViewX;
    CGFloat bgViewH = H(190);
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    backgroundView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.8;
    [self addSubview:backgroundView];
    
    // add top bg view
    CGFloat topViewX = W(7);
    CGFloat topViewY = H(163);
    CGFloat topViewW = self.width - 2*topViewX;
    CGFloat topViewH = H(33);
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(topViewX, topViewY, topViewW, topViewH)];
    [self addSubview:topView];
    self.topView = topView;
    
    // add top view sub buttons
    NSArray *topBtnNames = @[@"罚篮中", @"罚篮不中", @"两分中", @"两分不中", @"三分中", @"三分不中"];
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        topBtnNames = @[@"罚篮中", @"罚篮不中", @"一分中", @"一分不中", @"两分中", @"两分不中"];
    }
    
    CGFloat MarginX = W(5);
    CGFloat topBtnW = (self.topView.width - 5*MarginX)/topBtnNames.count;
    CGFloat topBtnH = topViewH;
    [topBtnNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat topBtnX = (topBtnW + MarginX)*idx;
        
        CustomUIButton *topBtn = [CustomUIButton CustomUIButtonWithType:CustomButtonTypeRound];
        topBtn.frame = CGRectMake(topBtnX, 0, topBtnW, topBtnH);
        [topBtn setTitle:obj forState:UIControlStateNormal];
        [topBtn addTarget:self action:@selector(p_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topView addSubview:topBtn];
        
        [self.topBtnArray addObject:topBtn];
    }];
    
    // add center view
    CGFloat centerViewX = topViewX;
    CGFloat centerViewY = CGRectGetMaxY(self.topView.frame) + H(14);
    CGFloat centerViewW = topViewW;
    CGFloat centerViewH = topViewH;
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH)];
    [self addSubview:centerView];
    self.centerView = centerView;
    
    // add center view sub buttons
    NSArray *centerBtnNames = @[@"失误+1", @"抢断+1", @"犯规+1", @"助攻+1", @"盖帽+1"];
    CGFloat foulsBtnW = topBtnW*2 + MarginX;
    [centerBtnNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerBtnX = 0;
        
        if (idx > 0) {
            CustomUIButton *lastBtn = self.centerBtnArray[idx - 1];
            centerBtnX = CGRectGetMaxX(lastBtn.frame) + MarginX;
        }
        
        CustomUIButton *centerBtn = [CustomUIButton CustomUIButtonWithType:CustomButtonTypeRound];
        centerBtn.frame = CGRectMake(centerBtnX, 0, topBtnW, topBtnH);
        if (2 == idx) {
            centerBtn.width = foulsBtnW;
        }
        [centerBtn addTarget:self action:@selector(p_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn setTitle:obj forState:UIControlStateNormal];
        
        [self.centerView addSubview:centerBtn];
        
        [self.centerBtnArray addObject:centerBtn];
    }];
    
    // add bottom view
    CGFloat bottomViewX = topViewX;
    CGFloat bottomViewY = CGRectGetMaxY(self.centerView.frame) + H(11);
    CGFloat bottomViewW = topViewW;
    CGFloat bottomViewH = topViewH;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    // add bottom view sub buttons
    NSArray *bottomBtnNames = @[@"防守篮板+1", @"进攻篮板+1"];
    CGFloat bottomBtnW = foulsBtnW;
    [bottomBtnNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CustomUIButton *bottomBtn = [CustomUIButton CustomUIButtonWithType:CustomButtonTypeRound];
        bottomBtn.frame = CGRectMake(0, 0, bottomBtnW, topBtnH);
        if (1 == idx) {
            bottomBtn.x = self.bottomView.width - bottomBtnW;
        }
        [bottomBtn addTarget:self action:@selector(p_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBtn setTitle:obj forState:UIControlStateNormal];
        
        [self.bottomView addSubview:bottomBtn];
        
        [self.bottomBtnArray addObject:bottomBtn];
    }];
    
    // add show player number view
    UIView *showNumbView = [[UIView alloc] initWithFrame:CGRectMake(bottomBtnW + MarginX, 0, bottomBtnW, topBtnH)];
    showNumbView.layer.borderWidth = 1.0;
    showNumbView.layer.borderColor = [UIColor whiteColor].CGColor;
    showNumbView.layer.masksToBounds = YES;
    showNumbView.layer.cornerRadius = W(7.5);
    [self.bottomView addSubview:showNumbView];
    
    // add player number label
    CGFloat numbLabMargin = W(2.5);
    CGFloat numbW = showNumbView.width - 2*numbLabMargin;
    CGFloat numbH = showNumbView.height - 2*numbLabMargin;
    UILabel *numbLab = [[UILabel alloc] initWithFrame:CGRectMake(numbLabMargin, numbLabMargin, numbW, numbH)];
    numbLab.font = [UIFont systemFontOfSize:W(18.0)];
    numbLab.textColor = TSHEXCOLOR(0xffffff);
    numbLab.textAlignment = NSTextAlignmentCenter;
    numbLab.text = @"0";
    numbLab.layer.borderWidth = 1.0;
    numbLab.layer.borderColor = [UIColor whiteColor].CGColor;
    numbLab.layer.masksToBounds = YES;
    numbLab.layer.cornerRadius = W(7.5);
    [showNumbView addSubview:numbLab];
    self.numbLab = numbLab;
}

- (void)p_coverEventTouch {
    [self p_dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)p_dismiss {
    [self removeFromSuperview];
}

- (void)p_btnClick:(CustomUIButton *)btn {
    if ([btn.currentTitle containsString:@"中"]) {
        [self.topBtnArray enumerateObjectsUsingBlock:^(CustomUIButton *customBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([btn.currentTitle isEqualToString:customBtn.currentTitle]) {
                if (0 == idx) { // 罚篮中
                    self.insertDBDict[BnfBehaviorType] = @"1";
                    self.insertDBDict[BnfResultType] = @"1";
                } else if (1 == idx) { // 罚篮不中
                    self.insertDBDict[BnfBehaviorType] = @"1";
                    self.insertDBDict[BnfResultType] = @"0";
                } else if (2 == idx) { // 一分中／两分中
                    self.insertDBDict[BnfBehaviorType] = @"2";
                    self.insertDBDict[BnfResultType] = @"1";
                    if ([btn.currentTitle containsString:@"一分"]) {
                        self.insertDBDict[BnfBehaviorType] = @"31";
                    }
                } else if (3 == idx) { // 一分不中／两分不中
                    self.insertDBDict[BnfBehaviorType] = @"2";
                    self.insertDBDict[BnfResultType] = @"0";
                    if ([btn.currentTitle containsString:@"一分"]) {
                        self.insertDBDict[BnfBehaviorType] = @"31";
                    }
                } else if (4 == idx) { // 两分中／三分中
                    self.insertDBDict[BnfBehaviorType] = @"3";
                    self.insertDBDict[BnfResultType] = @"1";
                    if ([btn.currentTitle containsString:@"两分"]) {
                        self.insertDBDict[BnfBehaviorType] = @"2";
                    }
                } else if (5 == idx) { // 两分不中／三分不中
                    self.insertDBDict[BnfBehaviorType] = @"3";
                    self.insertDBDict[BnfResultType] = @"0";
                    if ([btn.currentTitle containsString:@"两分"]) {
                        self.insertDBDict[BnfBehaviorType] = @"2";
                    }
                }
            }
        }];
    }
    
    if ([btn.currentTitle containsString:@"篮板"]) {
        [self.bottomBtnArray enumerateObjectsUsingBlock:^(CustomUIButton *customBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([btn.currentTitle isEqualToString:customBtn.currentTitle]) {
                if (0 == idx) { // 防守篮板
                    self.insertDBDict[BnfBehaviorType] = @"5";
                } else {
                    self.insertDBDict[BnfBehaviorType] = @"4";
                }
            }
        }];
    }
    
    [self.centerBtnArray enumerateObjectsUsingBlock:^(CustomUIButton *customBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([btn.currentTitle isEqualToString:customBtn.currentTitle]) {
            if (0 == idx) { // 失误
                self.insertDBDict[BnfBehaviorType] = @"7";
            } else if (1 == idx) { // 抢断
                self.insertDBDict[BnfBehaviorType] = @"6";
            } else if (2 == idx) { // 犯规
                self.insertDBDict[BnfBehaviorType] = @"10";
            } else if (3 == idx) { // 助攻
                self.insertDBDict[BnfBehaviorType] = @"9";
            } else if (4 == idx) { // 盖帽
                self.insertDBDict[BnfBehaviorType] = @"8";
            }
        }
    }];
    
    DDLog(@"手动录入的数据为：%@", self.insertDBDict);
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSString *playerId = [tSDBManager getPlayerIdWithinsertDBDict:self.insertDBDict];
    if (0 == playerId.length) {
        DDLog(@"该球员id不存在数据库表中！！！！！！！！");
        return;
    }
    
    [tSDBManager insertObjectByInsertDBDict:self.insertDBDict playerId:playerId];
    NSString *returnString = [tSDBManager appendResultStringWithDict:self.insertDBDict];
    TSSpeechRecognizer *speechRecognizer = [TSSpeechRecognizer defaultInstance];
    [speechRecognizer.delegate onResultsString:returnString insertDBDict:self.insertDBDict recognizerResult:YES];
    
    [self p_dismiss];
}

#pragma mark - update view with data
- (void)setPlayerInfoDict:(NSDictionary *)playerInfoDict {
    _playerInfoDict = playerInfoDict;
    
    self.numbLab.text = playerInfoDict[NumbResultStr];
    [self.insertDBDict addEntriesFromDictionary:playerInfoDict];
}

- (void)dealloc {
    DDLog(@"ManualTSView ------ dealloc");
}
@end
