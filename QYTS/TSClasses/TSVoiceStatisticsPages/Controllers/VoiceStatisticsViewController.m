//
//  VoiceStatisticsViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "VoiceStatisticsViewController.h"
#import "VoiceStatisticsCell.h"
#import "TSSegmentedView.h"
#import "TSManagerViewController.h"
#import "TSSpeechRecognizer.h"
#import "TSVolumeView.h"
#import "TSGameModel.h"
#import "TSVoiceViewModel.h"
#import "LCActionSheet.h"
#import "VoicePlayersView.h"
#import "TSAbstainedView.h"
#import "VoiceBgView.h"

@interface VoiceStatisticsViewController () <TSSpeechRecognizerDelegate, LCActionSheetDelegate>
@property (nonatomic, strong) TSSpeechRecognizer *speechRecognizer;
@property (nonatomic, weak) VoiceBgView *centerView;
@property (nonatomic, weak) TSVolumeView *volumeView;
@property (nonatomic, strong) NSMutableArray *dataShowArray;
@property (nonatomic, strong) NSMutableArray *insertDBDictArray;
@property (nonatomic, strong) TSDBManager *tSDBManager;
@property (nonatomic, strong) TSGameModel *gameModel;
@property (nonatomic, weak) UIButton *submitSectionBtn;
@property (nonatomic, weak) LCActionSheet *actionSheet;
@property (nonatomic, weak) VoicePlayersView *voicePlayersView; // 显示场上球员号码
@end

@implementation VoiceStatisticsViewController
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_playerDataDidChanged:) name:PlayerDataDidChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_gotoTheNextStageGame:) name:GoToTheNextStageGame object:nil];
    }
    return self;
}

#pragma mark - lazy method ************************************************************************************
- (NSMutableArray *)dataShowArray {
    if (!_dataShowArray) {
        _dataShowArray = [NSMutableArray array];
    }
    return _dataShowArray;
}

- (NSMutableArray *)insertDBDictArray {
    if (!_insertDBDictArray) {
        _insertDBDictArray = [NSMutableArray array];
    }
    return _insertDBDictArray;
}

- (TSDBManager *)tSDBManager {
    if (!_tSDBManager) {
        _tSDBManager = [[TSDBManager alloc] init];
    }
    return _tSDBManager;
}

#pragma mark - system method ************************************************************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTopViewWithPageType:PageTypeVoice];
    
    [self p_createCenterView];
    
    [self p_createRevokeButton];
    
    [self p_createSubmitSectionButton];
    
    [self p_createBottomSegmentview];
    
    [self p_createRecoderButton];
    
    [self p_setExclusiveTouchForButtons:self.view];
    
    [self p_initSpeechRecognizer];
    
    [self p_updateStatisticsData];
    
    [self p_checkGameStatus];
}

- (void)p_checkGameStatus {
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    if (1 == [gameTableDict[GameStatus] intValue]) { // 比赛结束
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TSManagerViewController *managerVC = [[TSManagerViewController alloc] init];
            managerVC.selectPageType = SelectPageTypeFull;
            managerVC.tSDBManager = self.tSDBManager;
            managerVC.gameModel = self.gameModel;
            managerVC.currentSecond = self.topView.currentSecond;
            [self.navigationController pushViewController:managerVC animated:YES];
        });
    }
}

- (void)p_initSpeechRecognizer {
    TSSpeechRecognizer *speechRecognizer = [TSSpeechRecognizer defaultInstance];
    speechRecognizer.delegate = self;
    self.speechRecognizer = speechRecognizer;
}

