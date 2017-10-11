//
//  TSSegCustomButton.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSSegCustomButton.h"

@implementation TSSegCustomButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    TSSegCustomButton *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [button setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor:TSHEXCOLOR(0xff4769) forState:UIControlStateSelected];
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageViewX) {
        self.imageView.x = self.imageViewX;
    }
    
    CGFloat labelX = CGRectGetMaxX(self.imageView.frame) + W(9);
    self.titleLabel.frame = CGRectMake(labelX, 0, self.width - labelX, self.height);
}
@end
