//
//  PreGameCheckNormalViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PreGameCheckNormalViewController.h"
#import "GameCheckViewModel.h"
#import "CustomPickerView.h"
#import "TSCheckModel.h"
#import "MyGameOverListModel.h"

@interface PreGameCheckNormalViewController ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *gameNameBgView;
@property (nonatomic, weak) UIView *teamBgView;
@property (nonatomic, weak) UIView *refBgView;
@property (nonatomic, weak) DropDownButton *hostBtn;
@property (nonatomic, weak) DropDownButton *guestBtn;

@property (nonatomic, strong) NSArray *matchTeamModelArray;
@property (nonatomic, strong) TSCheckModel *selectNormalModel;
@property (nonatomic, strong) NSMutableArray *textFieldViewArray;
@end

@implementation PreGameCheckNormalViewController
- (NSMutableArray *)textFieldViewArray {
    if (!_textFieldViewArray) {
        _textFieldViewArray = [NSMutableArray array];
    }
    return _textFieldViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_createTipsLabel];
    [self p_initCheckModel];
    [self p_createRefViews];
    [self createSubmitButtonWithTile:@"进入球员检录" buttonY:CGRectGetMaxY(self.bgView.frame) + H(33)];
}

- (void)p_createTipsLabel {
    CGFloat titleLabX = W(20);
    CGFloat titleLabY = 65;
    CGFloat titleLabW = self.view.width - titleLabX;
    CGFloat titleLabH = H(36);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
    titleLab.font = [UIFont systemFontOfSize:W(13.0)];
    titleLab.textColor = TSHEXCOLOR(0x425C8E);
    titleLab.text = @"选填，如果没有可直接进入检录";
    if (1 == self.gameOverListModel.ruleType.intValue) {
        titleLab.text = @"带*号的为必填项";
    }
    [self.view addSubview:titleLab];
}

- (void)p_initCheckModel {
    NSMutableDictionary *myGameOverDict = self.gameOverListModel.mj_keyValues;
    DDLog(@"myGameOverDict is:%@", myGameOverDict);
    self.selectNormalModel = [TSCheckModel mj_objectWithKeyValues:myGameOverDict];
    
}

