//
//  PersonalViewModel.m
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalViewModel.h"
#import "PersonalInfoModel.h"
#import "ShareMatchInfoModel.h"
#import "CreatedTeamInfoModel.h"

@interface PersonalViewModel ()
@property (nonatomic, strong) NSMutableDictionary *paramasDict;
@end

@implementation PersonalViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict {
    if (self = [super init]) {
        if (paramasDict) {
            _paramasDict = paramasDict;
        }
    }
    return self;
}

- (void)getSsoUserDetail {
    [TSNetworkManger getSsoUserDetail:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            if ([responseObject[@"entity"][@"ssoUserDetail"] count]) {
                PersonalInfoModel *personalInfoModel = [PersonalInfoModel mj_objectWithKeyValues:responseObject[@"entity"][@"ssoUserDetail"]];
                self.returnBlock(personalInfoModel);
            } else {
                [self errorCodeWithReason:@"请求失败"];
            }
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

- (void)getUserMatchCount {
    [TSNetworkManger getUserMatchCount:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

- (void)getTeamInfoList {
    [TSNetworkManger getTeamInfoList:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            if (responseObject[@"entity"][@"teamInfoList"]) {
                NSArray *modelArray = [CreatedTeamInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"entity"][@"teamInfoList"]];
                self.returnBlock(modelArray);
            }
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

- (void)getUserHistoryMatchDetail {
    [TSNetworkManger getUserHistoryMatchDetail:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            DDLog(@"getUserHistoryMatchDetail responseObject is:%@", responseObject);
            if (responseObject[@"entity"]) {
                ShareMatchInfoModel *infoModel = [ShareMatchInfoModel mj_objectWithKeyValues:responseObject[@"entity"]];
                self.returnBlock(infoModel);
            }
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

- (void)updateSsoUser { // 更新个人信息
    [TSNetworkManger updateSsoUser:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

- (void)changePhone {
    [TSNetworkManger changePhone:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

- (void)changePassword {
    [TSNetworkManger changePassword:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

- (void)findPassword {
    [TSNetworkManger findPassword:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

- (void)matchBlankOut {
    [TSNetworkManger matchBlankOut:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

- (void)shareMatchInfo {
    [TSNetworkManger shareMatchInfo:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            DDLog(@"shareMatchInfo responseObject is:%@", responseObject);
            if (responseObject[@"entity"]) {
                ShareMatchInfoModel *infoModel = [ShareMatchInfoModel mj_objectWithKeyValues:responseObject[@"entity"]];
                self.returnBlock(infoModel);
            }
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

- (void)shareLogSave {
    [TSNetworkManger shareLogSave:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
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

#pragma 对ErrorCode进行处理
- (void)errorCodeWithReason:(NSString *)reason {
    self.errorBlock(reason);
}

#pragma 对网路异常进行处理
- (void)netFailure {
    self.failureBlock ? self.failureBlock() : nil;
}
@end
