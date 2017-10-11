//
//  CustomShareButton.m
//  QYTS
//
//  Created by lxd on 2017/8/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomShareButton.h"

@implementation CustomShareButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CustomShareButton *button = [super buttonWithType:buttonType];
    [button setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.width, self.width);
    CGFloat titleLabelH = self.height - self.imageView.height - H(8);
    self.titleLabel.frame = CGRectMake(0, self.height - titleLabelH, self.width, titleLabelH);
}
@end
