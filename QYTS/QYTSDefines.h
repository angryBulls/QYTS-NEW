//
//  QYTSDefines.h
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#ifndef QYTSDefines_h
#define QYTSDefines_h

/** 快速设置颜色宏 */
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define TSCOLOR_ALPHA(r, g, b, a)                                             \
[UIColor colorWithRed:(r) / 255.0                                            \
green:(g) / 255.0                                            \
blue:(b) / 255.0                                            \
alpha:a * 1.0]
#define TSCOLOR(r, g, b)                                                      \
[UIColor colorWithRed:(r) / 255.0                                            \
green:(g) / 255.0                                            \
blue:(b) / 255.0                                            \
alpha:1.0]
#define TSHEXCOLOR_ALPHA(c, a) [UIColor colorWithHexValue:c alpha:a]
#define TSHEXCOLOR(c) [UIColor colorWithHexValue:c alpha:1.0]
#define POPHEXCOLOR(c) [UIColor colorWithHexValue:c alpha:1.0]

/** 设备判断 */
#define IS_IPHONE_4                                                            \
(fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) <    \
DBL_EPSILON)
#define IS_IPHONE_5                                                            \
(fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) <    \
DBL_EPSILON)
#define IS_IPHONE_6                                                            \
(fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) <    \
DBL_EPSILON)
#define IS_IPHONE_6plus                                                        \
(fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) <    \
DBL_EPSILON)
/** 屏幕适配比例 */
#define W(float) SCREEN_WIDTH / 375 * (float)
#define H(float) SCREEN_HEIGHT / 667 * (float)
/**全局配色*/
#define BASE_COLOR TSCOLOR(33, 198, 200)
#define BASE_GRAY_CLOR TSHEXCOLOR(0x999999)
#define BASE_6_COLOR TSHEXCOLOR(0x666666)
#define BASE_3_COLOR TSHEXCOLOR(0x333333)
#define BASE_9_COLOR TSHEXCOLOR(0x999999)
#define BASE_CELL_LINE_COLOR TSHEXCOLOR(0xdddddd)
#define BASE_VC_COLOR TSHEXCOLOR(0xf5f5f5)
#define BASE_ORAGEN_COLOR TSCOLOR(252,133,37)
//---------------------------------------------------------------

/** 全局字体*/
#define TSFONT(f) [UIFont systemFontOfSize:(f)]
#define BASE_FONT TSFONT(16)
#define TSHYLingXinFont(f) [UIFont fontWithName:@"HYk2gj" size:(f)]

/** 系统版本*/
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kBundleIdentifier_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
//版本号
#define kVersion_Coding                                                        \
[[NSBundle mainBundle]                                                       \
objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild_Coding                                                   \
[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
/** defines a weak `self` named `__weakSelf` */
#define TSWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define TSWeakSelf TSWeak(self, __weakSelf);
/**ios系统版本大于等于8.0*/
#define TSiOSGreaterThanEight                                                 \
([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
/**ios系统版本大于等于9.0*/
#define TSiOSGreaterThanNine                                                \
([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
/**ios系统版本大于等于10.0*/
#define TSiOSGreaterThanTen                                                \
([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

// CC视频相关 ////////////////////
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define DWAPPDELEGATE ((AppDelegate*)([[UIApplication sharedApplication] delegate]))
///////////////////////////
#define TSUserDefaults [NSUserDefaults standardUserDefaults]

/** 防止循环引用 */
#define TSWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define TSWeakSelf TSWeak(self, __weakSelf);

#define SetupMicrophoneStr @"“BCBC技术统计语音版”需要使用麦克风权限。您可以在“设置”中，允许“BCBC技术统计语音版”使用麦克风权限"

#define CurrentUserType [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue]

static NSString * const ServiceTelephone = @"4006313677";

//#define ColorArray @[@[@"青色", TSHEXCOLOR(0x299af0)], @[@"蓝色", TSHEXCOLOR(0x0c29ff)], @[@"紫色", TSHEXCOLOR(0x8b00ff)], @[@"白色", TSHEXCOLOR(0xffffff)], @[@"黑色", TSHEXCOLOR(0x181818)], @[@"红色", TSHEXCOLOR(0xf03535)], @[@"橙色", TSHEXCOLOR(0xffa500)], @[@"黄色", TSHEXCOLOR(0xecdd34)], @[@"绿色", TSHEXCOLOR(0x30e45f)], @[@"其他", TSHEXCOLOR(0xffffff)], @[@"无", TSHEXCOLOR(0xffffff)]]
#define ColorArray @[@[@"青色", @"299af0"], @[@"蓝色", @"c29ff"], @[@"紫色", @"8b00ff"], @[@"白色", @"ffffff"], @[@"黑色", @"181818"], @[@"红色", @"f03535"], @[@"橙色", @"ffa500"], @[@"黄色", @"ecdd34"], @[@"粉色", @"ffc0cb"], @[@"绿色", @"30e45f"], @[@"其他", @"000000"], @[@"无", @"ffffff"]]

static NSString * const CurrentLoginUserType = @"CurrentLoginUserType";

typedef NS_ENUM(NSInteger, LoginUserType) { // 用户类型
    LoginUserTypeNormal,
    LoginUserTypeBCBC,
    LoginUserTypeCBO
};

// 支付相关
typedef NS_ENUM(NSInteger, PayResult) { // 支付结果
    PayResultFailed,
    PayResultSuccess
};

static NSString * const TSPaySuccessNotifName = @"TSPaySuccessNotifName";
static NSString * const TSDidBecomeActiveNotif = @"TSDidBecomeActiveNotif";

static NSString * const TSAppStoreBundleIdentifier = @"cn.xdf.popnew";
static NSString * const PushNotification = @"pushNotification";
static NSString * const RegisterWechatSDK = @"registerWechatSDK";
static NSString * const NetworkEnvironmentChange = @"NetworkEnvironmentChange";
static NSString * const PlayerDataDidChanged = @"PlayerDataDidChanged";
static NSString * const GoToTheNextStageGame = @"GoToTheNextStageGame";
static NSString * const GameOver = @"比赛结束";
#endif /* QYTSDefines_h */
