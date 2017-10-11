//
//  PersonalCenterViewController.m
//  QYTS
//
//  Created by lxd on 2017/8/29.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalCenterViewController.h"

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"我的" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self showNavgationBarBottomLine];
}
@end
