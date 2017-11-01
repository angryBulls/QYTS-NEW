//
//  PreGameCheckBCBCViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/17.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PreGameCheckBCBCViewController.h"
#import "CustomPickerView.h"
#import "TSCheckModel.h"
#import "GameCheckViewModel.h"
#import "TSTeamModel.h"

#define GameLevelArray @[@"总决赛", @"大区赛", @"地区赛"]
#define GameAreaArray @[@"东北赛区", @"东南赛区", @"西南赛区", @"西北赛区"]
#define GameProvinceArray @[@"北京市", @"天津市", @"辽宁省", @"吉林省", @"黑龙江省", @"河北省", @"山东省", @"上海市", @"江苏省", @"浙江省", @"安徽省", @"福建省", @"江西省", @"广东省", @"海南省", @"台湾省", @"香港特别行政区", @"澳门特别行政区", @"湖北省", @"湖南省", @"广西壮族自治区", @"贵州省", @"云南省", @"四川省", @"重庆市", @"西藏自治区", @"山西省", @"陕西省", @"甘肃省", @"新疆维吾尔自治区", @"青海省", @"宁夏回族自治区", @"内蒙古自治区", @"河南省"]

@interface PreGameCheckBCBCViewController ()
@property (nonatomic, weak) UIView *gameBgView;
@property (nonatomic, weak) UIView *teamBgView;
@property (nonatomic, weak) UIView *refBgView;

@property (nonatomic, strong) NSMutableArray *dropDownBtnArray;
@property (nonatomic, strong) NSMutableArray *textFieldViewArray;

@property (nonatomic, strong) TSCheckModel *checkModel;

@property (nonatomic, strong) NSArray *teamModelArray; // 球队数据
@end

@implementation PreGameCheckBCBCViewController
#pragma mark - lazy method ************************************************************************
- (NSMutableArray *)dropDownBtnArray {
    if (!_dropDownBtnArray) {
        _dropDownBtnArray = [NSMutableArray array];
    }
    return _dropDownBtnArray;
}

- (NSMutableArray *)textFieldViewArray {
    if (!_textFieldViewArray) {
        _textFieldViewArray = [NSMutableArray array];
    }
    return _textFieldViewArray;
}

- (TSCheckModel *)checkModel {
    if (!_checkModel) {
        _checkModel = [[TSCheckModel alloc] init];
    }
    return _checkModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_createGameSelectViews]; // 1
    
    [self p_createTeamSelectViews]; // 2
    
    [self p_createRefereeInputViews];
    
    [self createSubmitButtonWithTile:@"进入球员检录" buttonY:CGRectGetMaxY(self.refBgView.frame) + H(22)];
}

