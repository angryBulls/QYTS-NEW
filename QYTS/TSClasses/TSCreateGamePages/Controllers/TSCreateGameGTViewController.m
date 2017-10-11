//
//  TSCreateGameGTViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSCreateGameGTViewController.h"
#import "PreGameCheckNormalViewController.h"
#import "TSCreateGameModel.h"
#import "CreateGameViewModel.h"
#import "TSDBManager.h"
#import "GameSelectViewController.h"
#import "CreateGameTextfieldView.h"
#import "MyGameOverListModel.h"

@interface TSCreateGameGTViewController () <CreateGame1CellDelegate, CreateGame2CellDelegate, CreateGameTextfieldViewDelegate>
@property (nonatomic, weak) CreateGameTextfieldView *gameNameTextfieldView;
@end

@implementation TSCreateGameGTViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupTableViewStyle];
    
    [self p_createBottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self p_fetchData];
}

- (void)p_setupTableViewStyle {
    [self setupTableViewWithEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - H(190));
}

- (void)p_fetchData {
//    NSMutableArray *section3ModelArray = [NSMutableArray array];
//    for (int i = 0; i < 6; i ++) {
//        TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
//        if (0 == i) {
//            model.leftTitle = @"客队名称：";
//            model.name = @"";
//        } else {
//            model.leftTitle = @"球员姓名：";
//            if (1 == i) {
//                model.leftTitle = @"队长姓名：";
//            }
//            model.name = @"";
//            model.rightTitle = @"手机号：";
//            model.phone = @"";
//        }
//        [section3ModelArray addObject:model];
//    }
    
    TSCreateGameModel *model = self.createGameModelArray[0][1];
    if (self.createGameModelArray.count > 2) {
        if ([model.selectValue isEqualToString:@"5V5"]) {
            self.createGameModelArray[2] = [self getPlayerDataWithRuleType:1];
        } else {
            self.createGameModelArray[2] = [self getPlayerDataWithRuleType:2];
        }
    } else {
        if ([model.selectValue isEqualToString:@"5V5"]) {
            [self.createGameModelArray addObject:[self getPlayerDataWithRuleType:1]];
        } else {
            [self.createGameModelArray addObject:[self getPlayerDataWithRuleType:2]];
        }
    }
    
    [self.tableView reloadData];
}

