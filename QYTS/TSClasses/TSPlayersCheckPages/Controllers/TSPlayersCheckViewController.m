//
//  TSPlayersCheckViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPlayersCheckViewController.h"
#import "PlayersCheckCell.h"
#import "UIImage+Extension.h"
#import "PlayersCheckHeaderView.h"
#import "TSCheckModel.h"
#import "PlayerCheckViewModel.h"
#import "TSPlayerModel.h"
#import "YTKKeyValueStore.h"
#import "IsStartTipsView.h"
#import "TSPayManagerView.h"
#import "WXApi.h"
#import "TSPayManagerView.h"
#import "TSPayViewModel.h"
#import "TSPaySuccessView.h"
#import "OnceComboModel.h"

typedef NS_ENUM(NSInteger, GameAuth) {
    GameAuthNotPay,// 不需要支付，直接进入比赛
    GameAuthPaySuccess//支付成功
};

@interface TSPlayersCheckViewController () <PlayersCheckCellDelegate>
@property (nonatomic, strong) NSMutableArray *playerArrayH;
@property (nonatomic, strong) NSMutableArray *playerArrayG;
@end

@implementation TSPlayersCheckViewController
#pragma mark - lazy method ****************************************************************
- (NSMutableArray *)playerArrayH {
    if (!_playerArrayH) {
        _playerArrayH = [NSMutableArray array];
    }
    return _playerArrayH;
}

- (NSMutableArray *)playerArrayG {
    if (!_playerArrayG) {
        _playerArrayG = [NSMutableArray array];
    }
    return _playerArrayG;
}

- (void)p_showStartTipsIfNeeded {
    if (0 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"startTipsShow"] length]) {
        IsStartTipsView *startTipsView = [[IsStartTipsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [startTipsView show];
        [[NSUserDefaults standardUserDefaults] setObject:@"startTipsShow" forKey:@"startTipsShow"];
    }
}

- (void)p_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_paySuccessNotif:) name:TSPaySuccessNotifName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_appDidBecomeActive) name:TSDidBecomeActiveNotif object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"球队球员检录" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self showNavgationBarBottomLine];
    
    [self setupTableViewStyle];
    
    [self p_createSubmitButton];
    
    [self p_getPlaysData];
    
    [self p_addNotification];
}

- (void)p_getPlaysData {
    [self p_getPlaysDataByTeamId:self.checkModel.homeTeamId];
    [self p_getPlaysDataByTeamId:self.checkModel.awayTeamId];
}

