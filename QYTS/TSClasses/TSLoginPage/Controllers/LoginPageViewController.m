//
//  LoginPageViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "LoginPageViewController.h"
#import "TSTextFieldView.h"
#import "UIImage+Extension.h"
#import "AccountViewModel.h"
#import "RegisterPersonViewController.h"
#import "PreGameCheckBCBCViewController.h"
#import "GameSelectViewController.h"
#import "AccountSetForgetPDViewController.h"
#import "CBOUncheckListViewController.h"

#define NoAccountUser @"无账号的技术统计人员\n请向合作伙伴联系！"
#define SwitchTitleAuth @"切换验证码登录"
#define SwitchTitlePass @"切换密码登录"

@interface LoginPageViewController ()
@property (nonatomic, strong) TSTextFieldView *nameTextFieldView;
@property (nonatomic, strong) TSTextFieldView *passWordTextFieldView;
@property (nonatomic, strong) TSTextFieldView *authTextFieldView;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *sendCodeBtn;
@property (nonatomic, strong) UIButton *rememberPDBtn;
@property (nonatomic, strong) UIButton *forgetPDBtn;
@end

@implementation LoginPageViewController
#pragma mark - lazy method
- (TSTextFieldView *)nameTextFieldView {
    if (!_nameTextFieldView) {
        CGRect textFieldViewFrame = CGRectMake(W(45), H(169), self.view.width - 2*W(45), H(41));
        TSTextFieldType TSTextFieldType = TSTextFieldTypeName;
        NSString *placeholderStr = @"用户名（英文或数字六位）";
        if (self.loginType == LoginUserTypeNormal) {
            TSTextFieldType = TSTextFieldTypePhone;
            placeholderStr = @"请输入手机号";
        }
        _nameTextFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"login_username_Iocn" placeholder:placeholderStr textfieldType:TSTextFieldType];
    }
    
    return _nameTextFieldView;
}

- (TSTextFieldView *)passWordTextFieldView {
    if (!_passWordTextFieldView) {
        CGRect textFieldViewFrame = CGRectMake(W(45), H(234), self.view.width - 2*W(45), H(41));
        _passWordTextFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"login_password_Iocn" placeholder:@"密码（英文或数字六位）" textfieldType:TSTextFieldTypePassword];
    }
    
    return _passWordTextFieldView;
}

- (TSTextFieldView *)authTextFieldView {
    if (!_authTextFieldView) {
        CGFloat authTextFieldW = (self.view.width - 2*W(45))*0.6;
        CGRect textFieldViewFrame = CGRectMake(W(45), H(234), authTextFieldW, H(41));
        _authTextFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"login_password_Iocn" placeholder:@"输入验证码" textfieldType:TSTextFieldTypeAuth];
    }
    return _authTextFieldView;
}

