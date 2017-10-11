//
//  DropDownButton.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "DropDownButton.h"

@implementation DropDownButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    DropDownButton *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitleColor:TSHEXCOLOR(0xbfd4ff) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = W(5);
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.rightWidth) {
        self.imageView.x = self.width - self.rightWidth - self.imageView.width;
    } else {
        self.imageView.x = self.width - W(33) - self.imageView.width;
    }
    self.titleLabel.x = 0;
    self.titleLabel.width = self.imageView.x;
}
@end
