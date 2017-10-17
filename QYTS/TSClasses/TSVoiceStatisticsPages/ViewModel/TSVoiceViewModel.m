//
//  TSVoiceViewModel.m
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSVoiceViewModel.h"
#import "TSDBManager.h"
#import "TSPlayerModel.h"
#import "TSManagerPlayerModel.h"

@interface TSVoiceViewModel ()
@property (nonatomic, strong) NSMutableDictionary *pramasDict;
@property (nonatomic, strong) NSDictionary *gameCheckDict;
@end

@implementation TSVoiceViewModel
- (instancetype)initWithPramasDict:(NSMutableDictionary *)pramasDict {
    if (self = [super init]) {
        if (pramasDict) {
            _pramasDict = pramasDict;
        }
    }
    return self;
}

- (void)sendCurrentStageData {
    [self p_createSendCurrentStageData];
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeBCBC) {
        [self p_sendCurrentStageDataBCBC];
    } else if (currentUserType == LoginUserTypeNormal) {
        [self p_sendCurrentStageDataNormal];
    } else if (currentUserType == LoginUserTypeCBO) {
        [self p_sendCurrentStageDataCBO];
    }
}

- (void)p_sendCurrentStageDataBCBC {
    [TSNetworkManger sendCurrentStageDataBCBC:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)p_sendCurrentStageDataNormal {
    [TSNetworkManger sendCurrentStageDataNormal:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)p_sendCurrentStageDataCBO {
    [TSNetworkManger sendCurrentStageDataCBO:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)abstentionNormal {
    [TSNetworkManger abstentionNormal:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)abstentionBCBC {
    [TSNetworkManger abstentionBCBC:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)abstentionCBO {
    [TSNetworkManger abstentionCBO:self.pramasDict responseSuccess:^(id responseObject) {
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

- (void)p_createSendCurrentStageData { // 获取当节需要被提交的数据
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    
    // 获取需要提交的节次
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if (_oldStage.length) {
        [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageName, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([_oldStage isEqualToString:stageName]) {
                if (0 == idx) {
                    self.pramasDict[@"type"] = @"o";
                } else if (1 == idx) {
                    self.pramasDict[@"type"] = @"s";
                } else if (2 == idx) {
                    self.pramasDict[@"type"] = @"t";
                } else if (3 == idx) {
                    self.pramasDict[@"type"] = @"f";
                } else if (4 == idx) {
                    self.pramasDict[@"type"] = @"oto";
                } else if (5 == idx) {
                    self.pramasDict[@"type"] = @"ots";
                } else if (6 == idx) {
                    self.pramasDict[@"type"] = @"ott";
                }
            }
        }];
        
    }
    else{
    [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([gameTableDict[CurrentStage] isEqualToString:stageName]) {
            if (0 == idx) {
                self.pramasDict[@"type"] = @"o";
            } else if (1 == idx) {
                self.pramasDict[@"type"] = @"s";
            } else if (2 == idx) {
                self.pramasDict[@"type"] = @"t";
            } else if (3 == idx) {
                self.pramasDict[@"type"] = @"f";
            } else if (4 == idx) {
                self.pramasDict[@"type"] = @"oto";
            } else if (5 == idx) {
                self.pramasDict[@"type"] = @"ots";
            } else if (6 == idx) {
                self.pramasDict[@"type"] = @"ott";
            }
        }
    }];
    }
    // 获取“比赛数据表”中的“matchId”
    if ([gameTableDict[@"matchInfoId"] length]) {
        self.pramasDict[@"matchId"] = gameTableDict[@"matchInfoId"];
    }
    
    // 比赛时间
    if ([gameTableDict[@"matchDate"] length]) {
        self.pramasDict[@"matchDate"] = gameTableDict[@"matchDate"];
    } else {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        self.pramasDict[@"matchDate"] = [fmt stringFromDate:[NSDate date]];
    }
    
    // 取出检录表中赛前检录的数据
    NSDictionary *gameCheckDict = [tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
    self.gameCheckDict = gameCheckDict;
    self.pramasDict[@"homeColor"] = gameCheckDict[@"teamColorH"];
    self.pramasDict[@"awayColor"] = gameCheckDict[@"teamColorG"];
    
    // 取出主客队所有球员检录信息
    NSArray *playerCheckArrayH = [tSDBManager getObjectById:TeamCheckID_H fromTable:TSCheckTable];
    NSArray *playerCheckArrayG = [tSDBManager getObjectById:TeamCheckID_G fromTable:TSCheckTable];
    
    NSMutableArray *startPlayerIdArray = [NSMutableArray array]; // 所有首发球员的playerId
    [playerCheckArrayH enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subDict[@"isStartPlayer"] isEqualToString:@"是"]) {
            [startPlayerIdArray addObject:subDict[@"id"]];
        }
    }];
    
    [playerCheckArrayG enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subDict[@"isStartPlayer"] isEqualToString:@"是"]) {
            [startPlayerIdArray addObject:subDict[@"id"]];
        }
    }];
    self.pramasDict[@"startPlayerId"] = [startPlayerIdArray componentsJoinedByString:@","];
    
    NSMutableDictionary *matchInfoDict = [NSMutableDictionary dictionary];
    matchInfoDict[@"matchType1"] = @"gameLevel";
    matchInfoDict[@"matchType2"] = @"gameArea";
    matchInfoDict[@"matchType3"] = @"gameProvince";
    if (gameCheckDict[@"gameLevel"]) {
        matchInfoDict[@"matchType1"] = gameCheckDict[@"gameLevel"];
    }
    if (gameCheckDict[@"gameArea"]) {
        matchInfoDict[@"matchType2"] = gameCheckDict[@"gameArea"];
    }
    if (gameCheckDict[@"gameProvince"]) {
        matchInfoDict[@"matchType3"] = gameCheckDict[@"gameProvince"];
    }
    matchInfoDict[@"mainReferee"] = gameCheckDict[@"mainReferee"];
    matchInfoDict[@"firstReferee"] = gameCheckDict[@"firstReferee"];
    matchInfoDict[@"secondReferee"] = gameCheckDict[@"secondReferee"];
    matchInfoDict[@"td"] = gameCheckDict[@"td"];
    matchInfoDict[@"recorder"] = gameCheckDict[@"recorder"];
    
    // 暂时写死的数据
//    matchInfoDict[@"ts1"] = @"技术统计1";
//    matchInfoDict[@"ts2"] = @"技术统计2";
    matchInfoDict[@"season"] = [self.pramasDict[@"matchDate"] substringToIndex:4];
    
    self.pramasDict[@"matchInfo"] = matchInfoDict;
    
    // 首先获取所有主队球员的数据
    NSArray *allHostPlayerModelDataArray = [self p_getAllPlayerDataWith:tSDBManager playerCheckArray:playerCheckArrayH];
    NSArray *homePlayerMatchStArray = [self p_getTeamUploadDataWithPlayerModelDataArray:allHostPlayerModelDataArray teamId:gameCheckDict[@"homeTeamId"]];
    self.pramasDict[@"homePlayerMatchSt"] = homePlayerMatchStArray;
    
    // 首先获取所有客队球员的数据
    NSArray *allGuestPlayerModelDataArray = [self p_getAllPlayerDataWith:tSDBManager playerCheckArray:playerCheckArrayG];
    NSArray *guestPlayerMatchStArray = [self p_getTeamUploadDataWithPlayerModelDataArray:allGuestPlayerModelDataArray teamId:gameCheckDict[@"awayTeamId"]];
    self.pramasDict[@"awayPlayerMatchSt"] = guestPlayerMatchStArray;
    
//    DDLog(@"up load service pramasDict is:%@", self.pramasDict);
}

- (NSArray *)p_getTeamUploadDataWithPlayerModelDataArray:(NSArray *)playerModelDataArray teamId:(NSString *)teamId {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSString *TeamCheckID = TeamCheckID_H;
    NSArray *playerCheckArray = @[];
    if ([teamId isEqualToString:self.gameCheckDict[@"homeTeamId"]]) { // 主队数据
        playerCheckArray = [tSDBManager getObjectById:TeamCheckID fromTable:TSCheckTable];
    } else { // 客队数据
        TeamCheckID = TeamCheckID_G;
        playerCheckArray = [tSDBManager getObjectById:TeamCheckID fromTable:TSCheckTable];
    }
    
    NSMutableArray *playerMatchStArray = [NSMutableArray array];
    [playerModelDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *playerMatchStDict = [NSMutableDictionary dictionary];
        playerMatchStDict[@"playerId"] = tPlayerModel.playerId;
        playerMatchStDict[@"teamId"] = teamId;
        playerMatchStDict[@"gameNum"] = @(tPlayerModel.playerNumber.intValue);
        // 设置球员的上场时间
        [playerCheckArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subDict[@"id"] isEqualToString:tPlayerModel.playerId]) {
                NSString *secondTimes = subDict[@"playingTimes"];
                int minutes = secondTimes.intValue / 60;
                playerMatchStDict[@"gameTime"] = [NSString stringWithFormat:@"%d", minutes];
                *stop = YES;
            }
        }];
        tPlayerModel.OnePointsHit ? (playerMatchStDict[@"oneFenHit"] = @(tPlayerModel.OnePointsHit.intValue)) : (playerMatchStDict[@"oneFenHit"] = @0);
        tPlayerModel.behaviorNumb31 ? (playerMatchStDict[@"oneFenTry"] = @(tPlayerModel.behaviorNumb31.intValue)) : (playerMatchStDict[@"oneFenTry"] = @0);
        tPlayerModel.TwoPointsHit ? (playerMatchStDict[@"twoPointHit"] = @(tPlayerModel.TwoPointsHit.intValue)) : (playerMatchStDict[@"twoPointHit"] = @0);
        tPlayerModel.behaviorNumb2 ? (playerMatchStDict[@"twoPointTry"] = @(tPlayerModel.behaviorNumb2.intValue)) : (playerMatchStDict[@"twoPointTry"] = @0);
        tPlayerModel.ThreePointsHit ? (playerMatchStDict[@"threePointHit"] = @(tPlayerModel.ThreePointsHit.intValue)) : (playerMatchStDict[@"threePointHit"] = @0);
        tPlayerModel.behaviorNumb3 ? (playerMatchStDict[@"threePointTry"] = @(tPlayerModel.behaviorNumb3.intValue)) : (playerMatchStDict[@"threePointTry"] = @0);
        tPlayerModel.FreeThrowHit ? (playerMatchStDict[@"onePointHit"] = @(tPlayerModel.FreeThrowHit.intValue)) : (playerMatchStDict[@"onePointHit"] = @0);
        tPlayerModel.behaviorNumb1 ? (playerMatchStDict[@"onePointTry"] = @(tPlayerModel.behaviorNumb1.intValue)) : (playerMatchStDict[@"onePointTry"] = @0);
