//
//  LoginGuidViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/11.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "LoginGuidViewController.h"
#import "UIImage+Extension.h"
#import "LoginPageViewController.h"
#import "TSDisclaimerView.h"
#import "TSInstructionsView.h"
#import "AccountViewModel.h"

#define GameBCBC @"BCBC赛事"
#define GameCBO @"CBO赛事"
#define GameNormal @"我的赛事"

@interface LoginGuidViewController () <UIAlertViewDelegate>
@property (nonatomic, copy) NSString *updateUrl;

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, strong) UIButton *bcbcBtn;
@property (nonatomic, strong) UIButton *cboBtn;
@property (nonatomic, strong) UIButton *normalBtn;
@property (nonatomic, weak) UIButton *statementBtn1;
@end

@implementation LoginGuidViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"" backBtnHidden:YES backBtnIconName:@"" navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    UIImage *image = [UIImage imageNamed:@"selectGame_bg_Image"];
    self.view.layer.contents = (id) image.CGImage;
    
    [self p_addSubViews];
    
    [self p_addStatementViews];
    
    [self p_getCurrentVersion];
}

- (void)p_checkVoiceDB {
    if ([TSToolsMethod checkVoiceDBExists]) {
        UIAlertView *dbAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"比赛还没有结束，是否继续比赛？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        dbAlertView.tag = 1;
        [dbAlertView show];
    }
}

