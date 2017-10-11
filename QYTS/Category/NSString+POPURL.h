//
//  NSString+POPURL.h
//  POP
//
//  Created by lxd on 2017/3/31.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (POPURL)
/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
- (NSString *)URLDecodedString;
@end
