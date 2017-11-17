//
//  PreGameCheckCBOViewController.m
//  QYTS
//
//  Created by 媛 祁 on 2017/10/7.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PreGameCheckCBOViewController.h"
#import "MyGameOverListModel.h"
#import "CustomPickerView.h"
#import "TSCheckModel.h"

@interface PreGameCheckCBOViewController ()
@property (nonatomic, weak) UIView *teamBgView;
@property (nonatomic, weak) UIView *refBgView;

@property (nonatomic, strong) NSMutableArray *dropDownBtnArray;
@property (nonatomic, strong) NSMutableArray *textFieldViewArray;

@property (nonatomic, strong) TSCheckModel *checkModel;
@end

@implementation PreGameCheckCBOViewController
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

- (void)setGameOverListModel:(MyGameOverListModel *)gameOverListModel {
    _gameOverListModel = gameOverListModel;
    NSDictionary *tempDict = gameOverListModel.mj_keyValues;
    DDLog(@"tempDict info is:%@", tempDict);
    self.checkModel = [TSCheckModel mj_objectWithKeyValues:tempDict];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_createTeamSelectViews];
    
    [self p_createRefereeInputViews];
    
    [self createSubmitButtonWithTile:@"进入球员检录" buttonY:CGRectGetMaxY(self.refBgView.frame) + H(22)];
}

- (void)p_createTeamSelectViews {
    CGFloat teamBgViewX = W(7.5);
    CGFloat teamBgViewY = 64 + H(1.5);
    CGFloat teamBgViewW = self.view.width - 2*teamBgViewX;
    CGFloat teamBgViewH = H(115);
    UIView *teamBgView = [self createBgViewWithFrame:CGRectMake(teamBgViewX, teamBgViewY, teamBgViewW, teamBgViewH)];
    [self.view addSubview:teamBgView];
    self.teamBgView = teamBgView;
    
    // add team name labels
    NSInteger maxColumn = 2;
    CGFloat MarginX = W(11.0);
    CGFloat subViewW = (self.teamBgView.width - 3*MarginX)/2;
    CGFloat subViewH = H(38);
    CGFloat MarginY = (self.teamBgView.height - 2*subViewH)/3;
    for (int i = 0; i < 4; i ++) {
        CGFloat subViewX = i%maxColumn*(subViewW + MarginX) + MarginX;
        CGFloat subViewY = i/maxColumn*(subViewH + MarginY) + MarginY;
        
        CGRect frame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
        
        if (0 == i) { // show team name labels
            UILabel *homeLabel = [self createTitleLabelWithFrame:frame titleName:self.checkModel.homeTeamName];
            [self.teamBgView addSubview:homeLabel];
        } else if (2 == i) {
            UILabel *awayLabel = [self createTitleLabelWithFrame:frame titleName:self.checkModel.awayTeamName];
            [self.teamBgView addSubview:awayLabel];
        } else if (1 == i || 3 == i) {
            DropDownButton *dpBtn = [self createDropDownWithFrame:frame titleName:@"请选择队服颜色"];
            dpBtn.tag = i;
            dpBtn.rightWidth = W(16.5);
            [dpBtn addTarget:self action:@selector(p_teamColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.teamBgView addSubview:dpBtn];
            
            [self.dropDownBtnArray addObject:dpBtn];
        }
    }
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
                
                if (1 == subDpBtn.tag) { // 保存主队颜色
                    self.checkModel.teamColorH = [self p_getCurrentColorValueWithColorName:returnValue[0] AndArray:ColorArrayH];
                    DDLog(@"teamColorH is:%@", self.checkModel.teamColorH);
                } else if (3 == subDpBtn.tag) { // 保存客队颜色
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
            titleLab.textAlignment = NSTextAlignmentRight;
            titleLab.layer.borderWidth = 0.0;
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

- (void)submitBtnClick {
    if (!self.checkModel.teamColorH) {
        [SVProgressHUD showInfoWithStatus:@"请选择主队颜色"];
        return;
    }
    
    if (!self.checkModel.teamColorG) {
        [SVProgressHUD showInfoWithStatus:@"请选择客队颜色"];
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
    
    TSPlayersCheckViewController *playersCheckVC = [[TSPlayersCheckViewController alloc] init];
    playersCheckVC.checkModel = self.checkModel;
    playersCheckVC.checkModel.ruleType = @"1";
    [self.navigationController pushViewController:playersCheckVC animated:YES];
}

#pragma mark - tools method
- (UILabel *)createTitleLabelWithFrame:(CGRect)frame titleName:(NSString *)titleName {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:frame];
    titleLab.text = titleName;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xbfd4ff);
    titleLab.layer.borderWidth = 1.0;
    titleLab.layer.borderColor = [UIColor whiteColor].CGColor;
    titleLab.layer.masksToBounds = YES;
    titleLab.layer.cornerRadius = W(5);
    
    return titleLab;
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