#pragma mark - custom method ************************************************************************************
- (void)p_createCenterView {
    // add players view
    CGFloat playersViewX = W(10);
    CGFloat playersViewY = CGRectGetMaxY(self.topView.frame);
    CGFloat playersViewH = H(66);
    CGFloat playersViewW = self.view.width - 2*playersViewX;
    VoicePlayersView *voicePlayersView = [[VoicePlayersView alloc] initWithFrame:CGRectMake(playersViewX, playersViewY, playersViewW, playersViewH)];
    [self.view addSubview:voicePlayersView];
    self.voicePlayersView = voicePlayersView;
    
    CGFloat centerViewX = W(10);
    CGFloat centerViewY = CGRectGetMaxY(self.voicePlayersView.frame);
    CGFloat centerViewW = self.view.width - 2*centerViewX;
    CGFloat centerViewH = H(250);
    VoiceBgView *centerView = [[VoiceBgView alloc] initWithFrame:CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH)];
    [self.view addSubview:centerView];
    self.centerView = centerView;
    
    self.tableView.frame = CGRectMake(0, H(37), self.centerView.width, self.centerView.height - H(37));
    TSAbstainedView *abstainedView = [[TSAbstainedView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.width, H(37)) abstentionSuccessBlock:^{ // 弃权成功
        [self p_updateStatisticsData];
        [self p_checkGameStatus];
    }];
    [self.centerView addSubview:abstainedView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, H(50), 0);
    self.tableView.rowHeight = H(38);
    self.tableView.backgroundColor = centerView.backgroundColor;
    [centerView addSubview:self.tableView];
    [self scrollTableToFoot:YES];
    
    // createVolumView
    CGFloat volumeViewH = H(50);
    CGFloat volumeViewW = W(100);
    TSVolumeView *volumeView = [[TSVolumeView alloc] initWithFrame:CGRectMake(0, centerView.height - volumeViewH - H(11.5), volumeViewW, volumeViewH)];
    volumeView.centerX = centerView.width*0.5;
    [centerView addSubview:volumeView];
    self.volumeView = volumeView;
}

- (void)p_createRevokeButton {
    UIButton *revokeBtn = [self createButtonWithFrame:CGRectMake(W(10), CGRectGetMaxY(self.centerView.frame) + H(12), W(170), H(43)) title:@"上条错误撤回"];
    [revokeBtn addTarget:self action:@selector(p_revokeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:revokeBtn];
}

- (void)p_revokeBtnClick {
    if (0 == self.dataShowArray.count) {
        return;
    }
    
    if (self.insertDBDictArray.count) {
        [self.tSDBManager deleteObjectByInsertDBDict:[self.insertDBDictArray lastObject]];
        
        NSDictionary *insertDBDict = [self.insertDBDictArray lastObject];
        if ((11 == [insertDBDict[BnfBehaviorType] intValue]) || (12 == [insertDBDict[BnfBehaviorType] intValue])) { // 换人语音识别
            [self.voicePlayersView updatePlayersStatus];
        }
        [self.insertDBDictArray removeLastObject];
        
        [self p_updateStatisticsData];
    }
    
    [self.dataShowArray removeLastObject];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataShowArray.count inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    
    
    [self scrollTableToFoot:YES];
}

- (void)p_createSubmitSectionButton {
    CGFloat submitSectionBtnW = W(170);
    UIButton *submitSectionBtn = [self createButtonWithFrame:CGRectMake(self.view.width - submitSectionBtnW - W(10), CGRectGetMaxY(self.centerView.frame) + H(12), W(170), H(43)) title:@"提交本节"];
    [submitSectionBtn addTarget:self action:@selector(p_submitSectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    if ([stageCount isEqualToString:[StageAllArray lastObject]]) {
        submitSectionBtn.enabled = NO;
        [submitSectionBtn setTitle:GameOver forState:UIControlStateNormal];
    }
    [self.view addSubview:submitSectionBtn];
    self.submitSectionBtn = submitSectionBtn;
}

- (void)p_submitSectionBtnClick { // 提交本节数据到服务器
    if ([self.topView.startBtn.currentTitle containsString:@"停"]) {
        [SVProgressHUD showInfoWithStatus:@"停表后再提数据"];
        return;
    }
    
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"提交本节数据", nil];
    [actionSheet show];
    self.actionSheet = actionSheet;
}

- (void)p_createBottomSegmentview {
    TSWeakSelf;
    TSSegmentedView *segView = [[TSSegmentedView alloc] initWithSelectStyle:SelectStyleNone defaultSelect:DefaultSelectSection returnBlcok:^(NSUInteger index) {
        __strong __typeof(__weakSelf) strongSelf = __weakSelf;
        TSManagerViewController *managerVC = [[TSManagerViewController alloc] init];
        if (0 == index) {
            managerVC.selectPageType = SelectPageTypeSection;
        } else if (1 == index) {
            managerVC.selectPageType = SelectPageTypeFull;
        }
        managerVC.tSDBManager = strongSelf.tSDBManager;
        managerVC.gameModel = strongSelf.gameModel;
        managerVC.currentSecond = strongSelf.topView.currentSecond;
        [strongSelf.navigationController pushViewController:managerVC animated:YES];
    }];
    [self.view addSubview:segView];
}

- (void)p_setExclusiveTouchForButtons:(UIView *)myView { // 避免同时产生多个按钮事件
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]]) {
            [((UIButton *)button) setExclusiveTouch:YES];
        } else if ([button isKindOfClass:[UIView class]]) {
            [self p_setExclusiveTouchForButtons:button];
        }
    }
}

