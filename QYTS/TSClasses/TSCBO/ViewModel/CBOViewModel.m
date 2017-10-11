//
//  CBOViewModel.m
//  QYTS
//
//  Created by lxd on 2017/9/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CBOViewModel.h"
#import "MyGameOverListModel.h"

@interface CBOViewModel ()
@property (nonatomic, strong) NSMutableDictionary *paramasDict;
@end

@implementation CBOViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict {
    if (self = [super init]) {
        if (paramasDict) {
            _paramasDict = paramasDict;
        }
    }
    return self;
}

- (void)cboFindMatchAndTeamInfo {
    [TSNetworkManger cboFindMatchAndTeamInfo:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            DDLog(@"cboFindMatchAndTeamInfo is:%@", responseObject);
            if (responseObject[@"entity"][@"matchList"]) {
                NSArray *modelArray = [MyGameOverListModel mj_objectArrayWithKeyValuesArray:responseObject[@"entity"][@"matchList"]];
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

#pragma 对ErrorCode进行处理
- (void)errorCodeWithReason:(NSString *)reason {
    self.errorBlock(reason);
}

#pragma 对网路异常进行处理
- (void)netFailure {
    self.failureBlock ? self.failureBlock() : nil;
}
@end