- (void)p_getCurrentVersion {
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD show];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    AccountViewModel *accountViewModel = [[AccountViewModel alloc] initWithUserInfoDict:paramsDict];
    [accountViewModel setBlockWithReturnBlock:^(id returnValue) {
        [self p_checkVoiceDB];
        
        NSString *key = @"CFBundleShortVersionString";
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
        if (returnValue[@"entity"][@"version"]) {
            if (![currentVersion isEqualToString:returnValue[@"entity"][@"version"]]) {
                if (returnValue[@"entity"][@"url"]) {
                    self.updateUrl = returnValue[@"entity"][@"url"];
                }
                [self p_showUpdateAlertTips];
            }
        }
        
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [accountViewModel getCurrentVersion];
}

- (void)p_showUpdateAlertTips {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载最新版本，体验全新功能" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil];
    alert.tag = 2;
    [alert show];
}

- (void)p_addStatementViews {
    CGFloat statementBtn1X = W(34);
    CGFloat statementBtn1Y = CGRectGetMaxY(self.bgView.frame) + H(27);
    CGFloat statementBtn1W = W(130);
    CGFloat statementBtn1H = H(17);
    UIButton *statementBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    statementBtn1.frame = CGRectMake(statementBtn1X, statementBtn1Y, statementBtn1W, statementBtn1H);
    [statementBtn1 setTitle:@"我已详细阅读并同意" forState:UIControlStateNormal];
    [statementBtn1 setTitleColor:TSHEXCOLOR(0xbad1ff) forState:UIControlStateNormal];
    [statementBtn1 setImage:[UIImage imageNamed:@"disclaimer_unselect_image"] forState:UIControlStateNormal];
    [statementBtn1 setImage:[UIImage imageNamed:@"disclaimer_select_image"] forState:UIControlStateSelected];
    statementBtn1.titleLabel.font = [UIFont systemFontOfSize:W(12)];
    statementBtn1.adjustsImageWhenHighlighted = NO;
    [statementBtn1 addTarget:self action:@selector(p_agreenDisclaimer:) forControlEvents:UIControlEventTouchUpInside];
    statementBtn1.selected = YES;
    statementBtn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [statementBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [self.view addSubview:statementBtn1];
    self.statementBtn1 = statementBtn1;
    
    CGFloat statementBtn2X = CGRectGetMaxX(statementBtn1.frame) - W(6);
    CGFloat statementBtn2W = W(75);
    CGFloat statementBtn2H = H(40);
    UIButton *statementBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    statementBtn2.frame = CGRectMake(statementBtn2X, 0, statementBtn2W, statementBtn2H);
    statementBtn2.centerY = statementBtn1.centerY;
    [statementBtn2 setTitle:@"《免责声明》" forState:UIControlStateNormal];
    [statementBtn2 setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    statementBtn2.titleLabel.font = [UIFont systemFontOfSize:W(12)];
    statementBtn2.adjustsImageWhenHighlighted = NO;
    [statementBtn2 addTarget:self action:@selector(p_statementBtn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:statementBtn2];
    
    CGFloat statementBtn3X = CGRectGetMaxX(statementBtn2.frame) - W(10);
    CGFloat statementBtn3W = W(125);
    CGFloat statementBtn3H = H(40);
    UIButton *statementBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    statementBtn3.frame = CGRectMake(statementBtn3X, 0, statementBtn3W, statementBtn3H);
    statementBtn3.centerY = statementBtn1.centerY;
    [statementBtn3 setTitle:@"《语音命令使用说明》" forState:UIControlStateNormal];
    [statementBtn3 setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    statementBtn3.titleLabel.font = [UIFont systemFontOfSize:W(12)];
    statementBtn3.adjustsImageWhenHighlighted = NO;
    [statementBtn3 addTarget:self action:@selector(p_statementBtn3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:statementBtn3];
}

- (void)p_agreenDisclaimer:(UIButton *)statementBtn1 {
    statementBtn1.selected = !statementBtn1.selected;
}

- (void)p_statementBtn2Click { // 免责申明
    TSDisclaimerView *disclaimerView = [[TSDisclaimerView alloc] initWithFrame:self.view.bounds];
    [disclaimerView show];
}

- (void)p_statementBtn3Click { // 使用说明
    TSInstructionsView *instView = [[TSInstructionsView alloc] initWithFrame:self.view.bounds ruleType:RuleType3V3];
    [instView show];
}

- (void)p_addSubViews {
    CGFloat marginX = W(8);
    CGFloat bgViewW = self.view.width - 2*marginX;
    CGFloat bgViewH = H(335);
    CGFloat bgViewY = H(97);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(marginX, bgViewY, bgViewW, bgViewH)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    // add title
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"请选择赛事";
    titleLab.font = [UIFont systemFontOfSize:W(16.0)];
    [titleLab sizeToFit];
    titleLab.y = H(36);
    titleLab.centerX = bgView.centerX;
    titleLab.textColor = TSHEXCOLOR(0xc1d6ff);
    [bgView addSubview:titleLab];
    
    // add bcbc button
    self.bcbcBtn = [self p_createButtonWithTitle:GameBCBC];
    self.bcbcBtn.y = H(91);
    [self.bcbcBtn addTarget:self action:@selector(bcbcBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.bcbcBtn];
    
    // add cbo button
    self.cboBtn = [self p_createButtonWithTitle:GameCBO];
    self.cboBtn.y = CGRectGetMaxY(self.bcbcBtn.frame) + H(30);
    [self.cboBtn addTarget:self action:@selector(p_cboBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.cboBtn];
    
    // add normal button
    self.normalBtn = [self p_createButtonWithTitle:GameNormal];
    self.normalBtn.y = CGRectGetMaxY(self.cboBtn.frame) + H(30);
    [self.normalBtn addTarget:self action:@selector(normalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.normalBtn];
}

- (void)bcbcBtnClick:(UIButton *)btn {
    if (!self.statementBtn1.selected) {
        [SVProgressHUD showInfoWithStatus:@"请阅读并同意《免责声明》"];
        return;
    }
    
    LoginPageViewController *loginPage = [[LoginPageViewController alloc] init];
    loginPage.loginType = LoginUserTypeBCBC;
    [self.navigationController pushViewController:loginPage animated:YES];
}

- (void)p_cboBtnClick:(UIButton *)cboBtn {
    if (!self.statementBtn1.selected) {
        [SVProgressHUD showInfoWithStatus:@"请阅读并同意《免责声明》"];
        return;
    }
    
    LoginPageViewController *loginPage = [[LoginPageViewController alloc] init];
    loginPage.loginType = LoginUserTypeCBO;
    [self.navigationController pushViewController:loginPage animated:YES];
}

- (void)normalBtnClick:(UIButton *)btn {
    if (!self.statementBtn1.selected) {
        [SVProgressHUD showInfoWithStatus:@"请阅读并同意《免责声明》"];
        return;
    }
    
    LoginPageViewController *loginPage = [[LoginPageViewController alloc] init];
    loginPage.loginType = LoginUserTypeNormal;
    [self.navigationController pushViewController:loginPage animated:YES];
}

- (UIButton *)p_createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat marginX = W(28);
    CGFloat buttonW = self.bgView.width - 2*marginX;
    CGFloat buttonH = H(45);
    button.frame = CGRectMake(marginX, 0, buttonW, buttonH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = W(5);
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:W(17.0)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0x27395d) size:CGSizeMake(buttonW, buttonH)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(buttonW, buttonH)] forState:UIControlStateHighlighted];
    
    return button;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == alertView.tag) {
        if (0 == buttonIndex) {
            NSString *documentsPath = nil;
            NSArray *appArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsPath = [appArray objectAtIndex:0];
            NSString *tsdbPath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", TSDBName]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:tsdbPath error:nil];
        } else {
            [(AppDelegate *)[UIApplication sharedApplication].delegate setVoicePageBeRootView];
        }
    } else if (2 == alertView.tag) {
        if (self.updateUrl.length) {
            // https://itunes.apple.com/cn/app/yu-yin-ji-tong/id1273077473?mt=8
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
        }
        [self p_showUpdateAlertTips];
    }
}
@end