- (void)p_getPlaysDataByTeamId:(NSString *)teamId {
    [self.indicatorView showWithView:self.view];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"teamId"] = teamId;
    
    // 获取用户类型，根据用户类型确定是否需要默认5个首发球员
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    PlayerCheckViewModel *checkViewModel = [[PlayerCheckViewModel alloc] initWithPramasDict:paramsDict];
    [checkViewModel setBlockWithReturnBlock:^(id returnValue) {
        if ([teamId isEqualToString:self.checkModel.homeTeamId]) { // 主队球员数据
//            DDLog(@"host returnValue is:%@", returnValue);
            if (returnValue[@"entity"][@"playInfos"]) {
                self.playerArrayH = [TSPlayerModel mj_objectArrayWithKeyValuesArray:returnValue[@"entity"][@"playInfos"]];
                // 设置球员默认的本场号码
                if (self.playerArrayH.count) {
                    __block NSString *allselectedNumb = @"";
                    [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (playerModel.playerNumber.length) {
                            playerModel.gameNum = playerModel.playerNumber;
                        } else {
                            playerModel.gameNum = @"0";
                        }
                        allselectedNumb = [allselectedNumb stringByAppendingString:[NSString stringWithFormat:@",%@,", playerModel.gameNum]];
                        playerModel.isStartPlayer = @"否";
                        playerModel.playingStatus = @"0"; // 上场状态
                        if (1 == self.checkModel.ruleType.intValue) { // 5V5
                            if (idx < 5 && (currentUserType == LoginUserTypeNormal)) {
                                playerModel.isStartPlayer = @"是";
                                playerModel.playingStatus = @"1";
                            }
                        } else if (2 == self.checkModel.ruleType.intValue) {
                            if (idx < 3 && (currentUserType == LoginUserTypeNormal)) {
                                playerModel.isStartPlayer = @"是";
                                playerModel.playingStatus = @"1";
                            }
                        }
                        playerModel.playingTimes = @"0"; // 设置上场时间
                    }];
                    
                    [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        playerModel.allSelectedNumb = allselectedNumb;
                    }];
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        } else if ([teamId isEqualToString:self.checkModel.awayTeamId]) { // 客队球员数据
//            DDLog(@"guest returnValue is:%@", returnValue);
            if (returnValue[@"entity"][@"playInfos"]) {
                self.playerArrayG = [TSPlayerModel mj_objectArrayWithKeyValuesArray:returnValue[@"entity"][@"playInfos"]];
                if (self.playerArrayG.count) {
                    __block NSString *allselectedNumb = @"";
                    [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (playerModel.playerNumber.length) {
                            playerModel.gameNum = playerModel.playerNumber;
                        } else {
                            playerModel.gameNum = @"0";
                        }
                        allselectedNumb = [allselectedNumb stringByAppendingString:[NSString stringWithFormat:@",%@,", playerModel.gameNum]];
                        playerModel.isStartPlayer = @"否";
                        playerModel.playingStatus = @"0"; // 上场状态
                        if (1 == self.checkModel.ruleType.intValue) {
                            if (idx < 5 && (currentUserType == LoginUserTypeNormal)) {
                                playerModel.isStartPlayer = @"是";
                                playerModel.playingStatus = @"1";
                            }
                        } else if (2 == self.checkModel.ruleType.intValue) {
                            if (idx < 3 && (currentUserType == LoginUserTypeNormal)) {
                                playerModel.isStartPlayer = @"是";
                                playerModel.playingStatus = @"1";
                            }
                        }
                        playerModel.playingTimes = @"0"; // 设置上场时间
                    }];
                    
                    [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        playerModel.allSelectedNumb = allselectedNumb;
                    }];
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self p_showStartTipsIfNeeded];
                }
            }
        }
        [self.indicatorView dismiss];
    } WithErrorBlock:^(id errorCode) {
        [self.indicatorView dismiss];
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [self.indicatorView dismiss];
    }];
    
    if (currentUserType == LoginUserTypeNormal) { // 群众赛事进入球员检录页
        [checkViewModel getPlaysDataByTeamNormal];
    } else if (currentUserType == LoginUserTypeBCBC) { // BCBC赛事进入球员检录页
        [checkViewModel getPlaysDataByTeamBCBC];
    } else if (currentUserType == LoginUserTypeCBO) { // CBO赛事进入球员检录页
        [checkViewModel getPlaysDataByTeamCBO];
    }
}

- (void)setupTableViewStyle {
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, H(85), 0);
    self.tableView.y += H(4);
    self.tableView.rowHeight = H(46);
}

- (void)p_createSubmitButton {
    CGFloat bottomViewH = H(78);
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomViewH, self.view.width, bottomViewH)];
    bottomView.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:bottomView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat MarginX = W(25);
    CGFloat submitBtnH = H(43);
    CGFloat submitBtnY = (bottomView.height - submitBtnH)*0.5;
    CGFloat submitBtnW = bottomView.width - 2*MarginX;
    
    submitBtn.frame = CGRectMake(MarginX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn setTitle:@"进入比赛" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [submitBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(submitBtnW, submitBtnH)] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(submitBtnW, submitBtnH)] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = submitBtnH*0.5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(p_submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitBtn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.playerArrayH.count;
    }
    
    if (1 == section) {
        return self.playerArrayG.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayersCheckCell *cell = [PlayersCheckCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    if (0 == indexPath.section) {
        cell.playerModel = self.playerArrayH[indexPath.row];
        if (self.playerArrayH.count - 1 == indexPath.row) {
            cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } else {
            cell.rectCornerStyle = UIRectCornerAllCorners;
        }
    } else if (1 == indexPath.section) {
        cell.playerModel = self.playerArrayG[indexPath.row];
        if (self.playerArrayG.count - 1 == indexPath.row) {
            cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } else {
            cell.rectCornerStyle = UIRectCornerAllCorners;
        }
    }
    cell.delegate = self;
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlayersCheckHeaderView *headerView;
    if (0 == section) {
        headerView = [[PlayersCheckHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(33)) teamType:TeamTypeHost];
    } else {
        headerView = [[PlayersCheckHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(33)) teamType:TeamTypeGuest];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return H(33);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (0 == section) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(10))];
        return footView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (0 == section) {
        return H(10);
    }
    
    return .1f;
}

