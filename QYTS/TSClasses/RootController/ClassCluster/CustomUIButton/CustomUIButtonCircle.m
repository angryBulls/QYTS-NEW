//
//  CustomUIButtonCircle.m
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIButtonCircle.h"

@implementation CustomUIButtonCircle
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CustomUIButtonCircle *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:W(19.0)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.masksToBounds = YES;
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.width*0.5;
}
@end