- (void)p_createRecoderButton {
    UIButton *recoderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat recoderBtnWH = W(85);
    CGFloat recoderBtnX = self.view.width*0.5 - recoderBtnWH*0.5;
    CGFloat recoderBtnY = SCREEN_HEIGHT - recoderBtnWH;
    recoderBtn.frame = CGRectMake(recoderBtnX, recoderBtnY, recoderBtnWH, recoderBtnWH);
    [recoderBtn setBackgroundImage:[UIImage imageNamed:@"statistics_Record_Image"] forState:UIControlStateNormal];
    recoderBtn.layer.cornerRadius = recoderBtnWH*0.5;
    recoderBtn.layer.masksToBounds = YES;
    [recoderBtn addTarget:self action:@selector(p_beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    [recoderBtn addTarget:self action:@selector(p_endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    [recoderBtn addTarget:self action:@selector(p_cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [recoderBtn addTarget:self action:@selector(p_remindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [recoderBtn addTarget:self action:@selector(p_remindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self.view addSubview:recoderBtn];
}

- (void)p_beginRecordVoice:(UIButton *)button { //开始录音
//    if ([self.topView.startBtn.currentTitle containsString:@"开"] && self.topView.currentSecond != 0) {
//        return;
//    }
    [self.speechRecognizer startListening];
    self.volumeView.hidden = NO;
}

- (void)p_endRecordVoice:(UIButton *)button { // 结束录音
    self.volumeView.hidden = YES;
    [self.speechRecognizer stopListening];
}

- (void)p_cancelRecordVoice:(UIButton *)button { // 手指上滑，取消识别
    self.volumeView.hidden = YES;
    [self.speechRecognizer cancel];
}

- (void)p_remindDragExit:(UIButton *)button { // 松开手指，取消识别
    self.volumeView.hidden = YES;
    [self.speechRecognizer cancel];
}

- (void)p_remindDragEnter:(UIButton *)button { // 手指上滑，取消识别
    self.volumeView.hidden = YES;
    [self.speechRecognizer cancel];
}

#pragma mark - UITableViewDataSource ************************************************************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataShowArray.count;
}

#pragma mark - UITableViewDelegate ************************************************************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceStatisticsCell *cell = [VoiceStatisticsCell cellWithTableView:tableView];
    cell.titleName = self.dataShowArray[indexPath.row];
    
    return cell;
}

#pragma mark - TSSpeechRecognizerDelegate
- (void)onResultsString:(NSString *)resultsString insertDBDict:(NSDictionary *)insertDBDict recognizerResult:(BOOL)result {
    if (result) {
        [self.dataShowArray addObject:[resultsString mutableCopy]];
        
        if (self.dataShowArray.count > 0) {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataShowArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [self scrollTableToFoot:YES];
        }
        
        [self.insertDBDictArray addObject:insertDBDict];
        
        [self p_updateStatisticsData];
    }
}

- (void)onVolumeChanged:(int)volume {
    self.volumeView.volume = volume;
}

- (void)onEndOfSpeech {
    self.volumeView.volume = 0;
    if (self.volumeView.hidden == NO) { // 如果手指还是按住状态
        [self.speechRecognizer startListening];
    }
}

#pragma mark - update game statistics method
- (void)p_updateStatisticsData {
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    [calculationTool calculationHostTotalScoreFouls];
    [calculationTool calculationGuestTotalScoreFouls];
    
    [calculationTool calculationHostStageScoreFouls];
    [calculationTool calculationGuestStageScoreFouls];
    
    [calculationTool calculationTimeOutSatgeData];
    
    self.topView.gameModel = calculationTool.gameModel;
    self.gameModel = calculationTool.gameModel;
    
    NSDictionary *insertDBDict = [self.insertDBDictArray lastObject];
    if ((11 == [insertDBDict[BnfBehaviorType] intValue]) || (12 == [insertDBDict[BnfBehaviorType] intValue])) { // 换人语音识别
        [self.voicePlayersView updatePlayersStatus];
    }
}

- (void)p_playerDataDidChanged:(NSNotification *)notif {
    
    
    [self p_updateStatisticsData];
}

- (void)p_gotoTheNextStageGame:(NSNotification *)notif {
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    int stageGameTimes = [calculationTool getCurrentStageTimes];
    if (0 == stageGameTimes) { // 3V3 加时赛
        self.topView.timeCountType = TimeCountTypeUp;
    } else {
        self.topView.timeCountType = TimeCountTypeDown;
    }
    self.topView.currentSecond = stageGameTimes;
    self.topView.countDownLab.text = @"00 : 00";
    [self p_updateStatisticsData];
}

#pragma mark - 提交本节数据到服务器
- (void)p_sendCurrentStageData {
    // 如果是最后一节，并且比分相同，则拒绝提交
    if ([self p_refuseIfDivideAndLastStage]) {
        [SVProgressHUD showInfoWithStatus:@"胜负未分，无法提交"];
        return;
    }
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    DDLog(@"currentStage is:%@", stageCount);
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    TSVoiceViewModel *voiceViewModel = [[TSVoiceViewModel alloc] initWithPramasDict:paramsDict];
    [voiceViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"up load data returnValue is:%@", returnValue);
        
        [self p_setupGameStatus]; // 更新比赛进行状态
        NSMutableDictionary *gameTableDict = [[self.tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
        if (returnValue[@"entity"][@"matchInfoId"]) {
            gameTableDict[@"matchInfoId"] = returnValue[@"entity"][@"matchInfoId"];
            [self.tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
        }
        
        [self.dataShowArray removeAllObjects];
        [self.insertDBDictArray removeAllObjects];
        [self.tableView reloadData];
        
        // 每节数据提交成功后，初始化所有球员的上场时间
        [SVProgressHUD showInfoWithStatus:@"提交成功"];
        
        if (0 == [gameTableDict[GameStatus] intValue]) {
            [self p_updateCurrentStageIfSendDataSuccess];
            [self.tSDBManager initPlayingTimesOnce];
        } else {
            [self p_pushFullManagerViewController];
        }
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [SVProgressHUD dismiss];
    }];
    [voiceViewModel sendCurrentStageData];
}

- (BOOL)p_refuseIfDivideAndLastStage {
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3分差2分以内，不能结束比赛
        if ([gameTableDict[CurrentStage] isEqualToString:OverTime1]) { // 最后一节，比分相同
            int scoreGap = abs(self.topView.gameModel.scoreTotalH.intValue - self.topView.gameModel.scoreTotalG.intValue);
            DDLog(@"scoreGap is:%d", scoreGap);
            if (scoreGap < 2) {
                return YES;
            }
        }
    } else { // 5V5平分
        if ([gameTableDict[CurrentStage] isEqualToString:OverTime3] && (self.topView.gameModel.scoreTotalH.intValue == self.topView.gameModel.scoreTotalG.intValue)) { // 最后一节，比分相同，不能结束比赛
            return YES;
        }
    }
    return NO;
}

- (void)p_updateCurrentStageIfSendDataSuccess { // 本节数据提交成功后，更新节数
    NSMutableDictionary *gameTableDict = [[self.tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
    
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        if (3 == [gameTableDict[@"sectionType"] intValue]) { // 1X10
            gameTableDict[CurrentStage] = OverTime1;
            gameTableDict[CurrentStageDataSubmitted] = @"0";
        } else if (4 == [gameTableDict[@"sectionType"] intValue]) { // 2X8
            if ([gameTableDict[CurrentStage] isEqualToString:StageOne]) {
                gameTableDict[CurrentStage] = StageTwo;
                gameTableDict[CurrentStageDataSubmitted] = @"0";
            } else if ([gameTableDict[CurrentStage] isEqualToString:StageTwo]) {
                gameTableDict[CurrentStage] = OverTime1;
                gameTableDict[CurrentStageDataSubmitted] = @"0";
            }
        }
    } else { // 5V5
        [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageName, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([gameTableDict[CurrentStage] isEqualToString:stageName]) {
                if (idx == 6) { // 加时赛3（表示全场比赛彻底结束）
                    gameTableDict[CurrentStageDataSubmitted] = @"1";
                    self.submitSectionBtn.enabled = NO;
                    [self.submitSectionBtn setTitle:GameOver forState:UIControlStateNormal];
                    [self p_pushFullManagerViewController];
                } else {
                    gameTableDict[CurrentStage] = StageAllArray[idx + 1];
                    gameTableDict[CurrentStageDataSubmitted] = @"0";
                }
                
                *stop = YES;
            }
        }];
    }
    
    [self.tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
    
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    int stageGameTimes = [calculationTool getCurrentStageTimes];
    if (0 == stageGameTimes) { // 3V3 加时赛
        self.topView.timeCountType = TimeCountTypeUp;
    } else {
        self.topView.timeCountType = TimeCountTypeDown;
    }
    self.topView.currentSecond = stageGameTimes;
    self.topView.countDownLab.text = @"00 : 00";
    [self p_updateStatisticsData];
    
    DDLog(@"数据提交成功:%@", [self.tSDBManager getObjectById:GameId fromTable:GameTable]);
}

- (void)p_setupGameStatus { // 设置比赛状态（结束或未结束）
    // 本节提交成功，标记为已提交
    NSMutableDictionary *gameTableDict0 = [[self.tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
    gameTableDict0[CurrentStageDataSubmitted] = @"1";
    [self.tSDBManager putObject:gameTableDict0 withId:GameId intoTable:GameTable];
    
    __block BOOL gameOver = NO;
    NSMutableDictionary *gameTableDict = [[self.tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        if (3 == [gameTableDict[@"sectionType"] intValue]) { // 1X10
            if (self.topView.gameModel.scoreTotalH.intValue != self.topView.gameModel.scoreTotalG.intValue) { // 比赛结束
                gameOver = YES;
            }
        } else if (4 == [gameTableDict[@"sectionType"] intValue]) { // 2X8
            if ([gameTableDict[CurrentStage] isEqualToString:StageTwo] || [gameTableDict[CurrentStage] isEqualToString:OverTime1]) {
                if (self.topView.gameModel.scoreTotalH.intValue != self.topView.gameModel.scoreTotalG.intValue) { // 比赛结束
                    gameOver = YES;
                }
            }
        }
    } else {
        [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageCount, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([stageCount isEqualToString:gameTableDict[CurrentStage]]) {
                if (idx > 2) {
                    if (self.topView.gameModel.scoreTotalH.intValue != self.topView.gameModel.scoreTotalG.intValue) { // 比赛结束
                        gameOver = YES;
                    }
                }
            }
        }];
    }
    
    if (gameOver == YES) { // 比赛结束
        gameTableDict[GameStatus] = @"1";
    } else {
        gameTableDict[GameStatus] = @"0";
    }
    [self.tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
    
    DDLog(@"gameTableDict is ------ :%@", [self.tSDBManager getObjectById:GameId fromTable:GameTable]);
}

// LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.actionSheet) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.actionSheet name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        self.actionSheet = nil;
    }
    
    if (1 == buttonIndex) {
        [self p_sendCurrentStageData];
    }
}

- (void)p_pushFullManagerViewController { // push到全场比赛技术统计页面
    TSManagerViewController *managerVC = [[TSManagerViewController alloc] init];
    managerVC.selectPageType = SelectPageTypeFull;
    managerVC.tSDBManager = self.tSDBManager;
    managerVC.gameModel = self.gameModel;
    managerVC.currentSecond = self.topView.currentSecond;
    [self.navigationController pushViewController:managerVC animated:YES];
}
@end