- (void)p_initTSDB {
    NSMutableDictionary *gameCheckDict = self.checkModel.mj_keyValues;
    //    DDLog(@"gameCheckDict is:%@", gameCheckDict);
    
    [gameCheckDict setObject:@"0" forKey:GameIsFinished];
    [gameCheckDict setObject:@"0" forKey:GameIsSubmitAll];
    
    NSMutableArray *playerArrayH = [TSPlayerModel mj_keyValuesArrayWithObjectArray:self.playerArrayH];
    //    DDLog(@"playerArrayH is:%@", playerArrayH);
    
    NSMutableArray *playerArrayG = [TSPlayerModel mj_keyValuesArrayWithObjectArray:self.playerArrayG];
    //    DDLog(@"playerArrayG is:%@", playerArrayG);
    
    // 创建数据库和数据库表
    NSString *documentsPath = nil;
    NSArray *appArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([appArray count] > 0) {
        documentsPath = [appArray objectAtIndex:0];
    }
    NSString *tsdbPath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", TSDBName]];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initWithDBWithPath:tsdbPath];
    [store createTableWithName:TSCheckTable]; // 创建检录数据表
    
    
    
    // 往检录数据表中插入“赛前检录”数据
    [store putObject:gameCheckDict withId:GameCheckID intoTable:TSCheckTable];
    
    
    // 往检录数据表中插入“主队球员检录”数据
    [store putObject:playerArrayH withId:TeamCheckID_H intoTable:TSCheckTable];
    
    
    // 往检录数据表中插入“客队球员检录”数据
    [store putObject:playerArrayG withId:TeamCheckID_G intoTable:TSCheckTable];
    
//    DDLog(@"TSCheckTable data is:%@", [store getObjectById:TeamCheckID_H fromTable:TSCheckTable]);
    
    [store createTableWithName:GameTable];
    // 往“比赛数据表”中写入第一节标记
    NSMutableDictionary *gameTableDict = [NSMutableDictionary dictionary];
    gameTableDict[CurrentStage] = StageOne;
    gameTableDict[CurrentStageDataSubmitted] = @"0";
    gameTableDict[@"matchInfoId"] = self.checkModel.matchId;
    if (self.checkModel.ruleType) {
        gameTableDict[@"ruleType"] = [NSString stringWithFormat:@"%@", self.checkModel.ruleType];
    } else {
        gameTableDict[@"ruleType"] = @"1";
    }
    if (self.checkModel.sectionType) {
        gameTableDict[@"sectionType"] = [NSString stringWithFormat:@"%@", self.checkModel.sectionType];
    } else {
        gameTableDict[@"sectionType"] = @"1";
    }
    [store putObject:gameTableDict withId:GameId intoTable:GameTable];
    
    [store createTableWithName:PlayerTable];
    
    [store createTableWithName:PlayerIdTable]; // 创建一张球员id表，用于查询球员表中的数据
    // 根据“球员检录”信息，往“球员id表”中写入数据
    NSMutableArray *playerIdArray = [NSMutableArray array];
    [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *playerIdDict = [NSMutableDictionary dictionary];
        [playerIdDict setObject:playerModel.ID forKey:[NSString stringWithFormat:@"%@+%@", @"0", playerModel.gameNum]];
        [playerIdArray addObject:playerIdDict];
    }];
    
    [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *playerIdDict = [NSMutableDictionary dictionary];
        [playerIdDict setObject:playerModel.ID forKey:[NSString stringWithFormat:@"%@+%@", @"1", playerModel.gameNum]];
        [playerIdArray addObject:playerIdDict];
    }];
    [store putObject:playerIdArray withId:GameId intoTable:PlayerIdTable];
}

