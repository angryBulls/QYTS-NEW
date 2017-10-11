//
//  AppDelegate.h
//  QYTS
//
//  Created by lxd on 2017/7/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)switchWindowView;
- (void)setGuidPageBeRootView;
- (void)setVoicePageBeRootView;
@end