#pragma mark - 查找登录人创建的赛事信息
- (void)p_getMatchAndTeamInfoNormal {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    GameCheckViewModel *checkViewModel = [[GameCheckViewModel alloc] initWithPramasDict:paramsDict];
    [checkViewModel setBlockWithReturnBlock:^(id returnValue) {
//        DDLog(@"returnValue is:%@", returnValue);
        if ([returnValue[@"entity"] count]) {
            self.matchTeamModelArray = [TSCheckModel mj_objectArrayWithKeyValuesArray:returnValue[@"entity"][@"matchList"]];
            
            [self p_createGameNameViews];
            
            [self p_createTeamSelectViews];
            
            [self p_createRefViews];
            
            [self createSubmitButtonWithTile:@"进入球员检录" buttonY:CGRectGetMaxY(self.refBgView.frame) + H(33)];
        } else {
            [SVProgressHUD showInfoWithStatus:@"您还未创建过比赛"];
        }
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [checkViewModel getMatchAndTeamInfoNormal];
}

- (void)p_createGameNameViews {
    // add game name bg view
    CGFloat bgViewX = W(7.5);
    CGFloat bgViewY = 64 + H(37);
    CGFloat bgViewW = self.view.width - 2*bgViewX;
    CGFloat bgViewH = H(160);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    [self.view addSubview:bgView];
    
    CGFloat dropDownBtnX = W(11);
    CGFloat dropDownBtnW = bgView.width - 2*dropDownBtnX;
    CGFloat dropDownBtnH = H(38);
    CGFloat dropDownBtnY = (bgView.height - dropDownBtnH)*0.5;
    DropDownButton *dpBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    dpBtn.frame = CGRectMake(dropDownBtnX, dropDownBtnY, dropDownBtnW, dropDownBtnH);
    [dpBtn setTitle:@"选择赛事名称" forState:UIControlStateNormal];
    [dpBtn setImage:[UIImage imageNamed:@"dropDown_Icon"] forState:UIControlStateNormal];
    [dpBtn addTarget:self action:@selector(p_matchNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameNameBgView addSubview:dpBtn];
}

- (void)p_matchNameBtnClick:(DropDownButton *)dpBtn { // 选择赛事名称
    [self dpBtnClick:dpBtn];
    
    NSMutableArray *dpBtnNameArray = [NSMutableArray array];
    [self.matchTeamModelArray enumerateObjectsUsingBlock:^(TSCheckModel *checkModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [dpBtnNameArray addObject:checkModel.matchName];
    }];
    
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeName valueArray:dpBtnNameArray returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [self dpBtnClick:dpBtn];
        
        [self.matchTeamModelArray enumerateObjectsUsingBlock:^(TSCheckModel *checkModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([returnValue isEqualToString:checkModel.matchName]) {
                [self p_updateTeamNamesWithModel:checkModel];
                *stop = YES;
            }
        }];
    }];
    if ([dpBtn.currentTitle containsString:@"选择"]) {
        pickView.defaultValue = dpBtnNameArray[0];
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    [pickView show];
}

// 根据选择的比赛名称，更新主客队名称
- (void)p_updateTeamNamesWithModel:(TSCheckModel *)checkModel {
    self.selectNormalModel = checkModel;
    
    [self.hostBtn setTitle:checkModel.homeTeamName forState:UIControlStateNormal];
    [self.guestBtn setTitle:checkModel.awayTeamName forState:UIControlStateNormal];
}

- (void)p_createTeamSelectViews {
    CGFloat teamBgViewX = W(7.5);
    CGFloat teamBgViewY = CGRectGetMaxY(self.gameNameBgView.frame) + H(9);
    CGFloat teamBgViewW = self.view.width - 2*teamBgViewX;
    CGFloat teamBgViewH = H(118);
    UIView *teamBgView = [[UIView alloc] initWithFrame:CGRectMake(teamBgViewX, teamBgViewY, teamBgViewW, teamBgViewH)];
    teamBgView.backgroundColor = self.gameNameBgView.backgroundColor;
    teamBgView.layer.masksToBounds = YES;
    teamBgView.layer.cornerRadius = W(5);
    [self.view addSubview:teamBgView];
    self.teamBgView = teamBgView;
    
    // add host team button
    CGFloat hostBtnX = W(11);
    CGFloat hostBtnY = H(13);
    CGFloat hostBtnW = teamBgView.width - 2*hostBtnX;
    CGFloat hostBtnH = H(38);
    DropDownButton *hostBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    hostBtn.frame = CGRectMake(hostBtnX, hostBtnY, hostBtnW, hostBtnH);
    [hostBtn setTitle:@"主队名称" forState:UIControlStateNormal];
    [self.teamBgView addSubview:hostBtn];
    self.hostBtn = hostBtn;
    
    // add guest team button
    CGFloat guestBtnX = W(11);
    CGFloat guestBtnH = H(38);
    CGFloat guestBtnY = self.teamBgView.height - H(13) - guestBtnH;
    CGFloat guestBtnW = teamBgView.width - 2*guestBtnX;
    
    DropDownButton *guestBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    guestBtn.frame = CGRectMake(guestBtnX, guestBtnY, guestBtnW, guestBtnH);
    [guestBtn setTitle:@"客队名称" forState:UIControlStateNormal];
    [self.teamBgView addSubview:guestBtn];
    self.guestBtn = guestBtn;
}

- (void)p_createRefViews {
    // add bg view
    CGFloat bgViewX = W(7.5);
    CGFloat bgViewY = 64 + H(37);
    CGFloat bgViewW = self.view.width - 2*bgViewX;
    CGFloat bgViewH = H(160);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    // add left title views
    // add ref title label and textfield
    NSInteger maxColumn = 2;
    CGFloat refLabX = 0;
    CGFloat refLabW = W(100);
    CGFloat refLabH = H(38);
    CGFloat MarginY = (self.bgView.height - 3*refLabH)/4;
    
    NSArray *refNameArray;
    if (1 == self.gameOverListModel.ruleType.intValue) { // 5V5
        refNameArray = @[@"*主裁判：", @"请输入姓名", @"第一副裁：", @"请输入姓名", @"第二副裁：", @"请输入姓名", @"技术代表：", @"请输入姓名", @"*技术统计：", @"请输入姓名"];
        self.bgView.height = H(260);
        MarginY = (self.bgView.height - 5*refLabH)/6;
    } else if (2 == self.gameOverListModel.ruleType.intValue) { // 3X3
        refNameArray = @[@"主裁判：", @"请输入姓名", @"技术代表：", @"请输入姓名", @"记录员：", @"请输入姓名"];
    }
    
    CGFloat textfieldX = refLabW;
    CGFloat textfieldW = self.bgView.width - refLabW -  W(11.0);
    CGFloat textfieldH = refLabH;
    [refNameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat refLabY = idx/maxColumn*(refLabH + MarginY) + MarginY;
        if (0 == idx % 2) {
            UILabel *titleLab = [self createTitleLabelWithFrame:CGRectMake(refLabX, refLabY, refLabW, refLabH) titleName:name];
            [self.bgView addSubview:titleLab];
        } else {
            CGRect textFieldViewFrame = CGRectMake(textfieldX, refLabY, textfieldW, textfieldH);
            TSTextFieldView *textFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:name textfieldType:TSTextFieldTypeName];
            [self setupTextfieldStyle:textFieldView];
            [self.bgView addSubview:textFieldView];
            [self.textFieldViewArray addObject:textFieldView];
        }
    }];
}

