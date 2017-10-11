//
//  LoginPageViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBaseViewController.h"

//typedef NS_ENUM(NSUInteger, LoginType) {
//    LoginTypeBCBC,
//    LoginTypeNormal
//};

@interface LoginPageViewController : LoginBaseViewController
@property (nonatomic, assign) LoginUserType loginType;
@end