- (void)p_submitBtnClick { // 进入比赛
    // 检测首发队员是否5人
    __block NSInteger startPlayerCountH = 0;
    [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([playerModel.isStartPlayer isEqualToString:@"是"]) {
            startPlayerCountH ++;
        }
    }];
    
    if ((1 == self.checkModel.ruleType.intValue) && (startPlayerCountH != 5)) {
        [SVProgressHUD showInfoWithStatus:@"主队首发球员不是5人"];
        return;
    }
    
    if ((2 == self.checkModel.ruleType.intValue) && (startPlayerCountH != 3)) {
        [SVProgressHUD showInfoWithStatus:@"主队首发球员不是3人"];
        return;
    }
    
    
    __block NSInteger startPlayerCountG = 0;
    [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([playerModel.isStartPlayer isEqualToString:@"是"]) {
            startPlayerCountG ++;
        }
    }];
    
    if ((1 == self.checkModel.ruleType.intValue) && startPlayerCountG != 5) {
        [SVProgressHUD showInfoWithStatus:@"客队首发球员不是5人"];
        return;
    }
    
    if ((2 == self.checkModel.ruleType.intValue) && startPlayerCountG != 3) {
        [SVProgressHUD showInfoWithStatus:@"客队首发球员不是3人"];
        return;
    }
    
    // 检测“本场号码”是否有重复
    NSMutableArray *gameNumbArrayH = [NSMutableArray array];
    [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [gameNumbArrayH addObject:playerModel.gameNum];
    }];
    NSSet *gameNumbSetH = [NSSet setWithArray:gameNumbArrayH];
    if (gameNumbArrayH.count != gameNumbSetH.count) {
        [SVProgressHUD showInfoWithStatus:@"主队有重复号码"];
        return;
    }
    
    NSMutableArray *gameNumbArrayG = [NSMutableArray array];
    [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [gameNumbArrayG addObject:playerModel.gameNum];
    }];
    NSSet *gameNumbSetG = [NSSet setWithArray:gameNumbArrayG];
    if (gameNumbArrayG.count != gameNumbSetG.count) {
        [SVProgressHUD showInfoWithStatus:@"客队有重复号码"];
        return;
    }
    
    [self p_checkUserAccountWithGameAuth:GameAuthNotPay];
}

- (void)p_checkUserAccountWithGameAuth:(GameAuth)gameAuth { // 检查用户账户，无需支付或者支付成功，都走该接口进入比赛页面
    if (self.checkModel.matchId.length) {
        [SVProgressHUD show];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        paramsDict[@"matchId"] = self.checkModel.matchId;
        if (self.checkModel.ruleType.length) {
            paramsDict[@"ruleType"] = self.checkModel.ruleType;
        } else {
            paramsDict[@"ruleType"] = @"1";
        }
        TSPayViewModel *payViewModel = [[TSPayViewModel alloc] initWithParamsDict:paramsDict];
        [payViewModel setBlockWithReturnBlock:^(id returnValue) {
            DDLog(@"checkUserAccount returnValue is:%@", returnValue);
            
            if ([returnValue[@"success"] isEqual:@1]) { // 用户无需购买
                [self p_gotoStatisticsPageWithGameAuth:gameAuth];
            } else if ([returnValue[@"success"] isEqual:@0] && [returnValue[@"reason"] isEqualToString:@"buy"]) { // 需要购买
                [self p_getOnceCombo];
            }
        } WithErrorBlock:^(id errorCode) {
            [SVProgressHUD showInfoWithStatus:errorCode];
        } WithFailureBlock:^{
        }];
        
        int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
        if (currentUserType == LoginUserTypeNormal) {
            [payViewModel checkNormalAccountStatus];
        } else if (currentUserType == LoginUserTypeBCBC) {
            [payViewModel checkBCBCAccountStatus];
        } else if (currentUserType == LoginUserTypeCBO) {
            [payViewModel checkCBOAccountStatus];
        }
    }
}