- (void)p_createBottomView {
    // add bgView
    CGFloat bgViewX = 0;
    CGFloat bgViewW = self.view.width;
    CGFloat bgViewH = H(190);
    CGFloat bgViewY = SCREEN_HEIGHT - bgViewH;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:bgView];
    
    CGFloat btnW = W(170);
    CGFloat btnH = H(43);
    CGFloat btnY = bgViewH - btnH - H(40);
    
    CGFloat saveBtnX = W(10);
    UIButton *saveCheckBtn = [self createButtonWithFrame:CGRectMake(saveBtnX, btnY, btnW, btnH) title:@"保存"];
    [saveCheckBtn addTarget:self action:@selector(p_saveCheckBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:saveCheckBtn];
    
    CGFloat gameCheckBtnX = self.view.width - btnW - saveBtnX;
    UIButton *gameCheckBtn = [self createButtonWithFrame:CGRectMake(gameCheckBtnX, btnY, btnW, btnH) title:@"进入赛前检录"];
    [gameCheckBtn addTarget:self action:@selector(p_gameCheckBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:gameCheckBtn];
    
    // add game name textfield view
    CGFloat MarginX = W(8);
    CGFloat gameNameTextfieldViewW = bgView.width - 2*MarginX;
    CGFloat gameNameTextfieldViewH = H(45);
    CreateGameTextfieldView *gameNameTextfieldView = [[CreateGameTextfieldView alloc] initWithFrame:CGRectMake(MarginX, H(30), gameNameTextfieldViewW, gameNameTextfieldViewH)];
    gameNameTextfieldView.createGameModel = self.createGameModelArray[0][3];
    gameNameTextfieldView.delegate = self;
    [bgView addSubview:gameNameTextfieldView];
    self.gameNameTextfieldView = gameNameTextfieldView;
}

- (void)p_saveCheckBtnClick:(UIButton *)button {
    [self p_submitBtnClickWithTitle:button.currentTitle];
}

- (void)p_gameCheckBtnClick:(UIButton *)button {
    [self p_submitBtnClickWithTitle:button.currentTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.createGameModelArray[2] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        CreateGame1Cell *cell1 = [CreateGame1Cell cellWithTableView:tableView];
        cell1.createGameModel = self.createGameModelArray[2][indexPath.row];
        cell1.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
        cell1.textfieldInputView = TextfieldInputViewTextField;
        cell1.delegate = self;
        
        return cell1;
    } else {
        CreateGame2Cell *cell2 = [CreateGame2Cell cellWithTableView:tableView];
        cell2.createGameModel = self.createGameModelArray[2][indexPath.row];
        if ([self.createGameModelArray[2] count] - 1 == indexPath.row) {
            cell2.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } else {
            cell2.rectCornerStyle = UIRectCornerAllCorners;
        }
        cell2.indexPath = indexPath;
        cell2.delegate = self;
        
        return cell2;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createPeopleLimitSectionHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return H(38);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TSCreateGameModel *model = self.createGameModelArray[0][1];
    if ([model.selectValue isEqualToString:@"5V5"]) {
        return [self createAddMoreView];
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return H(57);
}

- (void)moreBtnClick {
    for (int i = 0; i < 5; i ++) {
        TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
        model.leftTitle = @"球员姓名：";
        model.name = @"";
        model.rightTitle = @"手机号：";
        model.phone = @"";
        [self.createGameModelArray[2] addObject:model];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.createGameModelArray[2] count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.createGameModelArray[2] count] - 2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self scrollTableToFoot:YES];
}

- (void)p_submitBtnClickWithTitle:(NSString *)title {
    // 检测所有信息是否已经录全
    int MinPlayers = 5;
    TSCreateGameModel *gameModel = self.createGameModelArray[0][1];
    if ([gameModel.selectValue isEqualToString:@"3V3"]) {
        MinPlayers = 3;
    }
    
    __block NSString *noInputString = @"";
    [self.createGameModelArray[2] enumerateObjectsUsingBlock:^(TSCreateGameModel *createGameModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) { // 检测客队名称
            if (0 == createGameModel.name.length) {
                noInputString = @"请填写客队名称";
                *stop = YES;
            }
        } else if (idx >= 1 && idx <= MinPlayers) {
            if (0 == createGameModel.name.length) {
                noInputString = @"请填写球员姓名";
                *stop = YES;
            } else if (0 == createGameModel.phone.length) {
                noInputString = @"请填写手机号";
                *stop = YES;
            } else if (11 != createGameModel.phone.length) {
                noInputString = @"手机号不正确";
                *stop = YES;
            }
        } else if (idx > MinPlayers) {
            if (createGameModel.name.length) {
                if (0 == createGameModel.phone.length) {
                    noInputString = @"请填写手机号";
                    *stop = YES;
                } else if (11 != createGameModel.phone.length) {
                    noInputString = @"手机号不正确";
                    *stop = YES;
                }
            } else if (createGameModel.phone.length) {
                if (0 == createGameModel.name.length) {
                    noInputString = @"请填写球员姓名";
                    *stop = YES;
                }
            }
        }
    }];
    
    if (noInputString.length) {
        [SVProgressHUD showInfoWithStatus:noInputString];
        return;
    }
    
    // 检测手机号码是否有重复
    NSMutableArray *phoneArray = [NSMutableArray array];
    [self.createGameModelArray[2] enumerateObjectsUsingBlock:^(TSCreateGameModel *createGameModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            if (createGameModel.name.length) {
                [phoneArray addObject:createGameModel.phone];
            }
        }
    }];
    NSSet *phoneSet = [NSSet setWithArray:phoneArray];
    if (phoneSet.count != phoneArray.count) {
        [SVProgressHUD showInfoWithStatus:@"手机号有重复"];
        return;
    }
    
    [self p_beginCreateGameWithTitle:title];
}