- (void)p_createGameSelectViews {
    CGFloat gameBgViewX = W(7.5);
    CGFloat gameBgViewY = 64 + H(1.5);
    CGFloat gameBgViewW = self.view.width - 2*gameBgViewX;
    CGFloat gameBgViewH = H(166);
    UIView *gameBgView = [self createBgViewWithFrame:CGRectMake(gameBgViewX, gameBgViewY, gameBgViewW, gameBgViewH)];
    [self.view addSubview:gameBgView];
    self.gameBgView = gameBgView;
    
    // add dropdown button
    NSArray *gameNameArray = @[@"选择赛事级别", @"选择赛区", @"选择省份"];
    
    CGFloat dropdownX = W(11.0);
    CGFloat dropdownW = self.gameBgView.width - 2*dropdownX;
    CGFloat dropdownH = H(38);
    CGFloat MarginY = (self.gameBgView.height - 3*dropdownH)/4;
    [gameNameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat dropdownY = (dropdownH + MarginY)*idx + MarginY;
        
        DropDownButton *dpBtn = [self createDropDownWithFrame:CGRectMake(dropdownX, dropdownY, dropdownW, dropdownH) titleName:name];
        [dpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.gameBgView addSubview:dpBtn];
        if (0 == idx) {
            [dpBtn addTarget:self action:@selector(p_gameLevelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else if (1 == idx) {
            [dpBtn addTarget:self action:@selector(p_gameAreaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            dpBtn.enabled = NO;
        } else if (2 == idx) {
            [dpBtn addTarget:self action:@selector(p_gameProvinceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            dpBtn.enabled = NO;
        }
        
        [self.dropDownBtnArray addObject:dpBtn];
    }];
}

- (void)p_gameLevelBtnClick:(DropDownButton *)dpBtn { // 选择赛事级别
    [self dpBtnClick:dpBtn];
    
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeName valueArray:GameLevelArray returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
        [self dpBtnClick:dpBtn];
        self.checkModel.gameLevel = returnValue;
        [self p_setupAreaAndProvinceStatus];
    }];
    if ([dpBtn.currentTitle containsString:@"选择"]) {
        pickView.defaultValue = GameLevelArray[0];
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    [pickView show];
}

- (void)p_setupAreaAndProvinceStatus { // 根据选择的赛事级别，更改“赛区”和“省份”的按钮状态
    if ([[self.dropDownBtnArray[0] currentTitle] isEqualToString:GameLevelArray[0]]) { // 选择总决赛
        [(DropDownButton*)self.dropDownBtnArray[1] setEnabled:NO];
        [(DropDownButton*)self.dropDownBtnArray[2] setEnabled:NO];
        
        [self p_getTeamFinalsData];
    } else if ([[self.dropDownBtnArray[0] currentTitle] isEqualToString:GameLevelArray[1]]) { // 选择大区赛
        [(DropDownButton*)self.dropDownBtnArray[1] setEnabled:YES];
        [(DropDownButton*)self.dropDownBtnArray[2] setEnabled:NO];
    } else if ([[self.dropDownBtnArray[0] currentTitle] isEqualToString:GameLevelArray[2]]) { // 选择地区赛
        [(DropDownButton*)self.dropDownBtnArray[1] setEnabled:NO];
        [(DropDownButton*)self.dropDownBtnArray[2] setEnabled:YES];
    }
}

- (void)p_gameAreaBtnClick:(DropDownButton *)dpBtn { // 选择赛区
    [self dpBtnClick:dpBtn];
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeName valueArray:GameAreaArray returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
        [self dpBtnClick:dpBtn];
        self.checkModel.gameArea = returnValue;
        [self p_getTeamAreaData];
    }];
    if ([dpBtn.currentTitle containsString:@"选择"]) {
        pickView.defaultValue = GameAreaArray[0];
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    [pickView show];
}

- (void)p_gameProvinceBtnClick:(DropDownButton *)dpBtn { // 选择省份
    [self dpBtnClick:dpBtn];
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeName valueArray:GameProvinceArray returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
        [self dpBtnClick:dpBtn];
        self.checkModel.gameProvince = returnValue;
        [self p_getTeamProvinceData];
    }];
    if ([dpBtn.currentTitle containsString:@"选择"]) {
        pickView.defaultValue = GameProvinceArray[0];
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    [pickView show];
}

#pragma mark - 获取总决赛球队列表
- (void)p_getTeamFinalsData {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    GameCheckViewModel *checkViewModel = [[GameCheckViewModel alloc] initWithPramasDict:paramsDict];
    [checkViewModel setBlockWithReturnBlock:^(id returnValue) {
//        DDLog(@"returnValue is:%@", returnValue);
        
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        
    }];
    [checkViewModel getTeamFinalsData];
}

#pragma mark - 获取大区赛球队列表
- (void)p_getTeamAreaData {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"zoneName"] = [self.dropDownBtnArray[1] currentTitle];
    
    GameCheckViewModel *checkViewModel = [[GameCheckViewModel alloc] initWithPramasDict:paramsDict];
    [checkViewModel setBlockWithReturnBlock:^(id returnValue) {
//        DDLog(@"returnValue is:%@", returnValue);
        if (returnValue[@"entity"][@"teamInfos"]) {
            self.teamModelArray = [TSTeamModel mj_objectArrayWithKeyValuesArray:returnValue[@"entity"][@"teamInfos"]];
        }
        
        [SVProgressHUD dismiss];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [SVProgressHUD dismiss];
    }];
    [checkViewModel getTeamAreaData];
}

#pragma mark - 根据省份获取省份的球队列表
- (void)p_getTeamProvinceData {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"province"] = [self.dropDownBtnArray[2] currentTitle];
    
    GameCheckViewModel *checkViewModel = [[GameCheckViewModel alloc] initWithPramasDict:paramsDict];
    [checkViewModel setBlockWithReturnBlock:^(id returnValue) {
//        DDLog(@"returnValue is:%@", returnValue);
        if (returnValue[@"entity"][@"teamInfos"]) {
            self.teamModelArray = [TSTeamModel mj_objectArrayWithKeyValuesArray:returnValue[@"entity"][@"teamInfos"]];
            [self.dropDownBtnArray enumerateObjectsUsingBlock:^(DropDownButton *dpBtn, NSUInteger idx, BOOL * _Nonnull stop) {
                if (3 == idx || 5 == idx) {
                    dpBtn.enabled = YES;
                }
            }];
        }
        
        [SVProgressHUD dismiss];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [SVProgressHUD dismiss];
    }];
    [checkViewModel getTeamProvinceData];
}

- (void)p_createTeamSelectViews {
    CGFloat teamBgViewX = W(7.5);
    CGFloat teamBgViewY = CGRectGetMaxY(self.gameBgView.frame) + H(10);
    CGFloat teamBgViewW = self.view.width - 2*teamBgViewX;
    CGFloat teamBgViewH = H(115);
    UIView *teamBgView = [self createBgViewWithFrame:CGRectMake(teamBgViewX, teamBgViewY, teamBgViewW, teamBgViewH)];
    [self.view addSubview:teamBgView];
    self.teamBgView = teamBgView;
    
    // add dropdown button
    NSArray *gameNameArray = @[@"请选择主队", @"请选择队服颜色", @"请选择客队", @"请选择队服颜色"];
    
    NSInteger maxColumn = 2;
    CGFloat MarginX = W(11.0);
    CGFloat dropdownW = (self.teamBgView.width - 3*MarginX)/2;
    CGFloat dropdownH = H(38);
    CGFloat MarginY = (self.teamBgView.height - 2*dropdownH)/3;
    [gameNameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat dropdownX = idx%maxColumn*(dropdownW + MarginX) + MarginX;
        CGFloat dropdownY = idx/maxColumn*(dropdownH + MarginY) + MarginY;
        
        DropDownButton *dpBtn = [self createDropDownWithFrame:CGRectMake(dropdownX, dropdownY, dropdownW, dropdownH) titleName:name];
        dpBtn.tag = idx;
        dpBtn.rightWidth = W(16.5);
        [self.teamBgView addSubview:dpBtn];
        
        if (0 == idx | 2 == idx) {
            [dpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            dpBtn.enabled = NO;
            [dpBtn addTarget:self action:@selector(p_teamSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else if (1 == idx | 3 == idx) {
            [dpBtn addTarget:self action:@selector(p_teamColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.dropDownBtnArray addObject:dpBtn];
    }];
}

- (void)p_teamSelectBtnClick:(DropDownButton *)dpBtn { // 选择球队
    if (0 == self.teamModelArray.count) return;
    [self dpBtnClick:dpBtn];
    
    NSMutableArray *teamNameArray = [NSMutableArray array];
    [self.teamModelArray enumerateObjectsUsingBlock:^(TSTeamModel *teamModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [teamNameArray addObject:teamModel.name];
    }];
    
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeName valueArray:teamNameArray returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
        [self dpBtnClick:dpBtn];
        [self.dropDownBtnArray enumerateObjectsUsingBlock:^(DropDownButton *subDpBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subDpBtn == dpBtn) {
                if (3 == idx) { // 保存主队名字
                    self.checkModel.homeTeamName = returnValue;
                    DDLog(@"homeTeamName is:%@", self.checkModel.homeTeamName);
                } else if (5 == idx) { // 保存客队名字
                    self.checkModel.awayTeamName = returnValue;
                    DDLog(@"awayTeamName is:%@", self.checkModel.awayTeamName);
                }
            }
        }];
    }];
    if ([dpBtn.currentTitle containsString:@"选择"]) {
        pickView.defaultValue = teamNameArray[0];
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    [pickView show];
}

- (void)p_teamColorBtnClick:(DropDownButton *)dpBtn { // 选择颜色
    [self dpBtnClick:dpBtn];
    
    if (dpBtn.tag == 1) {
        [self chooseColorWithBtn:dpBtn Array:ColorArrayH];
    }
    else if(dpBtn.tag == 3){
        [self chooseColorWithBtn:dpBtn Array:ColorArrayG];
    }
   
}
//选择颜色
-(void)chooseColorWithBtn:(DropDownButton*)dpBtn Array:(NSArray *)array{
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeColor valueArray:array returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue[0] forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [dpBtn setTitle:returnValue[0] forState:UIControlStateNormal];
        [self dpBtnClick:dpBtn];
        [self.dropDownBtnArray enumerateObjectsUsingBlock:^(DropDownButton *subDpBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (subDpBtn == dpBtn) {
                if (4 == idx) { // 保存主队颜色
                    self.checkModel.teamColorH = [self p_getCurrentColorValueWithColorName:returnValue[0] AndArray:ColorArrayH];
                    DDLog(@"teamColorH is:%@", self.checkModel.teamColorH);
                } else if (6 == idx) { // 保存客队颜色
                    self.checkModel.teamColorG = [self p_getCurrentColorValueWithColorName:returnValue[0] AndArray:ColorArrayG];
                    DDLog(@"teamColorG is:%@", self.checkModel.teamColorG);
                }
            }
        }];
    }];
    if ([dpBtn.currentTitle containsString:@"选择"]) {
        if (dpBtn.tag == 1) {
            pickView.defaultValue = ColorArrayH[0][0];
        }
        else if(dpBtn.tag == 3){
            pickView.defaultValue = ColorArrayG[0][0];
        }
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    [pickView show];
    
}

- (void)p_createRefereeInputViews {
    CGFloat refBgViewX = W(7.5);
    CGFloat refBgViewY = CGRectGetMaxY(self.teamBgView.frame) + H(10);
    CGFloat refBgViewW = self.view.width - 2*refBgViewX;
    CGFloat refBgViewH = H(217);
    UIView *refBgView = [self createBgViewWithFrame:CGRectMake(refBgViewX, refBgViewY, refBgViewW, refBgViewH)];
    [self.view addSubview:refBgView];
    self.refBgView = refBgView;
    
    // add ref title label and textfield
    NSArray *refNameArray = @[@"*主裁判：", @"请输入姓名", @"第一副裁判：", @"请输入姓名", @"第二副裁判：", @"请输入姓名", @"技术代表：", @"请输入姓名"];
    
    NSInteger maxColumn = 2;
    CGFloat refLabX = 0;
    CGFloat refLabW = W(100);
    CGFloat refLabH = H(38);
    CGFloat MarginY = (self.refBgView.height - 4*refLabH)/5;
    
    CGFloat textfieldX = refLabW;
    CGFloat textfieldW = self.refBgView.width - refLabW -  W(11.0);
    CGFloat textfieldH = refLabH;
    [refNameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat refLabY = idx/maxColumn*(refLabH + MarginY) + MarginY;
        if (0 == idx % 2) {
            UILabel *titleLab = [self createTitleLabelWithFrame:CGRectMake(refLabX, refLabY, refLabW, refLabH) titleName:name];
            [self.refBgView addSubview:titleLab];
        } else {
            CGRect textFieldViewFrame = CGRectMake(textfieldX, refLabY, textfieldW, textfieldH);
            TSTextFieldView *textFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:name textfieldType:TSTextFieldTypeName];
            [self setupTextfieldStyle:textFieldView];
            [self.refBgView addSubview:textFieldView];
            [self.textFieldViewArray addObject:textFieldView];
        }
    }];
}

- (void)textFieldBeginEditing:(NSNotification *)obj {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.y -= 200;
    }];
}