- (UIButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        CGFloat sendCodeBtnW = (self.view.width - 2*W(45))*0.37;
        CGFloat sendCodeBtnX = self.view.width - W(45) - sendCodeBtnW;
        _sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCodeBtn.frame = CGRectMake(sendCodeBtnX, H(234), sendCodeBtnW, H(41));
        [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
        [_sendCodeBtn setTitleColor:TSHEXCOLOR(0x666666) forState:UIControlStateNormal];
        _sendCodeBtn.layer.masksToBounds = YES;
        _sendCodeBtn.layer.cornerRadius = W(5);
        _sendCodeBtn.backgroundColor = [UIColor whiteColor];
        [_sendCodeBtn addTarget:self action:@selector(p_sendCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendCodeBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    UIImage *image = [UIImage imageNamed:@"longin_bg_image"];
    self.view.layer.contents = (id) image.CGImage;
    
    [self p_addTitle];
    
    [self p_AddLoginTextFieldViews];
    
    if (self.loginType == LoginUserTypeNormal) {
        [self p_addGameNormalViews];
    }
    
    [self p_createRememberPasswordButton];
    if (self.loginType == LoginUserTypeNormal) {
        [self p_createForgetPasswordButton];
    }
}

#pragma mark - custom method
- (void)p_addTitle {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W(40), H(17.5))];
    titleLab.y = H(83);
    titleLab.centerX = self.view.centerX;
    titleLab.text = @"登录";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:W(19.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    [self.view addSubview:titleLab];
}

- (void)p_AddLoginTextFieldViews {
    [self.view addSubview:self.nameTextFieldView];
    [self.view addSubview:self.passWordTextFieldView];
    
    // add login button
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(self.passWordTextFieldView.x, CGRectGetMaxY(self.passWordTextFieldView.frame) + H(89), self.view.width - 2*self.passWordTextFieldView.x, H(41));
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = H(6);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [loginBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button_Image_normal"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button_Image_highlight"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(p_loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
}

- (void)p_addGameNormalViews { // 加载普通赛事相应的按钮
    // verification code button
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(self.passWordTextFieldView.x, self.loginBtn.y - H(40), W(100), H(30));
    [switchBtn setTitle:SwitchTitleAuth forState:UIControlStateNormal];
    switchBtn.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
    [switchBtn setTitleColor:TSHEXCOLOR(0xd9e4ff) forState:UIControlStateSelected];
    [switchBtn addTarget:self action:@selector(p_switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    self.switchBtn = switchBtn;
    
    // add register button
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(CGRectGetMaxX(self.passWordTextFieldView.frame) - W(60), switchBtn.y, W(60), H(30));
    [registerBtn setTitle:@"我要注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = switchBtn.titleLabel.font;
    [registerBtn setTitleColor:TSHEXCOLOR(0xd9e4ff) forState:UIControlStateSelected];
    [registerBtn addTarget:self action:@selector(p_registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)p_switchBtnClick:(UIButton *)switchBtn {
    if ([switchBtn.currentTitle isEqualToString:SwitchTitleAuth]) {
        [switchBtn setTitle:SwitchTitlePass forState:UIControlStateNormal];
        self.passWordTextFieldView.hidden = YES;
        
        if (!_authTextFieldView) {
            [self.view addSubview:self.authTextFieldView];
        }
        self.authTextFieldView.hidden = NO;
        
        if (!_sendCodeBtn) {
            [self.view addSubview:self.sendCodeBtn];
        }
        self.sendCodeBtn.hidden = NO;
        self.rememberPDBtn.hidden = YES;
        self.forgetPDBtn.hidden = YES;
    } else {
        [switchBtn setTitle:SwitchTitleAuth forState:UIControlStateNormal];
        self.passWordTextFieldView.hidden = NO;
        self.authTextFieldView.hidden = YES;
        self.sendCodeBtn.hidden = YES;
        self.rememberPDBtn.hidden = NO;
        self.forgetPDBtn.hidden = NO;
    }
}

- (void)p_createRememberPasswordButton {
    CGFloat rememberPDBtnX = self.passWordTextFieldView.x;
    CGFloat rememberPDBtnY = CGRectGetMaxY(self.passWordTextFieldView.frame) + H(10);
    CGFloat rememberPDBtnW = W(90);
    CGFloat rememberPDBtnH = H(17);
    UIButton *rememberPDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberPDBtn.frame = CGRectMake(rememberPDBtnX, rememberPDBtnY, rememberPDBtnW, rememberPDBtnH);
    [rememberPDBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [rememberPDBtn setTitleColor:TSHEXCOLOR(0xbad1ff) forState:UIControlStateNormal];
    [rememberPDBtn setImage:[UIImage imageNamed:@"disclaimer_unselect_image"] forState:UIControlStateNormal];
    [rememberPDBtn setImage:[UIImage imageNamed:@"disclaimer_select_image"] forState:UIControlStateSelected];
    rememberPDBtn.titleLabel.font = [UIFont systemFontOfSize:W(12)];
    rememberPDBtn.adjustsImageWhenHighlighted = NO;
    [rememberPDBtn addTarget:self action:@selector(p_rememberPDBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rememberPDBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rememberPDBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.view addSubview:rememberPDBtn];
    self.rememberPDBtn = rememberPDBtn;
    
    if (LoginUserTypeBCBC ==  self.loginType) {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        if (1 == userInfo.rememberPD.intValue) { // 记住密码
            self.rememberPDBtn.selected = YES;
            self.nameTextFieldView.textField.text = userInfo.loginName;
            self.passWordTextFieldView.textField.text = userInfo.password;
        }
    } else if (LoginUserTypeCBO ==  self.loginType) {
        TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
        if (1 == userInfo.rememberPD.intValue) { // 记住密码
            self.rememberPDBtn.selected = YES;
            self.nameTextFieldView.textField.text = userInfo.loginName;
            self.passWordTextFieldView.textField.text = userInfo.password;
        }
    } else if (LoginUserTypeNormal ==  self.loginType) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        if (1 == userInfo.rememberPD.intValue) { // 记住密码
            self.rememberPDBtn.selected = YES;
            self.nameTextFieldView.textField.text = userInfo.phone;
            self.passWordTextFieldView.textField.text = userInfo.password;
        }
    } else {
        self.rememberPDBtn.selected = NO;
    }
}

- (void)p_rememberPDBtnClick:(UIButton *)rememberPDBtn {
    rememberPDBtn.selected = !rememberPDBtn.selected;
}

- (void)p_createForgetPasswordButton {
    CGFloat forgetPDBtnW = W(70);
    CGFloat forgetPDBtnX = self.view.width - forgetPDBtnW - self.passWordTextFieldView.x;
    CGFloat forgetPDBtnY = CGRectGetMaxY(self.passWordTextFieldView.frame) + H(10);
    CGFloat forgetPDBtnH = H(17);
    UIButton *forgetPDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPDBtn.frame = CGRectMake(forgetPDBtnX, forgetPDBtnY, forgetPDBtnW, forgetPDBtnH);
    [forgetPDBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPDBtn setTitleColor:TSHEXCOLOR(0xbad1ff) forState:UIControlStateNormal];
    forgetPDBtn.titleLabel.font = [UIFont systemFontOfSize:W(12)];
    forgetPDBtn.adjustsImageWhenHighlighted = NO;
    [forgetPDBtn addTarget:self action:@selector(p_forgetPDBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPDBtn];
    self.forgetPDBtn = forgetPDBtn;
}

- (void)p_forgetPDBtnClick:(UIButton *)forgetPDBtn {
    AccountSetForgetPDViewController *forgetPDVC = [[AccountSetForgetPDViewController alloc] init];
    [self.navigationController pushViewController:forgetPDVC animated:YES];
}

- (void)p_sendCodeBtnClick:(UIButton *)sendCodeBtn {
    if (self.nameTextFieldView.textField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    sendCodeBtn.enabled = NO;
    [self.view endEditing:YES];
    
    TSToolsMethod *toolsMethod = [[TSToolsMethod alloc] init];
    [toolsMethod startGCDTimerWithDuration:60 countdownReturnBlock:^(NSString *timeString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%@S",timeString] forState:UIControlStateNormal];
            if ([self.sendCodeBtn.currentTitle isEqualToString:@"0S"]) {
                sendCodeBtn.enabled = YES;
                [sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            }
        });
    }];
    
    [self p_fetchAuthCode];
}

- (void)p_fetchAuthCode { // 获取验证码
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    userInfoDict[@"phone"] = self.nameTextFieldView.textField.text;
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [loginViewModel fetchAuthCode];
}

- (void)p_registerBtnClick {
    RegisterPersonViewController *registerVC = [[RegisterPersonViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)p_loginBtnClick {
    if (self.loginType == LoginUserTypeNormal) {
        if (self.nameTextFieldView.textField.text.length != 11) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
            return;
        }
        
        if ([self.switchBtn.currentTitle isEqualToString:SwitchTitlePass]) { // 普通用户使用验证码登录
            if (0 == self.authTextFieldView.textField.text.length) {
                [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
                return;
            }
        } else if ([self.switchBtn.currentTitle isEqualToString:SwitchTitleAuth]) { // 普通用户使用密码登录
            if (self.passWordTextFieldView.textField.text.length < 4) {
                [SVProgressHUD showInfoWithStatus:@"请输入4-6位密码"];
                return;
            }
        }
    } else if (self.loginType == LoginUserTypeBCBC) {
        if (0 == self.nameTextFieldView.textField.text.length) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的用户名"];
            return;
        }
        
        if (self.passWordTextFieldView.textField.text.length < 4) {
            [SVProgressHUD showInfoWithStatus:@"请输入4-6位密码"];
            return;
        }
    }
    
    [self p_checkMicrophoneAuthorizationStatus];
}

- (void)p_checkMicrophoneAuthorizationStatus {
    self.view.userInteractionEnabled = NO;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) { // Microphone enabled code
            DDLog(@"Microphone enabled code");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.nameTextFieldView.textField resignFirstResponder];
                [self.passWordTextFieldView.textField resignFirstResponder];
                
                [SVProgressHUD show];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                
                [self p_startLogin];
            });
        } else { // Microphone disabled code
            DDLog(@"Microphone disabled code");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"直接使用麦克风录制音频" message:SetupMicrophoneStr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self p_setupMicrophone];
                }];
                [alertController addAction:confirmAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
}

- (void)p_setupMicrophone {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:MicrophoneURLStr]]) {
        if (TSiOSGreaterThanTen) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MicrophoneURLStr] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MicrophoneURLStr]];
        }
    }
}

