//
//  CustomUIButtonArrow.m
//  QYTS
//
//  Created by lxd on 2017/9/26.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIButtonArrow.h"

@implementation CustomUIButtonArrow
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CustomUIButtonArrow *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.selected) {
        self.imageView.hidden = YES;
    } else {
        self.imageView.hidden = NO;
    }
}
@end
