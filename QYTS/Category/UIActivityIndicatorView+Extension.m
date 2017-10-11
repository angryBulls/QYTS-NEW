//
//  UIActivityIndicatorView+Extension.m
//  QiZhiMath
//
//  Created by lxd on 2017/5/15.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import "UIActivityIndicatorView+Extension.h"

@implementation UIActivityIndicatorView (Extension)
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.center = window.center;
    [window addSubview:self];
    [self startAnimating];
}

- (void)showWithView:(UIView *)view {
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.center = CGPointMake(view.width*0.5, view.height*0.5);
    [self startAnimating];
    [view addSubview:self];
}

- (void)dismiss {
    [self stopAnimating];
}
@end