- (void)textFieldDidEndEditing:(NSNotification *)obj {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.y += 200;
    }];
}

- (void)submitBtnClick {
    if (!self.checkModel.gameLevel) {
        [SVProgressHUD showInfoWithStatus:@"请选择赛事级别"];
        return;
    }
    
    if ([self.checkModel.gameLevel isEqualToString:GameLevelArray[1]] && !self.checkModel.gameArea) {
        [SVProgressHUD showInfoWithStatus:@"请选择赛区"];
        return;
    }
    
    if ([self.checkModel.gameLevel isEqualToString:GameLevelArray[2]] && !self.checkModel.gameProvince) {
        [SVProgressHUD showInfoWithStatus:@"请选择省份"];
        return;
    }
    
    if (!self.checkModel.homeTeamName) {
        [SVProgressHUD showInfoWithStatus:@"请选择主队名称"];
        return;
    }
    
    if (!self.checkModel.awayTeamName) {
        [SVProgressHUD showInfoWithStatus:@"请选择客队名称"];
        return;
    }
    
    if (!self.checkModel.teamColorH) {
        [SVProgressHUD showInfoWithStatus:@"请选择主队颜色"];
        return;
    }
    
    if (!self.checkModel.teamColorG) {
        [SVProgressHUD showInfoWithStatus:@"请选择客队颜色"];
        return;
    }
    
    // 检测球队队名是否重名
    if ([self.checkModel.homeTeamName isEqualToString:self.checkModel.awayTeamName]) {
        [SVProgressHUD showInfoWithStatus:@"主客队不能重名"];
        return;
    }
    
    // 检测球队颜色是否重色
    if ([self.checkModel.teamColorH isEqualToString:self.checkModel.teamColorG]) {
        [SVProgressHUD showInfoWithStatus:@"主客队不能重色"];
        return;
    }
    
    [self.textFieldViewArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) { // 主裁判
            self.checkModel.mainReferee = textFieldView.textField.text;
        } else if (1 == idx) { // 第一副裁
            self.checkModel.firstReferee = textFieldView.textField.text;
        } else if (2 == idx) { // 第二副裁
            self.checkModel.secondReferee = textFieldView.textField.text;
        } else if (3 == idx) { // 技术代表
            self.checkModel.td = textFieldView.textField.text;
        }
    }];
    
    if (0 == self.checkModel.mainReferee.length) {
        [SVProgressHUD showInfoWithStatus:@"请填写主裁判"];
        return;
    }
    
    [self p_getBCBCMatchId];
}

