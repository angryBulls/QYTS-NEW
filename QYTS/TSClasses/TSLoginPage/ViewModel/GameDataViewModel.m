//
//  GameDataViewModel.m
//  QYTS
//
//  Created by lxd on 2017/8/23.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "GameDataViewModel.h"
#import "MyGameOverModel.h"

@interface GameDataViewModel ()
@property (nonatomic, strong) NSMutableDictionary *paramasDict;
@end

@implementation GameDataViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict {
    if (self = [super init]) {
        if (paramasDict) {
            _paramasDict = paramasDict;
        }
    }
    return self;
}

- (void)getUserHistoryMatchList { // 已结束比赛
    [TSNetworkManger getUserHistoryMatchList:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            if ([responseObject[@"entity"] count]) {
                MyGameOverModel *gameOverModel = [MyGameOverModel mj_objectWithKeyValues:responseObject[@"entity"]];
                self.returnBlock(gameOverModel);
            } else {
                [self errorCodeWithReason:@"无更多数据"];
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

- (void)getMatchAndTeamInfoNormal {
    [TSNetworkManger getMatchAndTeamInfoNormal:self.paramasDict responseSuccess:^(id responseObject) {
        if ([responseObject[@"success"] isEqual:@1]) {
            if ([responseObject[@"entity"] count]) {
                MyGameOverModel *gameOverModel = [MyGameOverModel mj_objectWithKeyValues:responseObject[@"entity"]];
                self.returnBlock(gameOverModel);
            } else {
                [self errorCodeWithReason:@"无更多数据"];
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
