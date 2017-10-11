//
//  LXDTextView.m
//  qiuyouquan
//
//  Created by MacBook on 16/10/29.
//  Copyright © 2016年 QYQ-Hawk. All rights reserved.
//

#import "LXDTextView.h"

@implementation LXDTextView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.returnKeyType = UIReturnKeyDone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (void)textDidChange {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.hasText) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = (self.placeholderColor ? self.placeholderColor : [UIColor grayColor]);
    CGRect placeholderRect = CGRectMake(5, 8, rect.size.width - 10, rect.size.height - 18);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
