//
//  AdvertisementViewModel.m
//  QYTS
//
//  Created by lxd on 2017/9/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AdvertisementViewModel.h"

@interface AdvertisementViewModel ()
@property (nonatomic, strong) NSMutableDictionary *paramasDict;
@end

@implementation AdvertisementViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict {
    if (self = [super init]) {
        if (paramasDict) {
            _paramasDict = paramasDict;
        }
    }
    return self;
}

- (void)getGuide {
    [TSNetworkManger getGuide:self.paramasDict responseSuccess:^(id responseObject) {
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