- (void)p_getBCBCMatchId { // 获取matchId成功才能继续
    [SVProgressHUD show];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    GameCheckViewModel *checkViewModel = [[GameCheckViewModel alloc] initWithPramasDict:paramsDict];
    [checkViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"getBCBCMatchId returnValue is:%@", returnValue);
        
        if (returnValue[@"entity"][@"matchId"]) {
            self.checkModel.matchId = returnValue[@"entity"][@"matchId"];
            
            [self p_saveGameCheckDataToDB];
            
            TSPlayersCheckViewController *playersCheckVC = [[TSPlayersCheckViewController alloc] init];
            playersCheckVC.checkModel = self.checkModel;
            playersCheckVC.checkModel.ruleType = @"1";
            [self.navigationController pushViewController:playersCheckVC animated:YES];
            
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showInfoWithStatus:@"获取比赛id失败，请重试"];
        }
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        
    }];
    
    [checkViewModel getBCBCMatchId];
}

- (void)p_saveGameCheckDataToDB {
    // 根据球队名称保存球队id到checkModel
    [self.teamModelArray enumerateObjectsUsingBlock:^(TSTeamModel *teamModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.checkModel.homeTeamName isEqualToString:teamModel.name]) {
            self.checkModel.homeTeamId = teamModel.ID;
        }
        
        if ([self.checkModel.awayTeamName isEqualToString:teamModel.name]) {
            self.checkModel.awayTeamId = teamModel.ID;
        }
    }];
}

- (NSString *)p_getCurrentColorValueWithColorName:(NSString *)colorName AndArray:(NSArray *)colorArr{
    __block NSString *colorValue = @"";
    [colorArr enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subArray[0] isEqualToString:colorName]) {
            colorValue = subArray[1];
            *stop = YES;
        }
    }];
    return colorValue;
}
@end