- (void)p_beginCreateGameWithTitle:(NSString *)title {
    [SVProgressHUD show];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *matchInfoDict = [NSMutableDictionary dictionary];
    NSMutableArray *homePlayerInfoList = [NSMutableArray array];
    NSMutableArray *awayPlayerInfoList = [NSMutableArray array];
    [self.createGameModelArray enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx1, BOOL * _Nonnull stop) {
        [subArray enumerateObjectsUsingBlock:^(TSCreateGameModel *createGameModel, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (0 == idx1 && 0 == idx2) { // 赛事时间
                matchInfoDict[@"matchDate"] = createGameModel.matchDate;
            }
            
            if (0 == idx1 && 1 == idx2) { // 赛制(5V5)
                if ([createGameModel.selectValue isEqualToString:@"5V5"]) {
                    matchInfoDict[@"ruleType"] = @1;
                } else {
                    matchInfoDict[@"ruleType"] = @2;
                }
            }
            
            if (0 == idx1 && 2 == idx2) { // 单节时间(4节X10分钟)
                if ([createGameModel.selectValue isEqualToString:@"4节X10分钟"]) {
                    matchInfoDict[@"sectionType"] = @1;
                } else if ([createGameModel.selectValue isEqualToString:@"4节X12分钟"]) {
                    matchInfoDict[@"sectionType"] = @2;
                } else if ([createGameModel.selectValue isEqualToString:@"1节X10分钟"]) {
                    matchInfoDict[@"sectionType"] = @3;
                } else if ([createGameModel.selectValue isEqualToString:@"2节X8分钟"]) {
                    matchInfoDict[@"sectionType"] = @4;
                }
            }
            
            if (0 == idx1 && 3 == idx2) { // 赛事名称
                if (createGameModel.customName.length) {
                    matchInfoDict[@"matchName"] = createGameModel.customName;
                } else {
                    matchInfoDict[@"matchName"] = createGameModel.name;
                }
            }
            
            if (1 == idx1 && 0 == idx2) { // 主队名称
                matchInfoDict[@"homeTeamName"] = createGameModel.name;
            }
            
            if (2 == idx1 && 0 == idx2) { // 客队名称
                matchInfoDict[@"awayTeamName"] = createGameModel.name;
            }
            
            if (1 == idx1 && idx2 > 0) { // 主队球员信息
                if (createGameModel.name.length && createGameModel.phone.length) {
                    NSMutableDictionary *homePlayerInfoDict = [NSMutableDictionary dictionary];
                    homePlayerInfoDict[@"name"] = createGameModel.name;
                    homePlayerInfoDict[@"phone"] = createGameModel.phone;
                    [homePlayerInfoList addObject:homePlayerInfoDict];
                }
            }
            
            if (2 == idx1 && idx2 > 0) { // 客队球员信息
                if (createGameModel.name.length && createGameModel.phone.length) {
                    NSMutableDictionary *awayPlayerInfoDict = [NSMutableDictionary dictionary];
                    awayPlayerInfoDict[@"name"] = createGameModel.name;
                    awayPlayerInfoDict[@"phone"] = createGameModel.phone;
                    [awayPlayerInfoList addObject:awayPlayerInfoDict];
                }
            }
        }];
    }];
    matchInfoDict[@"homePlayerInfoList"] = homePlayerInfoList;
    matchInfoDict[@"awayPlayerInfoList"] = awayPlayerInfoList;
    paramsDict[@"matchInfo"] = matchInfoDict;
    
    CreateGameViewModel *createGameViewModel = [[CreateGameViewModel alloc] initWithPramasDict:paramsDict];
    [createGameViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"createGame returnValue is:%@", returnValue)
        
        [SVProgressHUD dismiss];
        
        if ([title isEqualToString:@"保存"]) {
            if ([self p_isIncludeCalssWithClassName:@"GameSelectViewController"]) {
                [SVProgressHUD showInfoWithStatus:@"保存成功"];
            }
        } else {
            if ([returnValue[@"entity"] count]) {
                MyGameOverListModel *myGameOverListModel = [MyGameOverListModel mj_objectWithKeyValues:returnValue[@"entity"]];
                PreGameCheckNormalViewController *gameCheckVC = [[PreGameCheckNormalViewController alloc] init];
                gameCheckVC.gameOverListModel = myGameOverListModel;
                [self.navigationController pushViewController:gameCheckVC animated:YES];
            }
        }
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [SVProgressHUD dismiss];
    }];
    [createGameViewModel saveAmateurMatchInfo];
}

- (void)textFieldDidEndEditing:(NSNotification *)notif {
    if (self.view.y < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y += H(150);
        }];
    }
}

#pragma mark - CreateGame1CellDelegate
- (void)textfieldReturn { // 获取客队名称
    TSCreateGameModel *createGameModel = self.createGameModelArray[0][3];
    createGameModel.name = [NSString stringWithFormat:@"%@ VS %@", [self.createGameModelArray[1][0] name], [self.createGameModelArray[2][0] name]];
    
    self.gameNameTextfieldView.createGameModel = self.createGameModelArray[0][3];
}

#pragma mark - CreateGame2CellDelegate
- (void)textFieldBeginEditDelegate:(CreateGame2Cell *)cell {
    if (cell.indexPath.row > 4) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y -= H(150);
        }];
    }
}

#pragma mark - CreateGameTextfieldViewDelegate
- (void)gameNameTextfieldBeginEditing {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.y = -H(180);
    }];
}

- (void)gameNameTextfieldEndEdited {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.y = 0;
    }];
}

#pragma mark - Tools Method ******************************************************************
- (BOOL)p_isIncludeCalssWithClassName:(NSString *)className {
    Class class = NSClassFromString(className);
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:class]) {
            if ([className isEqualToString:@"GameSelectViewController"]) {
                GameSelectViewController *gameSelectVC = (GameSelectViewController *)controller;
                [self.navigationController popToViewController:gameSelectVC animated:YES];
            }
            
            return YES;
        }
    }
    return NO;
}

#pragma mark - tools method ******************************************************************
- (NSMutableArray *)getPlayerDataWithRuleType:(int)ruleType { // 根据赛制创建可录入球员的数量
    int players = 0;
    if (1 == ruleType) { // 5V5赛制
        players = 6;
    } else {
        players = 6;
    }
    
    NSMutableArray *section3ModelArray = [NSMutableArray array];
    for (int i = 0; i < players; i ++) {
        TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
        if (0 == i) {
            model.leftTitle = @"客队名称：";
            model.name = @"";
        } else {
            model.leftTitle = @"球员姓名：";
            if (1 == i) {
                model.leftTitle = @"队长姓名：";
            }
            model.name = @"";
            model.rightTitle = @"手机号：";
            model.phone = @"";
        }
        [section3ModelArray addObject:model];
    }
    
    return section3ModelArray;
}
@end
