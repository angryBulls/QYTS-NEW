//
//  TSCreateGameHTViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSCreateGameHTViewController.h"
#import "TSCreateGameGTViewController.h"
#import "TSCreateGameModel.h"
#import "CreateGame3Cell.h"

@interface TSCreateGameHTViewController () <CreateGame2CellDelegate, CreateGame3CellDelegate>
@property (nonatomic, strong) NSMutableArray *createGameModelArray;
@end

@implementation TSCreateGameHTViewController
#pragma mark - lazy method *******************************************************************************************
- (NSMutableArray *)createGameModelArray {
    if (!_createGameModelArray) {
        _createGameModelArray = [NSMutableArray array];
    }
    return _createGameModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewWithEdgeInsets:UIEdgeInsetsMake(H(4), 0, H(78), 0)];
    
    [self setupSubmitButtonWithTile:@"提交主队"];
    
    [self p_initCreateGameModelArray];
}

- (void)p_initCreateGameModelArray {
    NSMutableArray *section1ModelArray = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
        if (0 == i) {
            model.leftTitle = @"比赛时间：";
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
            model.matchDate = [fmt stringFromDate:[NSDate date]];
        } else if (1 == i) {
            model.leftTitle = @"选择赛制：";
            model.dpBtnArray = @[@"5V5", @"3V3"];
            model.selectValue = [model.dpBtnArray firstObject];
        } else if (2 == i) {
            model.leftTitle = @"选择时间：";
            model.dpBtnArray = @[@"4节X10分钟", @"4节X12分钟"];
            model.selectValue = [model.dpBtnArray firstObject];
        } else if (3 == i) {
            model.leftTitle = @"赛事名称：";
        }
        model.name = @"";
        [section1ModelArray addObject:model];
    }
    [self.createGameModelArray addObject:section1ModelArray];
    
    [self.createGameModelArray addObject:[self getPlayerDataWithRuleType:1]];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return [self.createGameModelArray[section] count] - 1;
    }
    return [self.createGameModelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            CreateGame1Cell *cell = [CreateGame1Cell cellWithTableView:tableView];
            cell.createGameModel = self.createGameModelArray[indexPath.section][indexPath.row];
            cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
            cell.textfieldInputView = TextfieldInputViewDatePicker;
            return cell;
        } else {
            CreateGame3Cell *cell3 = [CreateGame3Cell cellWithTableView:tableView];
            cell3.createGameModel = self.createGameModelArray[indexPath.section][indexPath.row];
            if (1 == indexPath.row) {
                cell3.rectCornerStyle = UIRectCornerAllCorners;
            } else if (2 == indexPath.row) {
                cell3.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }
            cell3.delegate = self;
            return cell3;
        }
    }
    
    if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            CreateGame1Cell *cell1 = [CreateGame1Cell cellWithTableView:tableView];
            cell1.createGameModel = self.createGameModelArray[indexPath.section][indexPath.row];
            cell1.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
            cell1.textfieldInputView = TextfieldInputViewTextField;
            
            return cell1;
        } else {
            CreateGame2Cell *cell2 = [CreateGame2Cell cellWithTableView:tableView];
            cell2.createGameModel = self.createGameModelArray[indexPath.section][indexPath.row];
            if ([self.createGameModelArray[1] count] - 1 == indexPath.row) {
                cell2.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            } else {
                cell2.rectCornerStyle = UIRectCornerAllCorners;
            }
            cell2.indexPath = indexPath;
            cell2.delegate = self;
            
            return cell2;
        }
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return [self createPeopleLimitSectionHeaderView];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return H(38);
    }
    
    return .1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (1 == section) {
        TSCreateGameModel *model = self.createGameModelArray[0][1];
        if ([model.selectValue isEqualToString:@"5V5"]) {
            return [self createAddMoreView];
        }
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (1 == section) {
        return H(57);
    }
    
    return .1f;
}

- (void)moreBtnClick {
    for (int i = 0; i < 5; i ++) {
        TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
        model.leftTitle = @"球员姓名：";
        model.name = @"";
        model.rightTitle = @"手机号：";
        model.phone = @"";
        [self.createGameModelArray[1] addObject:model];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.createGameModelArray[1] count] - 1 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.createGameModelArray[1] count] - 2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self scrollTableToFoot:YES];
}

