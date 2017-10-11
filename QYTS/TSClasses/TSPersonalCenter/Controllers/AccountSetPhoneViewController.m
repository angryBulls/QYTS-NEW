//
//  AccountSetPhoneViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AccountSetPhoneViewController.h"
#import "TSTextFieldView.h"
#import "AccountViewModel.h"
#import "PersonalViewModel.h"

@interface AccountSetPhoneViewController ()
@property (nonatomic, copy) ChangePhoneSuccessBlock changePhoneSuccessBlock;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *textfieldArray;
@end

@implementation AccountSetPhoneViewController
- (instancetype)initWithBlock:(ChangePhoneSuccessBlock)changePhoneSuccessBlock {
    if (self = [super init]) {
        _changePhoneSuccessBlock = changePhoneSuccessBlock;
    }
    return self;
}

- (NSMutableArray *)textfieldArray {
    if (!_textfieldArray) {
        _textfieldArray = [NSMutableArray array];
    }
    return _textfieldArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"修改手机号" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_addSubViews];
    
    [self p_createSaveButton];
}

- (void)p_addSubViews {
    CGFloat marginX = W(8);
    CGFloat bgViewW = self.view.width - 2*marginX;
    CGFloat bgViewH = H(120);
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
    NSArray *titleArray = @[@"手机号：", @"验证码："];
    
    CGFloat leftViewX = 0;
    CGFloat leftViewY = 10;
    CGFloat leftViewW = W(88);
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
    NSArray *placeholderArray = @[@"请输入手机号", @"请输入验证码"];
    
    CGFloat rightViewX = W(88);
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
        
        TSTextFieldType TSTextFieldType = TSTextFieldTypeName;
        if (0 == idx) {
            TSTextFieldType = TSTextFieldTypePhone;
        } else if (1 == idx) {
            TSTextFieldType = TSTextFieldTypeAuth;
        }
        
        if (1 == idx) {
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
        if (1 == idx) {
            [self p_addSendcodeButtonWithTextfield:textFieldView rightView:rightView];
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

- (void)p_addSendcodeButtonWithTextfield:(TSTextFieldView *)textFieldView rightView:(UIView *)rightView {
    CGFloat sendCodeBtnW = rightView.width*0.95 - textFieldView.width - 9;
    CGFloat sendCodeBtnH = H(30);
    CGFloat sendCodeBtnX = textFieldView.width + 9;
    UIButton *sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCodeBtn.frame = CGRectMake(sendCodeBtnX, CGRectGetMaxY(textFieldView.frame) - sendCodeBtnH - 8, sendCodeBtnW, sendCodeBtnH);
    [sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
    [sendCodeBtn setTitleColor:TSHEXCOLOR(0xbfd4ff) forState:UIControlStateNormal];
    sendCodeBtn.layer.masksToBounds = YES;
    sendCodeBtn.layer.cornerRadius = W(5);
    sendCodeBtn.layer.borderWidth = 1.0;
    sendCodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    sendCodeBtn.backgroundColor = TSHEXCOLOR(0x27395d);
    [sendCodeBtn addTarget:self action:@selector(p_sendCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:sendCodeBtn];
}

- (void)p_createSaveButton {
    CGFloat saveBtnX = W(24.5);
    CGFloat saveBtnW = self.view.width - 2*saveBtnX;
    CGFloat saveBtnH = H(43);
    CGFloat saveBtnY = H(250);
    UIButton *saveBtn = [self createButtonWithTile:@"完成" frame:CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH)];
    [saveBtn addTarget:self action:@selector(p_saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)p_sendCodeBtnClick:(UIButton *)sendCodeBtn {
    TSTextFieldView *phoneTextFieldView = self.textfieldArray[0];
    if (phoneTextFieldView.textField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        if ([phoneTextFieldView.textField.text isEqualToString:userInfo.phone]) {
            [SVProgressHUD showInfoWithStatus:@"手机号与当前号码重复"];
            return;
        }
    }
    
    sendCodeBtn.enabled = NO;
    [self.view endEditing:YES];
    
    TSToolsMethod *toolsMethod = [[TSToolsMethod alloc] init];
    [toolsMethod startGCDTimerWithDuration:60 countdownReturnBlock:^(NSString *timeString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sendCodeBtn setTitle:[NSString stringWithFormat:@"%@S",timeString] forState:UIControlStateNormal];
            if ([sendCodeBtn.currentTitle isEqualToString:@"0S"]) {
                sendCodeBtn.enabled = YES;
                [sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            }
        });
    }];
    
    [self p_fetchAuthCodeWithPhone:phoneTextFieldView.textField.text];
}

- (void)p_fetchAuthCodeWithPhone:(NSString *)phoneNumber {
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    userInfoDict[@"phone"] = phoneNumber;
    userInfoDict[@"action"] = @"修改手机号";
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"change phone fetch code returnValue is:%@", returnValue);
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [loginViewModel fetchAuthCode];
}

- (void)p_saveBtnClick {
    __block NSString *showString = @"";
    [self.textfieldArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) {
            if (textFieldView.textField.text.length != 11) {
                showString = @"请输入正确的手机号";
                *stop = YES;
            }
        } else if (1 == idx) {
            if (textFieldView.textField.text.length != 4) {
                showString = @"请输入正确的验证码";
            }
        }
    }];
    if (showString.length) {
        [SVProgressHUD showInfoWithStatus:showString];
        return;
    }
    
    [SVProgressHUD show];
    TSTextFieldView *phoneTextFieldView = self.textfieldArray[0];
    TSTextFieldView *codeTextFieldView = self.textfieldArray[1];
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    paramsDict[@"newPhone"] = phoneTextFieldView.textField.text;
    paramsDict[@"code"] = codeTextFieldView.textField.text;
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"change phone returnValue is:%@", returnValue);
        [SVProgressHUD showInfoWithStatus:@"修改成功"];
        [self p_updateUserInfo];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [personalViewModel changePhone];
}

- (void)p_updateUserInfo {
    TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
    userInfo.phone = @"";
    userInfo.password = @"";
    [TSToolsMethod setUserInfoNormal:[userInfo dictWithModel:userInfo]];
    
    self.changePhoneSuccessBlock ? self.changePhoneSuccessBlock() : nil;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
