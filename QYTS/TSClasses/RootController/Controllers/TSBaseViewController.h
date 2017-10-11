//
//  QZBaseViewController.h
//  QiZhiMath
//
//  Created by lxd on 2017/5/5.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSBaseViewController : UIViewController
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)setCustomNavBarTitle:(NSString *)title backBtnHidden:(BOOL)backBtnHidden backBtnIconName:(NSString *)iconName navigationBarColor:(UIColor *)navigationBarColor titleColor:(UIColor *)titleColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (void)createRightBarButtonWithImageName:(NSString *)imageName;
- (void)showNavgationBarBottomLine;
- (UIButton *)createButtonWithTile:(NSString *)submitTitle frame:(CGRect)frame;
@end
