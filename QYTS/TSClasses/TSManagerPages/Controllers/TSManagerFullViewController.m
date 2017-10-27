//
//  TSManagerFullViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSManagerFullViewController.h"
#import "TSPlayerDataCell.h"
#import "TSPlayerSectionView.h"
#import "TSManagerPlayerModel.h"
#import "FullGameTableHeadView.h"
#import "TSGameModel.h"
#import "TSPlayerModel.h"
#import "LCActionSheet.h"
#import "TSShareViewController.h"
#import "PersonalViewModel.h"

@interface TSManagerFullViewController () <LCActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray *hostPlayerDataArray;
@property (nonatomic, strong) NSMutableArray *guestPlayerDataArray;

@property (nonatomic, strong) FullGameTableHeadView *headView;

@property (nonatomic, strong) TSPlayerSectionView *sectionViewH;
@property (nonatomic, strong) TSPlayerSectionView *sectionViewG;

@property (nonatomic, strong) TSGameModel *gameModel;

@property (nonatomic, weak) UIButton *submitOvertimeBtn;
@property (nonatomic, weak) UIButton *submitSectionBtn;

@property (nonatomic, weak) LCActionSheet *actionSheet;
@end

@implementation TSManagerFullViewController
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_playerDataDidChanged:) name:PlayerDataDidChanged object:nil];
    }
    return self;
}

- (FullGameTableHeadView *)headView {
    if (!_headView) {
        _headView = [[FullGameTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(87))];
    }
    return _headView;
}
- (TSPlayerSectionView *)sectionViewH {
    if (!_sectionViewH) {
        _sectionViewH = [[TSPlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(38))];
        NSDictionary *gameCheckDict = [self.tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
        _sectionViewH.teamName = gameCheckDict[@"homeTeamName"];
        _sectionViewH.changeBtn.hidden = YES;
    }
    return _sectionViewH;
}

- (TSPlayerSectionView *)sectionViewG {
    if (!_sectionViewG) {
        _sectionViewG = [[TSPlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(38))];
        NSDictionary *gameCheckDict = [self.tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
        _sectionViewG.teamName = gameCheckDict[@"awayTeamName"];
        _sectionViewG.changeBtn.hidden = YES;
    }
    return _sectionViewG;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupTopView];
    
    [self p_createTableView];
    
    [self p_createBottomSumitButtons];
    
    [self p_fetchGameData];
    
    [self p_setupHostPlayerData]; // 设置主队球员数据
    
    [self p_setupGuestPlayerData]; // 设置客队球员数据
}

- (void)p_setupTopView {
    [self addTopViewWithPageType:PageTypeFull];
    self.topView.height -= H(20);
}

- (void)p_createTableView {
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(self.topView.frame) + H(8);
    CGFloat tableViewW = self.view.width;
    CGFloat tableViewH = SCREEN_HEIGHT - tableViewY - H(58);
    self.tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    self.tableView.rowHeight = H(94.5);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, H(75), 0);
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
}

- (void)p_fetchGameData {
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    [calculationTool calculationHostTotalScoreFouls];
    [calculationTool calculationGuestTotalScoreFouls];
    [calculationTool calculationHostStageScoreFouls];
    [calculationTool calculationGuestStageScoreFouls];
    [calculationTool calculationTimeOutGameData];
    
    [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageCount, NSUInteger idx, BOOL * _Nonnull stop) {
        [calculationTool calculationHostStageScoreFoulsWithStageCount:stageCount];
        [calculationTool calculationGuestStageScoreFoulsWithStageCount:stageCount];
    }];
    
    self.gameModel = calculationTool.gameModel;
    self.topView.gameModel = calculationTool.gameModel;
    self.headView.gameModel = self.gameModel;
    
    // 修改“分享”按钮的状态
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    if (1 == [gameTableDict[GameStatus] intValue]) {
        self.submitSectionBtn.enabled = YES;
    }
}

- (void)p_setupHostPlayerData {
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    self.hostPlayerDataArray = [calculationTool calculationallHostPlayerFullData];
}

- (void)p_setupGuestPlayerData {
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    self.guestPlayerDataArray = [calculationTool calculationallGuestPlayerFullData];
}