//- (void)textFieldBeginEditing:(NSNotification *)obj {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.y -= 100;
//    }];
//}
//
//- (void)textFieldDidEndEditing:(NSNotification *)obj {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.y += 100;
//    }];
//}

- (void)submitBtnClick {
    [self.view endEditing:YES];
    
    if (!self.selectNormalModel) {
        [SVProgressHUD showInfoWithStatus:@"请选择赛事名称"];
        return;
    }
    
    if (1 == self.gameOverListModel.ruleType.intValue) {
        __block NSString *stopString = @"";
        [self.textFieldViewArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (0 == idx) {
                if (0 == textFieldView.textField.text.length) {
                    stopString = @"请填写主裁判";
                    *stop = YES;
                }
            }
            
            if (4 == idx) {
                if (0 == textFieldView.textField.text.length) {
                    stopString = @"请填写技术统计";
                    *stop = YES;
                }
            }
        }];
        
        if (stopString.length) {
            [SVProgressHUD showInfoWithStatus:stopString];
            return;
        }
    }
    
    if (1 == self.gameOverListModel.ruleType.intValue) {
        [self.textFieldViewArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (0 == idx) { // 主裁判
                self.selectNormalModel.mainReferee = textFieldView.textField.text;
            } else if (1 == idx) { // 第一副裁
                self.selectNormalModel.firstReferee = textFieldView.textField.text;
            } else if (2 == idx) { // 第二副裁
                self.selectNormalModel.secondReferee = textFieldView.textField.text;
            } else if (3 == idx) { // 技术代表
                self.selectNormalModel.td = textFieldView.textField.text;
            } else if (4 == idx) { // 技术统计
                self.selectNormalModel.recorder = textFieldView.textField.text;
            }
        }];
    } else if (2 == self.gameOverListModel.ruleType.intValue) {
        [self.textFieldViewArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (0 == idx) { // 主裁判
                self.selectNormalModel.mainReferee = textFieldView.textField.text;
            } else if (1 == idx) { // 技术代表
                self.selectNormalModel.td = textFieldView.textField.text;
            } else if (2 == idx) { // 记录员
                self.selectNormalModel.recorder = textFieldView.textField.text;
            }
        }];
    }
    
    TSPlayersCheckViewController *playersCheckVC = [[TSPlayersCheckViewController alloc] init];
    playersCheckVC.checkModel = self.selectNormalModel;
    DDLog(@"selectNormalModel.matchId is:%@", self.selectNormalModel.matchId);
    [self.navigationController pushViewController:playersCheckVC animated:YES];
}
@end