//        playerMatchStDict[@"fastBreak"] = @0;
        tPlayerModel.behaviorNumb4 ? (playerMatchStDict[@"offensiveRebound"] = @(tPlayerModel.behaviorNumb4.intValue)) : (playerMatchStDict[@"offensiveRebound"] = @0);
        tPlayerModel.behaviorNumb5 ? (playerMatchStDict[@"defensiveRebound"] = @(tPlayerModel.behaviorNumb5.intValue)) : (playerMatchStDict[@"defensiveRebound"] = @0);
        tPlayerModel.behaviorNumb9 ? (playerMatchStDict[@"assists"] = @(tPlayerModel.behaviorNumb9.intValue)) : (playerMatchStDict[@"assists"] = @0);
//        playerMatchStDict[@"dunk"] = @0;
        tPlayerModel.behaviorNumb7 ? (playerMatchStDict[@"fault"] = @(tPlayerModel.behaviorNumb7.intValue)) : (playerMatchStDict[@"fault"] = @0);
        tPlayerModel.behaviorNumb6 ? (playerMatchStDict[@"steal"] = @(tPlayerModel.behaviorNumb6.intValue)) : (playerMatchStDict[@"steal"] = @0);
        tPlayerModel.behaviorNumb10 ? (playerMatchStDict[@"foul"] = @(tPlayerModel.behaviorNumb10.intValue)) : (playerMatchStDict[@"foul"] = @0);
        tPlayerModel.behaviorNumb8 ? (playerMatchStDict[@"block"] = @(tPlayerModel.behaviorNumb8.intValue)) : (playerMatchStDict[@"block"] = @0);