- (void)p_createBottomSumitButtons {
    // add bgView
    CGFloat bgViewX = 0;
    CGFloat bgViewW = self.view.width;
    CGFloat bgViewH = H(75);
    CGFloat bgViewY = SCREEN_HEIGHT - H(50) - bgViewH;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:bgView];
    
    CGFloat submitOvertimeBtnX = W(10);
    CGFloat submitOvertimeBtnW = W(170);
    CGFloat submitOvertimeBtnH = H(43);
    CGFloat submitOvertimeBtnY = (bgView.height - submitOvertimeBtnH)*0.5;
    UIButton *submitOvertimeBtn = [self createButtonWithFrame:CGRectMake(submitOvertimeBtnX, submitOvertimeBtnY, submitOvertimeBtnW, submitOvertimeBtnH) title:@"进入下一场比赛"];
    [submitOvertimeBtn addTarget:self action:@selector(p_submitOvertimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submitOvertimeBtn];
    self.submitOvertimeBtn = submitOvertimeBtn;
    
    CGFloat submitSectionBtnX = bgView.width - submitOvertimeBtnW - submitOvertimeBtnX;
    UIButton *submitSectionBtn = [self createButtonWithFrame:CGRectMake(submitSectionBtnX, submitOvertimeBtnY, submitOvertimeBtnW, submitOvertimeBtnH) title:@"分享"];
    submitSectionBtn.enabled = NO;
    [submitSectionBtn addTarget:self action:@selector(p_endCurrentGameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submitSectionBtn];
    self.submitSectionBtn = submitSectionBtn;
}

- (void)p_submitOvertimeBtnClick:(UIButton *)overtimeBtn {
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    if (0 == [gameTableDict[GameStatus] intValue]) { // 比赛未结束
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"本场比赛尚未结束，是否作废？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"作废", nil];
        [actionSheet show];
        self.actionSheet = actionSheet;
    } else {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"是否确定进入下一场比赛？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [actionSheet show];
        self.actionSheet = actionSheet;
    }
}

- (void)p_endCurrentGameBtnClick:(UIButton *)endGameBtn { // 比赛结束才能分享
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    if (0 == [gameTableDict[GameStatus] intValue]) { // 比赛未结束
        [SVProgressHUD showInfoWithStatus:@"比赛结束才能分享"];
        return;
    }
    
    TSShareViewController *shareVC = [[TSShareViewController alloc] init];
    
    shareVC.matchInfoId = [gameTableDict[@"matchId"] length]? gameTableDict[@"matchId"]:gameTableDict[@"matchInfoId"];
    
    
    
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.hostPlayerDataArray.count;
    } else if (1 == section) {
        return self.guestPlayerDataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPlayerDataCell *cell = [TSPlayerDataCell cellWithTableView:tableView];
    if (0 == indexPath.section) {
        cell.playerModel = self.hostPlayerDataArray[indexPath.row];
    } else if (1 == indexPath.section) {
        cell.playerModel = self.guestPlayerDataArray[indexPath.row];
    }
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        self.sectionViewH.teamType = @"主队：";
        
        return self.sectionViewH;
    } else if (1 == section) {
        self.sectionViewG.teamType = @"客队：";
        
        return self.sectionViewG;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return H(38);
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(11.5))];
//    footView.backgroundColor = self.view.backgroundColor;
//    return footView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return H(11.5);
//}

- (void)p_playerDataDidChanged:(NSNotification *)notif { // 刷新数据的通知
    [self p_fetchGameData];
    [self p_setupHostPlayerData]; // 设置主队球员数据
    [self p_setupGuestPlayerData]; // 设置客队球员数据
    [self.tableView reloadData];
}

// LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.actionSheet) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.actionSheet name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        self.actionSheet = nil;
    }
    
    if ([actionSheet.title containsString:@"作废"]) { // 作废本场比赛
        if (1 == buttonIndex) {
            [self p_matchBlankOut];
            [[NSNotificationCenter defaultCenter] postNotificationName:TSremoveArr object:nil];
        }
        return;
    }
    
    if ([actionSheet.title containsString:@"下一场"]) {
        if (1 == buttonIndex) {
            
            [self p_initLocalDataBase];
            [[NSNotificationCenter defaultCenter] postNotificationName:TSremoveArr object:nil];
        }
    }
}

- (void)p_matchBlankOut { // 调用作废本场比赛的接口
    [SVProgressHUD show];
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    paramsDict[@"matchId"] = gameTableDict[@"matchInfoId"];
    DDLog(@"matchBlankOut gameTableDict is:%@", gameTableDict);
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"matchBlankOut returnValue is:%@", returnValue);
        [SVProgressHUD dismiss];
        [self p_initLocalDataBase];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
        [self p_initLocalDataBase];
    } WithFailureBlock:^{
    }];
    [personalViewModel matchBlankOut];
}

- (void)p_initLocalDataBase {
//    NSString *documentsPath = nil;
//    NSArray *appArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    documentsPath = [appArray objectAtIndex:0];
//    NSString *tsdbPath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", TSDBName]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:tsdbPath error:nil];
    NSMutableDictionary *gameTableDict = [[self.tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
    gameTableDict[GameStatus] = @"1";
    
    [_tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [(AppDelegate *)[UIApplication sharedApplication].delegate setGuidPageBeRootView];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
