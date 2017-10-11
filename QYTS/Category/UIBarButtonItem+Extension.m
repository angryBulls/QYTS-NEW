//
//  UIBarButtonItem+Extension.m
//  CRM
//
//  Created by lxd on 16/9/20.
//  Copyright © 2016年 QYQ-Hawk. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (NSArray *)popBarButtonItemsWithTarget:(id)target action:(SEL)action image:(NSString *)image {
    UIBarButtonItem *backButton = [self p_barButtonItemWithTarget:target action:action image:image];
    UIBarButtonItem *spacerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacerButton.width = -15;
    
    return @[spacerButton, backButton];
}

+ (instancetype)p_barButtonItemWithTarget:(id)target action:(SEL)action image:(NSString *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 33, 53);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
