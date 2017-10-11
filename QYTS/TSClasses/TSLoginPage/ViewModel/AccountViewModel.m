//
//  AccountViewModel.m
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AccountViewModel.h"

@interface AccountViewModel ()
@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@end

@implementation AccountViewModel
- (instancetype)initWithUserInfoDict:(NSMutableDictionary *)userInfoDict {
    if (self = [super init]) {
        _userInfoDict = userInfoDict;
    }
    return self;
}

- (void)getCurrentVersion {
    [TSNetworkManger getCurrentVersion:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            self.returnBlock(responseObject);
        } else {
            NSString *reason = responseObject[@"message"];
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)loginBCBC {
    [TSNetworkManger startLoginBCBC:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
            userInfo.loginUserType = [NSString stringWithFormat:@"%ld", LoginUserTypeBCBC];
            userInfo.loginName = responseObject[@"entity"][@"loginName"];
            userInfo.nickname = responseObject[@"entity"][@"nickname"];
            userInfo.status = responseObject[@"entity"][@"status"];
            userInfo.token = responseObject[@"entity"][@"token"];
            userInfo.userId = responseObject[@"entity"][@"userId"];
            userInfo.sn = responseObject[@"sn"];
            
            userInfo.password = self.userInfoDict[@"password"];
            userInfo.rememberPD = self.userInfoDict[@"rememberPD"];
            
//            DDLog(@"userInfo is:%@", [userInfo dictWithModel:userInfo]);
            [TSToolsMethod setUserInfoBCBC:[userInfo dictWithModel:userInfo]];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(LoginUserTypeBCBC) forKey:CurrentLoginUserType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.returnBlock(responseObject);
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)loginCBO {
    [TSNetworkManger startLoginCBO:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
            userInfo.loginUserType = [NSString stringWithFormat:@"%ld", LoginUserTypeCBO];
            userInfo.loginName = responseObject[@"entity"][@"loginName"];
            userInfo.nickname = responseObject[@"entity"][@"nickname"];
            userInfo.status = responseObject[@"entity"][@"status"];
            userInfo.token = responseObject[@"entity"][@"token"];
            userInfo.userId = responseObject[@"entity"][@"userId"];
            userInfo.sn = responseObject[@"sn"];
            
            userInfo.password = self.userInfoDict[@"password"];
            userInfo.rememberPD = self.userInfoDict[@"rememberPD"];
            
            //            DDLog(@"userInfo is:%@", [userInfo dictWithModel:userInfo]);
            [TSToolsMethod setUserInfoCBO:[userInfo dictWithModel:userInfo]];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(LoginUserTypeCBO) forKey:CurrentLoginUserType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.returnBlock(responseObject);
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)loginNormal {
    [TSNetworkManger startLoginNormal:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
//            DDLog(@"responseObject is:%@", responseObject);
            TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
            userInfo.loginUserType = [NSString stringWithFormat:@"%ld", LoginUserTypeNormal];
            userInfo.loginName = responseObject[@"entity"][@"username"];
            userInfo.phone = responseObject[@"entity"][@"phone"];
            userInfo.nickname = responseObject[@"entity"][@"name"];
            userInfo.status = responseObject[@"entity"][@"state"];
            userInfo.token = responseObject[@"entity"][@"token"];
            userInfo.userId = responseObject[@"entity"][@"id"];
            userInfo.sn = responseObject[@"sn"];
            
            userInfo.password = self.userInfoDict[@"password"];
            userInfo.rememberPD = self.userInfoDict[@"rememberPD"];
            
//            DDLog(@"userInfo is:%@", [userInfo dictWithModel:userInfo]);
            [TSToolsMethod setUserInfoNormal:[userInfo dictWithModel:userInfo]];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(LoginUserTypeNormal) forKey:CurrentLoginUserType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.returnBlock(responseObject);
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)loginNormalByVCode {
    [TSNetworkManger startLoginNormalByVCode:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            //            DDLog(@"responseObject is:%@", responseObject);
            TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
            userInfo.loginUserType = [NSString stringWithFormat:@"%ld", LoginUserTypeNormal];
            userInfo.loginName = responseObject[@"entity"][@"username"];
            userInfo.phone = responseObject[@"entity"][@"phone"];
            userInfo.nickname = responseObject[@"entity"][@"name"];
            userInfo.status = responseObject[@"entity"][@"state"];
            userInfo.token = responseObject[@"entity"][@"token"];
            userInfo.userId = responseObject[@"entity"][@"id"];
            userInfo.sn = responseObject[@"sn"];
            
            //            DDLog(@"userInfo is:%@", [userInfo dictWithModel:userInfo]);
            [TSToolsMethod setUserInfoNormal:[userInfo dictWithModel:userInfo]];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(LoginUserTypeNormal) forKey:CurrentLoginUserType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.returnBlock(responseObject);
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)loginOut {
    [TSNetworkManger loginOut:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            [TSToolsMethod loginOut];
            self.returnBlock(responseObject);
            DDLog(@"loginOut success!!!!!!");
        } else {
            NSString *reason = responseObject[@"message"];
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)fetchAuthCode {
    [TSNetworkManger fetchAuthCode:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            if ([responseObject[@"entity"][@"code"] length]) {
                [SVProgressHUD showInfoWithStatus:@"验证码已发送至手机"];
                self.returnBlock(responseObject);
            }
        } else if ([responseObject[@"success"] isEqual:@0]) {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)registerUser {
    [TSNetworkManger registerUser:self.userInfoDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
            userInfo.loginUserType = [NSString stringWithFormat:@"%ld", LoginUserTypeNormal];
            userInfo.loginName = responseObject[@"entity"][@"username"];
            userInfo.phone = responseObject[@"entity"][@"phone"];
            userInfo.nickname = responseObject[@"entity"][@"name"];
            userInfo.status = responseObject[@"entity"][@"state"];
            userInfo.token = responseObject[@"entity"][@"token"];
            userInfo.userId = responseObject[@"entity"][@"id"];
            userInfo.sn = responseObject[@"sn"];
            [TSToolsMethod setUserInfoNormal:[userInfo dictWithModel:userInfo]];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(LoginUserTypeNormal) forKey:CurrentLoginUserType];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.returnBlock(responseObject);
        } else {
            NSString *reason = responseObject[@"message"];
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

#pragma 对ErrorCode进行处理
- (void)errorCodeWithReason:(NSString *)reason {
    self.errorBlock(reason);
}

#pragma 对网路异常进行处理
- (void)netFailure {
    self.failureBlock ? self.failureBlock() : nil;
}
@end
