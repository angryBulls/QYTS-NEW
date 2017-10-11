//
//  AccountSetChangePDViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AccountSetChangePDViewController.h"
#import "TSTextFieldView.h"
#import "PersonalViewModel.h"
#import "AccountSetForgetPDViewController.h"

@interface AccountSetChangePDViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *textfieldArray;
@end

@implementation AccountSetChangePDViewController
- (NSMutableArray *)textfieldArray {
    if (!_textfieldArray) {
        _textfieldArray = @[].mutableCopy;
    }
    return _textfieldArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"修改密码" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_addSubViews];
    
    [self p_createSaveButton];
}

- (void)p_addSubViews {
    CGFloat marginX = W(8);
    CGFloat bgViewW = self.view.width - 2*marginX;
    CGFloat bgViewH = H(180);
    CGFloat bgViewY = 70;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(marginX, bgViewY, bgViewW, bgViewH)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    [self p_createLeftTitleViews];
    
    [self p_createrightTextfieldViews];
}

- (void)p_createLeftTitleViews {
    NSArray *titleArray = @[@"原密码：", @"新密码：", @"确认新密码："];
    
    CGFloat leftViewX = 0;
    CGFloat leftViewY = 10;
    CGFloat leftViewW = W(100);
    CGFloat leftViewH = self.bgView.height - 2*leftViewY;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(leftViewX, leftViewY, leftViewW, leftViewH)];
    [self.bgView addSubview:leftView];
    
    CGFloat leftLabX = 0;
    CGFloat leftLabW = leftViewW;
    CGFloat leftLabH = leftViewH/titleArray.count;
    [titleArray enumerateObjectsUsingBlock:^(NSString *titleName, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat leftLabY = idx*leftLabH;
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, leftLabY, leftLabW, leftLabH)];
        leftLab.text = titleName;
        leftLab.textAlignment = NSTextAlignmentRight;
        leftLab.font = [UIFont systemFontOfSize:W(15.0)];
        leftLab.textColor = TSHEXCOLOR(0xffffff);
        [leftView addSubview:leftLab];
    }];
}

- (void)p_createrightTextfieldViews {
    NSArray *placeholderArray = @[@"请输入原密码", @"请输入新密码", @"请确认新密码"];
    
    CGFloat rightViewX = W(92);
    CGFloat rightViewY = 10;
    CGFloat rightViewW = self.bgView.width - rightViewX;
    CGFloat rightViewH = self.bgView.height - 2*rightViewY;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rightViewX, rightViewY, rightViewW, rightViewH)];
    [self.bgView addSubview:rightView];
    
    CGFloat rightTextfieldX = 0;
    __block CGFloat rightTextfieldW = rightViewW*0.95;
    CGFloat rightTextfieldH = rightViewH/placeholderArray.count;
    [placeholderArray enumerateObjectsUsingBlock:^(NSString *placeholderName, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat rightTextfieldY = idx*rightTextfieldH;
        
        TSTextFieldType TSTextFieldType = TSTextFieldTypePassword;
        
        if (0 == idx) {
            rightTextfieldW = rightView.width*0.6;
        } else {
            rightTextfieldW = rightViewW*0.95;
        }
        CGRect textFieldViewFrame = CGRectMake(rightTextfieldX, rightTextfieldY, rightTextfieldW, rightTextfieldH);
        TSTextFieldView *textFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:placeholderName textfieldType:TSTextFieldType];
        [self p_cutomTextfieldStyle:textFieldView];
        [rightView addSubview:textFieldView];
        [self.textfieldArray addObject:textFieldView];
        
        // add send auth code button
        if (0 == idx) {
            [self p_addForgetButtonWithTextfield:textFieldView rightView:rightView];
        }
    }];
}

- (void)p_cutomTextfieldStyle:(TSTextFieldView *)textFieldView {
    textFieldView.backgroundColor = TSHEXCOLOR(0x27395d);
    textFieldView.layer.borderWidth = 0;
    textFieldView.textField.x = 0;
    textFieldView.textField.textColor = TSHEXCOLOR(0xffffff);
    
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(0, textFieldView.height - 8, textFieldView.width, 1);
    bottomLine.backgroundColor = [UIColor whiteColor].CGColor;
    [textFieldView.layer addSublayer:bottomLine];
}

- (void)p_addForgetButtonWithTextfield:(TSTextFieldView *)textFieldView rightView:(UIView *)rightView {
    CGFloat sendCodeBtnW = rightView.width*0.95 - textFieldView.width - 9;
    CGFloat sendCodeBtnH = H(30);
    CGFloat sendCodeBtnX = textFieldView.width + 9;
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(sendCodeBtnX, CGRectGetMaxY(textFieldView.frame) - sendCodeBtnH - 8, sendCodeBtnW, sendCodeBtnH);
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
    [forgetBtn setTitleColor:TSHEXCOLOR(0xbfd4ff) forState:UIControlStateNormal];
    forgetBtn.layer.masksToBounds = YES;
    forgetBtn.layer.cornerRadius = W(5);
    forgetBtn.layer.borderWidth = 1.0;
    forgetBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    forgetBtn.backgroundColor = TSHEXCOLOR(0x27395d);
    [forgetBtn addTarget:self action:@selector(p_forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:forgetBtn];
}

- (void)p_forgetBtnClick:(UIButton *)sendCodeBtn {
    AccountSetForgetPDViewController *forgetPDVC = [[AccountSetForgetPDViewController alloc] init];
    [self.navigationController pushViewController:forgetPDVC animated:YES];
}

- (void)p_createSaveButton {
    CGFloat saveBtnX = W(24.5);
    CGFloat saveBtnW = self.view.width - 2*saveBtnX;
    CGFloat saveBtnH = H(43);
    CGFloat saveBtnY = H(300);
    UIButton *saveBtn = [self createButtonWithTile:@"完成" frame:CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH)];
    [saveBtn addTarget:self action:@selector(p_saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)p_saveBtnClick {
    TSTextFieldView *oldTextFieldView = self.textfieldArray[0];
    TSTextFieldView *new1TextFieldView = self.textfieldArray[1];
    TSTextFieldView *new2TextFieldView = self.textfieldArray[2];
    
    __block NSString *passWordErrorStr = @"";
    [self.textfieldArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (textFieldView.textField.text.length < 6) {
            passWordErrorStr = @"请输入6位密码";
            *stop = YES;
        }
    }];
    if (passWordErrorStr.length) {
        [SVProgressHUD showInfoWithStatus:passWordErrorStr];
        return;
    }
    
    if (![new1TextFieldView.textField.text isEqualToString:new2TextFieldView.textField.text]) {
        passWordErrorStr = @"新密码不一致";
        [SVProgressHUD showInfoWithStatus:passWordErrorStr];
        return;
    }
    
    [SVProgressHUD show];
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    paramsDict[@"phone"] = self.phone;
    paramsDict[@"oldPassword"] = oldTextFieldView.textField.text;
    paramsDict[@"password"] = new2TextFieldView.textField.text;
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        [SVProgressHUD showInfoWithStatus:@"修改成功"];
        [self p_updateUserInfo];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [personalViewModel changePassword];
}

- (void)p_updateUserInfo {
    TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
    userInfo.phone = @"";
    userInfo.password = @"";
    [TSToolsMethod setUserInfoNormal:[userInfo dictWithModel:userInfo]];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