- (void)submitBtnClick {
    [self.view endEditing:YES];
    
    int MinPlayers = 5;
    TSCreateGameModel *gameModel = self.createGameModelArray[0][1];
    if ([gameModel.selectValue isEqualToString:@"3V3"]) {
        MinPlayers = 3;
    }
    
    // 检测所有信息是否已经录全
    __block NSString *noInputString = @"";
    [self.createGameModelArray enumerateObjectsUsingBlock:^(NSMutableArray *sectionArray, NSUInteger idx1, BOOL * _Nonnull stop) {
        [sectionArray enumerateObjectsUsingBlock:^(TSCreateGameModel *createGameModel, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (0 == idx1 && 0 == idx2) { // 检测比赛时间
                if (0 == createGameModel.name.length) {
                    noInputString = @"请填写比赛时间";
                    *stop = YES;
                }
            }
            
            if (1 == idx1 && 0 == idx2) { // 检测主队名称
                if (0 == createGameModel.name.length) {
                    noInputString = @"请填写主队名称";
                    *stop = YES;
                }
            }
            
            if (1 == idx1 && idx2 >= 1 && idx2 <= MinPlayers) { // 检测主队球员名称
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
            } else if (1 == idx1 && idx2 >= 1 && idx2 > MinPlayers) {
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
            *stop = YES;
        }
    }];
    
    if (noInputString.length) {
        [SVProgressHUD showInfoWithStatus:noInputString];
        return;
    }
    
    // 检测手机号码是否有重复
    NSMutableArray *phoneArray = [NSMutableArray array];
    [self.createGameModelArray[1] enumerateObjectsUsingBlock:^(TSCreateGameModel *createGameModel, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    // 默认设置“主队名称”为“赛事名称”
    TSCreateGameModel *createGameModel = self.createGameModelArray[0][3];
    createGameModel.name = [self.createGameModelArray[1][0] name];
    
    TSCreateGameGTViewController *gameGTVC = [[TSCreateGameGTViewController alloc] init];
    gameGTVC.createGameModelArray = self.createGameModelArray;
    [self.navigationController pushViewController:gameGTVC animated:YES];
}

#pragma mark - CreateGame2CellDelegate
- (void)textFieldBeginEditDelegate:(CreateGame2Cell *)cell {
    if (cell.indexPath.row > 2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y -= H(220);
        }];
    }
}

#pragma mark - CreateGame3CellDelegate
- (void)dpBtnDidShow { // 收回键盘
    [self.view endEditing:YES];
}

- (void)getDpBtnSelectValue:(NSString *)selectValue {
    DDLog(@"selectValue is:%@", selectValue);
    // 刷新“选择时间”的数据
    TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
    model.leftTitle = @"选择时间：";
    if ([selectValue isEqualToString:@"3V3"]) {
        model.dpBtnArray = @[@"1节X10分钟", @"2节X8分钟"];
    } else {
        model.dpBtnArray = @[@"4节X10分钟", @"4节X12分钟"];
    }
    model.selectValue = [model.dpBtnArray firstObject];
    model.name = @"";
    self.createGameModelArray[0][2] = model;
    DDLog(@"model.dpBtnArray is:%@", model.dpBtnArray)
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    // 刷新可录入球员的数量
    if ([selectValue isEqualToString:@"3V3"]) {
        self.createGameModelArray[1] = [self getPlayerDataWithRuleType:2];
    } else {
        self.createGameModelArray[1] = [self getPlayerDataWithRuleType:1];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - tools method ******************************************************************
- (NSMutableArray *)getPlayerDataWithRuleType:(int)ruleType { // 根据赛制创建可录入球员的数量
    int players = 0;
    if (1 == ruleType) { // 5V5赛制
        players = 6;
    } else {
        players = 6;
    }
    
    NSMutableArray *section2ModelArray = [NSMutableArray array];
    for (int i = 0; i < players; i ++) {
        TSCreateGameModel *model = [[TSCreateGameModel alloc] init];
        if (0 == i) {
            model.leftTitle = @"主队名称：";
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
        [section2ModelArray addObject:model];
    }
    
    return section2ModelArray;
}
@end
