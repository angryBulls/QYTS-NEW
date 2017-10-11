//
//  UIBarButtonItem+Extension.h
//  CRM
//
//  Created by lxd on 16/9/20.
//  Copyright © 2016年 QYQ-Hawk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (NSArray *)popBarButtonItemsWithTarget:(id)target action:(SEL)action image:(NSString *)image;
@end