//        playerMatchStDict[@"violated"] = @"0";
        
        [playerMatchStArray addObject:playerMatchStDict];
    }];
    
    return playerMatchStArray;
}

- (NSArray *)p_getAllPlayerDataWith:(TSDBManager *)tSDBManager playerCheckArray:(NSArray *)playerCheckArray {
    NSArray *playerModelArray = [TSPlayerModel mj_objectArrayWithKeyValuesArray:playerCheckArray];
    
    NSMutableArray *playerModelDataArray = [NSMutableArray array];
    [playerModelArray enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *playerDataDict = [tSDBManager getObjectById:playerModel.ID fromTable:PlayerTable];
        NSString *stageCount = [tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
        
        NSDictionary *stagePlayerDataDict = playerDataDict[stageCount];
        if (!stagePlayerDataDict) {
            stagePlayerDataDict = @{};
        }
        TSManagerPlayerModel *tPlayerModel = [TSManagerPlayerModel mj_objectWithKeyValues:stagePlayerDataDict];
        tPlayerModel.playerId = playerModel.ID;
        tPlayerModel.playerName = playerModel.name;
        tPlayerModel.playerNumber = playerModel.gameNum;
        tPlayerModel.photo = playerModel.photo;
        tPlayerModel.changeStatus = NO;
        
        [playerModelDataArray addObject:tPlayerModel];
    }];
    
    return playerModelDataArray;
}
@end
