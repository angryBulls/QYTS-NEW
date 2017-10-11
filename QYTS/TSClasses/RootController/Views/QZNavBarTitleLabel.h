//
//  QZNavBarTitleLabel.h
//  QiZhiMath
//
//  Created by lxd on 2017/5/5.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZNavBarTitleLabel : UILabel
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

- (instancetype)initWithFrame:(CGRect)frame txtColor:(UIColor *)txtColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
@end
