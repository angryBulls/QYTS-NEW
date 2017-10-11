//
//  NSString+Extension.h
//  QiZhiMath
//
//  Created by lxd on 2017/5/11.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (NSString *)VerticalString;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;
@end
