//
//  TSUserInfoModelBCBC.m
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSUserInfoModelBCBC.h"

@implementation TSUserInfoModelBCBC
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (![dictionary[@"token"] isKindOfClass:[NSNull class]]) {
            _loginUserType = dictionary[@"loginUserType"];
            _loginName = dictionary[@"loginName"];
            _phone = dictionary[@"phone"];
            _nickname = dictionary[@"nickname"];
            _password = dictionary[@"password"];
            _status = dictionary[@"status"];
            _token = dictionary[@"token"];
            _userId = dictionary[@"userId"];
            _sn = dictionary[@"sn"];
            _rememberPD = dictionary[@"rememberPD"];
        }
    }
    return self;
}

- (NSDictionary *)dictWithModel:(TSUserInfoModelBCBC *)model {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    
    newDict[@"loginUserType"] = model.loginUserType;
    newDict[@"loginName"] = model.loginName;
    newDict[@"phone"] = model.phone;
    newDict[@"password"] = model.password;
    newDict[@"nickname"] = model.nickname;
    newDict[@"status"] = model.status;
    newDict[@"token"] = model.token;
    newDict[@"userId"] = model.userId;
    newDict[@"sn"] = model.sn;
    newDict[@"rememberPD"] = model.rememberPD;
    
    return newDict;
}
@end