- (void)p_startLogin {
    if (self.loginType == LoginUserTypeBCBC) { // BCBC用户登录
        [self p_startLoginBCBC];
    } else if (LoginUserTypeCBO == self.loginType) { // CBO用户登录
        [self p_startLoginCBO];
    } else if (self.loginType == LoginUserTypeNormal) { // 群众用户登录
        [self p_startLoginNomarl];
    }
}

- (void)p_startLoginBCBC {
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    userInfoDict[@"loginname"] = self.nameTextFieldView.textField.text;
    userInfoDict[@"password"] = self.passWordTextFieldView.textField.text;
    
    self.rememberPDBtn.selected ? (userInfoDict[@"rememberPD"] = @"1") : (userInfoDict[@"rememberPD"] = @"0");
    TSWeakSelf;
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"returnValue is:%@", returnValue);
        
        [SVProgressHUD dismiss];
        __weakSelf.view.userInteractionEnabled = YES;
        PreGameCheckBCBCViewController *checkBCBCVC = [[PreGameCheckBCBCViewController alloc] init];
        [self.navigationController pushViewController:checkBCBCVC animated:YES];
    } WithErrorBlock:^(id errorCode) {
        __weakSelf.view.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        __weakSelf.view.userInteractionEnabled = YES;
    }];
    [loginViewModel loginBCBC];
}

