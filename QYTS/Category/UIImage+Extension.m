//
//  UIImage+Extension.m
//  CRM
//
//  Created by 媛 祁 on 16/9/21.
//  Copyright © 2016年 QYQ-Hawk. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