- (void)p_getOnceCombo { // 如需支付，获取一次支付的价格
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if (self.checkModel.ruleType.length) {
        paramsDict[@"ruleType"] = self.checkModel.ruleType;
    } else {
        paramsDict[@"ruleType"] = @"1";
    }
    TSPayViewModel *payViewModel = [[TSPayViewModel alloc] initWithParamsDict:paramsDict];
    [payViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"checkUserAccount returnValue is:%@", returnValue);
        OnceComboModel *onceComboModel = returnValue;
        [self p_createPayViewWithModel:onceComboModel];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [payViewModel getOnceCombo];
}

- (void)p_createPayViewWithModel:(OnceComboModel *)onceComboModel {
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showSuccessWithStatus:@"请先安装微信，才能使用微信进行支付"];
        return;
    }
    
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = NO;
    TSPayManagerView *payManager = [[TSPayManagerView alloc] initWithFrame:self.view.bounds selectPayTypeReturnBlock:^(SelectPayType payType) {
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        paramsDict[@"comboId"] = onceComboModel.ID;
        TSPayViewModel *payViewModel = [[TSPayViewModel alloc] initWithParamsDict:paramsDict];
        
        if (payType == SelectPayTypeWeiXin) { // 微信支付
            payViewModel.payType = PayTypeWXPay;
        } else if (payType == SelectPayTypeZhiFuBao) { // 支付宝支付
            payViewModel.payType = PayTypeAliPay;
        }
        
        [payViewModel setBlockWithReturnBlock:^(id returnValue) {
            
        } WithErrorBlock:^(id errorCode) {
            [SVProgressHUD showInfoWithStatus:errorCode];
            self.view.userInteractionEnabled = YES;
        } WithFailureBlock:^{
            self.view.userInteractionEnabled = YES;
        }];
        [payViewModel getPayOrderId];
    } selectPayTypeCanceledBlock:^{
        self.view.userInteractionEnabled = YES;
    }];
    payManager.onceComboPrice = onceComboModel.price;
    [payManager show];
}

- (void)p_paySuccessNotif:(NSNotification *)notif { // 接收到支付结果的通知
    NSString *payResult = notif.object;
    if ([payResult isEqualToString:@"0"]) { // 支付失败
        self.view.userInteractionEnabled = YES;
    } else { // 支付成功
        [self p_checkUserAccountWithGameAuth:GameAuthPaySuccess];
    }
}

- (void)p_gotoStatisticsPageWithGameAuth:(GameAuth)gameAuth { // 进入比赛页面
    int duration = 0.0;
    
    TSPaySuccessView *paySuccessView = [[TSPaySuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (gameAuth == GameAuthPaySuccess) {
        [paySuccessView show];
        duration = 3.0;
    }
    
    [self p_initTSDB];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [paySuccessView dismiss];
        [(AppDelegate *)[UIApplication sharedApplication].delegate setVoicePageBeRootView];
    });
}

- (void)p_appDidBecomeActive { // app回到前台
    self.view.userInteractionEnabled = YES;
}

#pragma mark - PlayersCheckCellDelegate
- (void)reloadTableViewWithSection:(int)section {
    if (0 == section) {
        __block NSString *allselectedNumb = @"";
        [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
            allselectedNumb = [allselectedNumb stringByAppendingString:[NSString stringWithFormat:@",%@,", playerModel.gameNum]];
        }];
        
        [self.playerArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
            playerModel.allSelectedNumb = allselectedNumb;
        }];
    } else {
        __block NSString *allselectedNumb = @"";
        [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
            allselectedNumb = [allselectedNumb stringByAppendingString:[NSString stringWithFormat:@",%@,", playerModel.gameNum]];
        }];
        
        [self.playerArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
            playerModel.allSelectedNumb = allselectedNumb;
        }];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TSPaySuccessNotifName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TSDidBecomeActiveNotif object:nil];
}
@end
