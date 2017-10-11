//
//  TSUserInfoModelBCBC.h
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUserInfoModelBCBC : NSObject
@property (nonatomic, copy) NSString *loginUserType;

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *rememberPD;// 1:记住密码

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictWithModel:(TSUserInfoModelBCBC *)model;
@end
