//
//  NSString+Valid.h
//  QZ
//
//  Created by lxd on 2017/2/17.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSString *)disable_emoji:(NSString *)text;
@end
