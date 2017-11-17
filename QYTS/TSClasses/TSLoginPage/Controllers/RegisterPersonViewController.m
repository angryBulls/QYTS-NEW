//
//  RegisterPersonViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "RegisterPersonViewController.h"
#import "TSTextFieldView.h"
#import "AccountViewModel.h"
#import "UIImage+Extension.h"
#import "GameSelectViewController.h"

@interface RegisterPersonViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *textfieldArray;
@end

@implementation RegisterPersonViewController
- (NSMutableArray *)textfieldArray {
    if (!_textfieldArray) {
        _textfieldArray = [NSMutableArray array];
    }
    return _textfieldArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"个人注册" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self showNavgationBarBottomLine];
    
    [self p_addSubViews];
}

- (void)p_addSubViews {
    CGFloat marginX = W(8);
    CGFloat bgViewW = self.view.width - 2*marginX;
    CGFloat bgViewH = H(332);
    CGFloat bgViewY = H(100);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(marginX, bgViewY, bgViewW, bgViewH)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    [self p_createLeftTitleViews];
    
    [self p_createrightTextfieldViews];
    
    [self p_createRegisterButton];
}

- (void)p_createLeftTitleViews {
    NSArray *titleArray = @[@"姓名：", @"手机号：", @"验证码：", @"输入密码：", @"确认密码：", @"邀请码："];
    
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
    NSArray *placeholderArray = @[@"请输入姓名", @"请输入手机号", @"请输入验证码", @"请输入6-18位英文/字母组合", @"请输入再次输入密码", @"请输入邀请码(非必填)"];
    
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
            TSTextFieldType = TSTextFieldTypeName;
        } else if (1 == idx) {
            TSTextFieldType = TSTextFieldTypePhone;
        } else if (2 == idx) {
            TSTextFieldType = TSTextFieldTypeAuth;
        } else if (5 == idx) {
            TSTextFieldType = TSTextFieldTypeInviteCode;
        } else {
            TSTextFieldType = TSTextFieldTypePassword;
        }
        
        if (2 == idx) {
            rightTextfieldW = rightView.width*0.6;
        } else {
            rightTextfieldW = rightViewW*0.95;
        }
        CGRect textFieldViewFrame = CGRectMake(rightTextfieldX, rightTextfieldY, rightTextfieldW, rightTextfieldH);
        TSTextFieldView *textFieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:placeholderName textfieldType:TSTextFieldType];
        textFieldView.textFieldBeginEditingBlock = ^{
            if (5 == idx) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.y = - H(60);
                }];
            }
        };
        textFieldView.textFieldShouldReturnBlock = ^{
            if (5 == idx) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.y = 0;
                }];
            }
        };
        [self p_cutomTextfieldStyle:textFieldView];
        [rightView addSubview:textFieldView];
        [self.textfieldArray addObject:textFieldView];
        
        // add send auth code button
        if (2 == idx) {
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

- (void)p_sendCodeBtnClick:(UIButton *)sendCodeBtn {
    TSTextFieldView *phoneTextFieldView = self.textfieldArray[1];
    if (phoneTextFieldView.textField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
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
    userInfoDict[@"action"] = @"注册";
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"fetch code returnValue is:%@", returnValue);
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [loginViewModel fetchAuthCode];
}

- (void)p_createRegisterButton {
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat MarginX = W(25);
    CGFloat registerBtnY = CGRectGetMaxY(self.bgView.frame) + H(36);
    CGFloat registerBtnW = self.view.width - 2*MarginX;
    CGFloat registerBtnH = H(43);
    
    registerBtn.frame = CGRectMake(MarginX, registerBtnY, registerBtnW, registerBtnH);
    [registerBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [registerBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [registerBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(registerBtnW, registerBtnH)] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(registerBtnW, registerBtnH)] forState:UIControlStateHighlighted];
    registerBtn.layer.cornerRadius = registerBtnH*0.5;
    registerBtn.layer.masksToBounds = YES;
    [registerBtn addTarget:self action:@selector(p_registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (BOOL)p_checkTextfieldContent { // 验证资料是否填写完整和正确
    __block NSString *errorStr = @"";
    [self.textfieldArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) { // 姓名
            if ( textFieldView.textField.text.length <2 || textFieldView.textField.text.length>14) {
                errorStr = @"请填写姓名";
                *stop = YES;
            }
        }
        
        if (1 == idx) { // 手机号
            if (11 != textFieldView.textField.text.length) {
                errorStr = @"请填写正确的手机号";
                *stop = YES;
            }
        }
        
        if (2 == idx) { // 验证码
            if (4 != textFieldView.textField.text.length) {
                errorStr = @"请填写验证码";
                *stop = YES;
            }
        }
        
        if (3 == idx) { // 密码1
            if (textFieldView.textField.text.length < 6 ||textFieldView.textField.text.length > 18) {
                errorStr = @"请填写正确密码";
                *stop = YES;
            }
        }
        
        if (4 == idx) { // 密码2
            if (textFieldView.textField.text.length < 6 ||textFieldView.textField.text.length > 18) {
                errorStr = @"请填写正确密码";
                *stop = YES;
            } else {
                TSTextFieldView *textFieldView1 = self.textfieldArray[3];
                if (![textFieldView1.textField.text isEqualToString:textFieldView.textField.text]) {
                    errorStr = @"密码不一致";
                    *stop = YES;
                }
            }
        }
        
        if (5 == idx) { // 邀请码
            if (textFieldView.textField.text.length != 4 && textFieldView.textField.text.length != 0) {
                errorStr = @"请填写正确邀请码";
                *stop = YES;
            }
        }
    }];
    
    if (errorStr.length) {
        [SVProgressHUD showInfoWithStatus:errorStr];
        return YES;
    }
    
    return NO;
}

- (void)p_registerBtnClick {
    if ([self p_checkTextfieldContent]) {
        return;
    }
    
    [self p_checkMicrophoneAuthorizationStatus];
}

- (void)p_checkMicrophoneAuthorizationStatus {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) { // Microphone enabled code
            DDLog(@"Microphone enabled code");
            [self p_startRegisterUser];
        } else { // Microphone disabled code
            DDLog(@"Microphone disabled code");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"直接使用麦克风录制音频" message:SetupMicrophoneStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self p_setupMicrophone];
            }];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
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

- (void)p_startRegisterUser {
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD show];
    
    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
    [self.textfieldArray enumerateObjectsUsingBlock:^(TSTextFieldView *textFieldView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) {
            userInfoDict[@"name"] = textFieldView.textField.text;
        }
        
        if (1 == idx) {
            userInfoDict[@"phone"] = textFieldView.textField.text;
        }
        
        if (2 == idx) {
            userInfoDict[@"code"] = textFieldView.textField.text;
        }
        
        if (3 == idx) {
            userInfoDict[@"password"] = textFieldView.textField.text;
        }
        
        if (5 == idx) {
            userInfoDict[@"inviteCode"] = textFieldView.textField.text;
        }
    }];
    AccountViewModel *loginViewModel = [[AccountViewModel alloc] initWithUserInfoDict:userInfoDict];
    [loginViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"register user returnValue:%@", returnValue);
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
    [loginViewModel registerUser];
}
@end
