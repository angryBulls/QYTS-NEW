//
//  UIImageView+Extension.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)
- (void)animationWithDuration:(CGFloat)duration angle:(CGFloat)angle {
    CGAffineTransform transform = CGAffineTransformRotate(self.transform, angle);
    [UIView beginAnimations:@"rotate" context:nil ];
    [UIView setAnimationDuration:duration];
    [self setTransform:transform];
    [UIView commitAnimations];
}
@end
