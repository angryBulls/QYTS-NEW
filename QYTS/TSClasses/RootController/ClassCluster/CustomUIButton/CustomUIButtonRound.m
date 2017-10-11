//
//  CustomUIButtonRound.m
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIButtonRound.h"
#import "UIImage+Extension.h"

@implementation CustomUIButtonRound
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CustomUIButtonRound *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:W(13.0)];
    [button setTitleColor:TSHEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = W(7.5);
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xffffff) size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xFF4769) size:CGSizeMake(5, 5)] forState:UIControlStateHighlighted];
    
    return button;
}
@end
