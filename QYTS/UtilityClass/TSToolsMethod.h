//
//  TSToolsMethod.h
//  TS
//
//  Created by lxd on 2017/2/27.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ExerciseAudio) {
    ExerciseAudioGoodjob,
    ExerciseAudioWrong,
    ExerciseAudioWelldone
};

typedef NS_ENUM(NSInteger, CountDownType) {
    CountDownTypeSecond,
    CountDownTypeMinutes
};

typedef void (^CountdownReturnBlock)(NSString *timeString);

@class TSUserInfoModel, TSUserInfoModelBCBC, TSUserInfoModelCBO, TSUserInfoModelNormal;

@interface TSToolsMethod : NSObject
+ (void)setUserInfoBCBC:(NSDictionary *)newUserInfoDict;
+ (void)setUserInfoCBO:(NSDictionary *)newUserInfoDict;
+ (void)setUserInfoNormal:(NSDictionary *)newUserInfoDict;
+ (TSUserInfoModelBCBC *)fetchUserInfoModelBCBC;
+ (TSUserInfoModelCBO *)fetchUserInfoModelCBO;
+ (TSUserInfoModelNormal *)fetchUserInfoModelNormal;

+ (void)loginOut;
+ (void)p_PrivateUploadLogVideoLastPosition:(NSDictionary *)videoInfoDict;
+ (UIActivityIndicatorView *)showActivityIndicatorWithView:(UIView *)view;
// 计算UITextView的高度
+ (float)heightForString:(NSString *)value andWidth:(float)width attrStr:(NSAttributedString *)attrStr;


- (void)p_PrivatePlayAudioWithURL:(NSString *)audioUrl audioType:(ExerciseAudio)audioType;

+ (NSString *)creatUUID;
+ (void)restoreRootViewController:(UIViewController *)rootViewController;

- (void)startGCDTimerWithDuration:(CGFloat)duration countdownReturnBlock:(CountdownReturnBlock)countdownReturnBlock;
- (void)startGCDTimerWithDuration:(CGFloat)duration timeupReturnBlock:(CountdownReturnBlock)timeupReturnBlock;
- (void)pauseGCDTimer;
- (void)resumeGCDTimer;
- (void)stopGCDTimer;

+ (AVAuthorizationStatus)checkMicrophoneAuthorizationStatus;
+ (BOOL)createDirec:(NSString *)direcName;
+ (NSString *)readFile:(NSString *)filePath;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (BOOL)checkVoiceDBExists;
+ (UIColor *)colorWithHexString:(NSString *)colorString;

+ (void)zoneNavigationBarWithColor:(UIColor *)color bar:(UINavigationBar *)bar;
@end
