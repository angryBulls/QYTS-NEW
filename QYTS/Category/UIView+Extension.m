//
//  UIView+Extension.m
//  QYTS
//
//  Created by lxd on 2017/7/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)setRectCornerWithStyle:(UIRectCorner)rectCornerStyle cornerRadii:(CGFloat)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerStyle cornerRadii:CGSizeMake(cornerRadii,cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
