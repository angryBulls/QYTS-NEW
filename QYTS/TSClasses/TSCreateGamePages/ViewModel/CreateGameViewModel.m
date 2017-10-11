//
//  CreateGameViewModel.m
//  QYTS
//
//  Created by lxd on 2017/8/4.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreateGameViewModel.h"

@interface CreateGameViewModel ()
@property (nonatomic, strong) NSMutableDictionary *paramasDict;
@end

@implementation CreateGameViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict {
    if (self = [super init]) {
        if (paramasDict) {
            _paramasDict = paramasDict;
        }
    }
    return self;
}

- (void)saveAmateurMatchInfo {
    [TSNetworkManger saveAmateurMatchInfo:self.paramasDict responseSuccess:^(id responseObject) {
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
