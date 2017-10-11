//
//  PlayerCheckViewModel.m
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PlayerCheckViewModel.h"

@interface PlayerCheckViewModel ()
@property (nonatomic, strong) NSMutableDictionary *pramasDict;
@end

@implementation PlayerCheckViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)pramasDict {
    if (self = [super init]) {
        if (pramasDict) {
            _pramasDict = pramasDict;
        }
    }
    return self;
}

- (void)getPlaysDataByTeamBCBC {
    [TSNetworkManger getPlaysDataByTeamBCBC:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)getPlaysDataByTeamNormal {
    [TSNetworkManger getPlaysDataByTeamNormal:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)getPlaysDataByTeamCBO {
    [TSNetworkManger getPlaysDataByTeamCBO:self.pramasDict responseSuccess:^(id responseObject) {
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