- (void)p_startLoginCBO {
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    userInfoDict[@"loginname"] = self.nameTextFieldView.textField.text;
    userInfoDict[@"password"] = self.passWordTextFieldView.textField.text;
    
    self.rememberPDBtn.selected ? (userInfoDict[@"rememberPD"] = @"1") : (userInfoDict[@"rememberPD"] = @"0");
    TSWeakSelf;
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"cbo user login returnValue is:%@", returnValue);
        
        [SVProgressHUD dismiss];
        __weakSelf.view.userInteractionEnabled = YES;
        CBOUncheckListViewController *cboUncheckListVC = [[CBOUncheckListViewController alloc] init];
        [self.navigationController pushViewController:cboUncheckListVC animated:YES];
    } WithErrorBlock:^(id errorCode) {
        __weakSelf.view.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        __weakSelf.view.userInteractionEnabled = YES;
    }];
    [loginViewModel loginCBO];
}

- (void)p_startLoginNomarl {
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    userInfoDict[@"phone"] = self.nameTextFieldView.textField.text;
    if ([self.switchBtn.currentTitle isEqualToString:SwitchTitlePass]) { // 普通用户使用验证码登录
        userInfoDict[@"password"] = self.authTextFieldView.textField.text;
    } else if ([self.switchBtn.currentTitle isEqualToString:SwitchTitleAuth]) { // 普通用户使用密码登录
        userInfoDict[@"password"] = self.passWordTextFieldView.textField.text;
        self.rememberPDBtn.selected ? (userInfoDict[@"rememberPD"] = @"1") : (userInfoDict[@"rememberPD"] = @"0");
    }
    
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"returnValue is:%@", returnValue);
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        GameSelectViewController *gameSelectVC = [[GameSelectViewController alloc] init];
        [self.navigationController pushViewController:gameSelectVC animated:YES];
    } WithErrorBlock:^(id errorCode) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        self.view.userInteractionEnabled = YES;
    }];
    
    if ([self.switchBtn.currentTitle isEqualToString:SwitchTitlePass]) { // 普通用户使用验证码登录
        [loginViewModel loginNormalByVCode];
    } else if ([self.switchBtn.currentTitle isEqualToString:SwitchTitleAuth]) { // 普通用户使用密码登录
        [loginViewModel loginNormal];
    }
}
@end
