//
//  AppDelegate.m
//  QYTS
//
//  Created by lxd on 2017/7/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginGuidViewController.h"
#import "LoginPageViewController.h"
#import "VoiceStatisticsViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "TSNewfeatureViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXPayApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMMobClick/MobClick.h"
#import "TSAdvertisementViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];
    [self p_SetupSVProgressHUDStyle];
    
    [self p_setupIfly];
    
    [self p_PrivateSetupThirdWithLaunchOptions:launchOptions];
    
    [self switchRootViewController];
    
    return YES;
}

- (void)switchRootViewController {
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        [self switchWindowView];
    } else { // 首次启动app
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setCurrentPageBeRootView:[[TSNewfeatureViewController alloc] init]];
    }
}

- (void)switchWindowView {
    if (ReachableViaWiFi == [TSNetworkManger checkCurrentNetWorkType]) {
        [self setAdvertisementBeRootView];
    } else {
        [self setGuidPageBeRootView];
    }
}

- (void)p_SetupSVProgressHUDStyle {
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]]; //字体颜色
//    [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
}

#pragma mark - 友盟相关配置
- (void)p_PrivateSetupThirdWithLaunchOptions:(NSDictionary *)launchOptions {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:My_UMeng_Appkey];
    
    // 友盟统计配置
    UMConfigInstance.appKey = My_UMeng_Appkey;
    UMConfigInstance.channelId = @"App Store";
    DDLog(@"version is:%@", kVersion_Coding);
    [MobClick setAppVersion:kVersion_Coding];
    [MobClick setEncryptEnabled:NO];
    [MobClick setLogEnabled:NO];
    [MobClick startWithConfigure:UMConfigInstance];
    
    [self configUSharePlatforms];
}

- (void)configUSharePlatforms {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WXAppId_Pay appSecret:@"93f111771cf9367bae48b3c6d6c0532d" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1314434399"  appSecret:@"3cdd196362a987a17838db2a1471ceec" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // 微信支付注册
    [WXApi registerApp:WXAppId_Pay enableMTA:YES];
}

#pragma mark - 讯飞相关配置
- (void)p_setupIfly {
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IFLY_APPID_VALUE];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

- (void)setAdvertisementBeRootView {
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:[[TSAdvertisementViewController alloc] init]];
    rootNav.navigationBar.hidden = YES;
    [self setCurrentPageBeRootView:rootNav];
}

- (void)setGuidPageBeRootView {
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:[[LoginGuidViewController alloc] init]];
    rootNav.navigationBar.hidden = YES;
    [self setCurrentPageBeRootView:rootNav];
}

- (void)setVoicePageBeRootView {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[VoiceStatisticsViewController alloc] init]];
    nav.navigationBar.hidden = YES;
    [self setCurrentPageBeRootView:nav];
}

- (void)setCurrentPageBeRootView:(UIViewController *)viewController {
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [UIView transitionWithView:self.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ self.window.rootViewController = viewController; }
                        completion:nil];
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url { // 微信支付回调
    return  [WXApi handleOpenURL:url delegate:[WXPayApiManager sharedManager]];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                DDLog(@"result = %@",resultDic);
            }];
        } else {
            return  [WXApi handleOpenURL:url delegate:[WXPayApiManager sharedManager]]; // 微信支付回调
        }
    }
    return result;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:TSDidBecomeActiveNotif object:nil];
}
@end
