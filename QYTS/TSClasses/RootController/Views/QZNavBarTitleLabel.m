//
//  QZNavBarTitleLabel.m
//  QiZhiMath
//
//  Created by lxd on 2017/5/5.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import "QZNavBarTitleLabel.h"

@interface QZNavBarTitleLabel ()

@end

@implementation QZNavBarTitleLabel
- (instancetype)initWithFrame:(CGRect)frame txtColor:(UIColor *)txtColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    if (self = [super initWithFrame:frame]) {
        self.textColor = txtColor;
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        
        [self p_SetupProperties];
        
    }
    return self;
}

- (void)p_SetupProperties {
    self.textColor = self.textColor;
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:W(15.0)];
    self.textAlignment = NSTextAlignmentCenter;
}

- (void)drawTextInRect:(CGRect)rect {
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.borderWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    [self layoutIfNeeded];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    
    [self layoutIfNeeded];
}
@end
