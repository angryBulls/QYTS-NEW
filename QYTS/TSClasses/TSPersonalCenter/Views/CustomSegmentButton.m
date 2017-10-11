//
//  CustomSegmentButton.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomSegmentButton.h"

@implementation CustomSegmentButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CustomSegmentButton *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [button setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor:TSHEXCOLOR(0xff4769) forState:UIControlStateSelected];
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, 0, self.width, self.height - H(20));
}
@end
