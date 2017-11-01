//
//  TSCalculationTool.m
//  QYTS
//
//  Created by lxd on 2017/7/25.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSCalculationTool.h"
#import "TSManagerPlayerModel.h"
#import "TSGameModel.h"
#import "TSPlayerModel.h"

@interface TSCalculationTool ()
@property (nonatomic, strong) TSDBManager *tSDBManager;
@end

@implementation TSCalculationTool
#pragma mark - lazy method ************************************************************************************
- (TSDBManager *)tSDBManager {
    if (!_tSDBManager) {
        _tSDBManager = [[TSDBManager alloc] init];
    }
    return _tSDBManager;
}

- (TSGameModel *)gameModel {
    if (!_gameModel) {
        _gameModel = [[TSGameModel alloc] init];
    }
    return _gameModel;
}

// 计算本场暂停的数据
- (void)calculationTimeOutGameData {
    NSMutableDictionary *allGameDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    __block NSInteger timeOutTotalH = 0; // 主队本场暂停
    __block NSInteger timeOutTotalG = 0; // 客队本场暂停
    if (allGameDict.count) {
        [allGameDict enumerateKeysAndObjectsUsingBlock:^(NSString *stageName, NSDictionary *subDict, BOOL * _Nonnull stop) {
            if ([subDict isKindOfClass:[NSDictionary class]]) {
                if (subDict[@"0"][@"0"]) { // 如果主队有暂停数据
                    NSInteger timeOutStageH = [subDict[@"0"][@"0"] intValue];
                    timeOutTotalH += timeOutStageH;
                }
                
                if (subDict[@"1"][@"0"]) { // 如果客队有暂停数据
                    NSInteger timeOutStageG = [subDict[@"1"][@"0"] intValue];
                    timeOutTotalG += timeOutStageG;
                }
            }
        }];
    }
    
    self.gameModel.timeOutTotalH = [NSString stringWithFormat:@"%ld", timeOutTotalH];
    self.gameModel.timeOutTotalG = [NSString stringWithFormat:@"%ld", timeOutTotalG];
}

// 计算当前节次暂停的数据
- (void)calculationTimeOutSatgeData {
    NSDictionary *allGameDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    NSDictionary *stageGameDict = allGameDict[stageCount]; // 本节所有比赛数据
    NSInteger timeOutStageH = 0; // 主队本节暂停
    NSInteger timeOutStageG = 0; // 客队本节暂停
    if (stageGameDict.count) {
        if (stageGameDict[@"0"][@"0"]) { // 如果主队有暂停数据
            timeOutStageH = [stageGameDict[@"0"][@"0"] intValue];
        }
        self.gameModel.timeOutStageH = [NSString stringWithFormat:@"%ld", timeOutStageH];
        
        if (stageGameDict[@"1"][@"0"]) { // 如果客队有暂停数据
            timeOutStageG = [stageGameDict[@"1"][@"0"] intValue];
        }
        self.gameModel.timeOutStageG = [NSString stringWithFormat:@"%ld", timeOutStageG];
    }
}

// 计算主队本场的数据（包括：本场得分、本场犯规）
- (void)calculationHostTotalScoreFouls {
    NSMutableArray *allHostPlayerDataArray = [self.tSDBManager getAllHostTeamPlayerData];
//    DDLog(@"allHostPlayerDataArray is:%@", allHostPlayerDataArray);
    
    __block NSInteger scoreTotalH = 0;
    [allHostPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict1, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subDict1.count) {
            [subDict1 enumerateKeysAndObjectsUsingBlock:^(NSString *stageName, NSDictionary *subDict2, BOOL * _Nonnull stop) {
                TSManagerPlayerModel *playerModel = [TSManagerPlayerModel mj_objectWithKeyValues:subDict2];
                
                // 计算个人得分
                NSInteger scorePerson = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
                scoreTotalH += scorePerson;
            }];
        }
    }];
    
    self.gameModel.scoreTotalH = [NSString stringWithFormat:@"%ld", scoreTotalH];
//    DDLog(@"host team scoreTotal is:%ld", scoreTotalH);
}

// 计算主队单节的数据（包括：本节得分、本节犯规）
- (void)calculationHostStageScoreFouls {
    NSMutableArray *allHostPlayerDataArray = [self.tSDBManager getAllHostTeamPlayerData];
    
    NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    
    NSMutableArray *stagePlayerDataArray = [NSMutableArray array]; // 本节所有球员数据
    [allHostPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subDict[stageCount]) {
            [stagePlayerDataArray addObject:subDict[stageCount]];
        }
    }];
    
//    DDLog(@"currentStageDataArray is:%@", stagePlayerDataArray);
    __block NSInteger scoreStageH = 0; // 主队本节得分
    __block NSInteger foulsStageH = 0; // 主队本节犯规
    [stagePlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *playerModel = [TSManagerPlayerModel mj_objectWithKeyValues:subDict];
        
        // 计算个人得分
        NSInteger scorePerson = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
        scoreStageH += scorePerson;
        
        // 计算个人犯规
        NSInteger foulsPerson = playerModel.behaviorNumb10.intValue;
        foulsStageH += foulsPerson;
    }];
    
    self.gameModel.scoreStageH = [NSString stringWithFormat:@"%ld", scoreStageH];
    self.gameModel.foulsStageH = [NSString stringWithFormat:@"%ld", foulsStageH];
    
//    DDLog(@"host team foulsStage is:%ld", foulsStageH);
}

// 计算客队本场的数据（包括：本场得分、本场犯规）
- (void)calculationGuestTotalScoreFouls {
    NSMutableArray *allGuestPlayerDataArray = [self.tSDBManager getAllGuestTeamPlayerData];
//    DDLog(@"allGuestPlayerDataArray is:%@", allGuestPlayerDataArray);
    
    __block NSInteger scoreTotalG = 0;
    [allGuestPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict1, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subDict1.count) {
            [subDict1 enumerateKeysAndObjectsUsingBlock:^(NSString *stageName, NSDictionary *subDict2, BOOL * _Nonnull stop) {
                TSManagerPlayerModel *playerModel = [TSManagerPlayerModel mj_objectWithKeyValues:subDict2];
                
                // 计算个人得分
                NSInteger scorePerson = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
                scoreTotalG += scorePerson;
            }];
        }
    }];
    
    self.gameModel.scoreTotalG = [NSString stringWithFormat:@"%ld", scoreTotalG];
//    DDLog(@"guest team scoreTotal is:%ld", scoreTotalG);
}

// 计算客队单节的数据（包括：本节得分、本节犯规）
- (void)calculationGuestStageScoreFouls {
    NSMutableArray *allGuestPlayerDataArray = [self.tSDBManager getAllGuestTeamPlayerData];
    
    NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    
    NSMutableArray *stagePlayerDataArray = [NSMutableArray array]; // 本节所有球员数据
    [allGuestPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subDict[stageCount]) {
            [stagePlayerDataArray addObject:subDict[stageCount]];
        }
    }];
    
    //    DDLog(@"currentStageDataArray is:%@", stagePlayerDataArray);
    __block NSInteger scoreStageG = 0; // 客队本节得分
    __block NSInteger foulsStageG = 0; // 客队本节犯规
    [stagePlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *playerModel = [TSManagerPlayerModel mj_objectWithKeyValues:subDict];
        
        // 计算个人得分
        NSInteger scorePerson = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
        scoreStageG += scorePerson;
        
        // 计算个人犯规
        NSInteger foulsPerson = playerModel.behaviorNumb10.intValue;
        foulsStageG += foulsPerson;
    }];
    
    self.gameModel.scoreStageG = [NSString stringWithFormat:@"%ld", scoreStageG];
    self.gameModel.foulsStageG = [NSString stringWithFormat:@"%ld", foulsStageG];
    
//    DDLog(@"guest team foulsStage is:%ld", foulsStageG);
}

// 计算主队某个节次的得分和犯规
- (void)calculationHostStageScoreFoulsWithStageCount:(NSString *)stageCount {
    NSMutableArray *allHostPlayerDataArray = [self.tSDBManager getAllHostTeamPlayerData];
    
    NSMutableArray *stagePlayerDataArray = [NSMutableArray array]; // 本节所有球员数据
    [allHostPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subDict[stageCount]) {
            [stagePlayerDataArray addObject:subDict[stageCount]];
        }
    }];
    
    //    DDLog(@"currentStageDataArray is:%@", stagePlayerDataArray);
    __block NSInteger scoreStageH = 0; // 主队本节得分
    __block NSInteger foulsStageH = 0; // 主队本节犯规
    [stagePlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *playerModel = [TSManagerPlayerModel mj_objectWithKeyValues:subDict];
        
        // 计算个人得分
        NSInteger scorePerson = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
        scoreStageH += scorePerson;
        
        // 计算个人犯规
        NSInteger foulsPerson = playerModel.behaviorNumb10.intValue;
        foulsStageH += foulsPerson;
    }];
    
    if ([stageCount isEqualToString:StageOne]) {
        
        self.gameModel.scoreStageOneH = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsStageOneH = [NSString stringWithFormat:@"%ld", foulsStageH];
        
    } else if ([stageCount isEqualToString:StageTwo]) {
        
        self.gameModel.scoreStageTwoH = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsStageTwoH = [NSString stringWithFormat:@"%ld", foulsStageH];
        
    } else if ([stageCount isEqualToString:StageThree]) {
        
        self.gameModel.scoreStageThreeH = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsStageThreeH = [NSString stringWithFormat:@"%ld", foulsStageH];
        
    } else if ([stageCount isEqualToString:StageFour]) {
        
        self.gameModel.scoreStageFourH = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsStageFourH = [NSString stringWithFormat:@"%ld", foulsStageH];
        
    } else if ([stageCount isEqualToString:OverTime1]) {
        
        self.gameModel.scoreOvertime1H = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsOvertime1H = [NSString stringWithFormat:@"%ld", foulsStageH];
        
    } else if ([stageCount isEqualToString:OverTime2]) {
        
        self.gameModel.scoreOvertime2H = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsOvertime2H = [NSString stringWithFormat:@"%ld", foulsStageH];
        
    } else if ([stageCount isEqualToString:OverTime3]) {
        
        self.gameModel.scoreOvertime3H = [NSString stringWithFormat:@"%ld", scoreStageH];
        self.gameModel.foulsOvertime3H = [NSString stringWithFormat:@"%ld", foulsStageH];
    }
    
//    DDLog(@"host team scoreStage is:%ld --------- host team foulsStage is:%ld", scoreStageH, foulsStageH);
}

// 计算客队某个节次的得分和犯规
- (void)calculationGuestStageScoreFoulsWithStageCount:(NSString *)stageCount {
    NSMutableArray *allHostPlayerDataArray = [self.tSDBManager getAllGuestTeamPlayerData];
    
    NSMutableArray *stagePlayerDataArray = [NSMutableArray array]; // 本节所有球员数据
    [allHostPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subDict[stageCount]) {
            [stagePlayerDataArray addObject:subDict[stageCount]];
        }
    }];
    
    //    DDLog(@"currentStageDataArray is:%@", stagePlayerDataArray);
    __block NSInteger scoreStageG = 0; // 客队本节得分
    __block NSInteger foulsStageG = 0; // 客队本节犯规
    [stagePlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *playerModel = [TSManagerPlayerModel mj_objectWithKeyValues:subDict];
        
        // 计算个人得分
        NSInteger scorePerson = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
        scoreStageG += scorePerson;
        
        // 计算个人犯规
        NSInteger foulsPerson = playerModel.behaviorNumb10.intValue;
        foulsStageG += foulsPerson;
    }];
    
    if ([stageCount isEqualToString:StageOne]) {
        
        self.gameModel.scoreStageOneG = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsStageOneG = [NSString stringWithFormat:@"%ld", foulsStageG];
        
    } else if ([stageCount isEqualToString:StageTwo]) {
        
        self.gameModel.scoreStageTwoG = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsStageTwoG = [NSString stringWithFormat:@"%ld", foulsStageG];
        
    } else if ([stageCount isEqualToString:StageThree]) {
        
        self.gameModel.scoreStageThreeG = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsStageThreeG = [NSString stringWithFormat:@"%ld", foulsStageG];
        
    } else if ([stageCount isEqualToString:StageFour]) {
        
        self.gameModel.scoreStageFourG = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsStageFourG = [NSString stringWithFormat:@"%ld", foulsStageG];
        
    } else if ([stageCount isEqualToString:OverTime1]) {
        
        self.gameModel.scoreOvertime1G = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsOvertime1G = [NSString stringWithFormat:@"%ld", foulsStageG];
        
    } else if ([stageCount isEqualToString:OverTime2]) {
        
        self.gameModel.scoreOvertime2G = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsOvertime2G = [NSString stringWithFormat:@"%ld", foulsStageG];
        
    } else if ([stageCount isEqualToString:OverTime3]) {
        
        self.gameModel.scoreOvertime3G = [NSString stringWithFormat:@"%ld", scoreStageG];
        self.gameModel.foulsOvertime3G = [NSString stringWithFormat:@"%ld", foulsStageG];
    }
    
//    DDLog(@"guest team scoreStage is:%ld --------- guest team foulsStage is:%ld", scoreStageG, foulsStageG);
}

- (NSMutableArray *)calculationallHostPlayerFullData {
    NSArray *allPlayerArrayH = [self.tSDBManager getObjectById:TeamCheckID_H fromTable:TSCheckTable];
    NSArray *allPlayerModelArrayH = [TSPlayerModel mj_objectArrayWithKeyValuesArray:allPlayerArrayH];
    
    // 把报名比赛主队的所有人员检录数据转换成TSManagerPlayerModel模型数组
    NSMutableArray *allHostPlayerDataModelArray = [NSMutableArray array];
    [allPlayerModelArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *totalPlayerModel = [[TSManagerPlayerModel alloc] init];
        totalPlayerModel.playerId = playerModel.ID;
        totalPlayerModel.playerName = playerModel.name;
        totalPlayerModel.playerNumber = playerModel.gameNum;
        totalPlayerModel.photo = playerModel.photo;
        [allHostPlayerDataModelArray addObject:totalPlayerModel];
    }];
    
    NSMutableArray *allHostPlayerDataArray = [self.tSDBManager getAllHostTeamPlayerData];
    // 把主队有数据统计记录的人员数据转换成TSManagerPlayerModel模型数组
    if (allHostPlayerDataArray.count) {
        NSMutableArray *allPlayerDataedModelArray = [self p_playerFullDataWithAllPlayerDataArray:allHostPlayerDataArray];
        
        [allHostPlayerDataModelArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *totalPlayerModel, NSUInteger idx1, BOOL * _Nonnull stop) {
            [allPlayerDataedModelArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *playerDataedModel, NSUInteger idx2, BOOL * _Nonnull stop) {
                if ([playerDataedModel.playerId isEqualToString:totalPlayerModel.playerId]) {
                    totalPlayerModel.behaviorNumb1 = playerDataedModel.behaviorNumb1;
                    totalPlayerModel.behaviorNumb31 = playerDataedModel.behaviorNumb31;
                    totalPlayerModel.behaviorNumb2 = playerDataedModel.behaviorNumb2;
                    totalPlayerModel.behaviorNumb3 = playerDataedModel.behaviorNumb3;
                    totalPlayerModel.behaviorNumb4 = playerDataedModel.behaviorNumb4;
                    totalPlayerModel.behaviorNumb5 = playerDataedModel.behaviorNumb5;
                    totalPlayerModel.behaviorNumb6 = playerDataedModel.behaviorNumb6;
                    totalPlayerModel.behaviorNumb7 = playerDataedModel.behaviorNumb7;
                    totalPlayerModel.behaviorNumb8 = playerDataedModel.behaviorNumb8;
                    totalPlayerModel.behaviorNumb9 = playerDataedModel.behaviorNumb9;
                    totalPlayerModel.behaviorNumb10 = playerDataedModel.behaviorNumb10;
                    totalPlayerModel.FreeThrowHit = playerDataedModel.FreeThrowHit;
                    totalPlayerModel.OnePointsHit = playerDataedModel.OnePointsHit;
                    totalPlayerModel.TwoPointsHit = playerDataedModel.TwoPointsHit;
                    totalPlayerModel.ThreePointsHit = playerDataedModel.ThreePointsHit;
                }
            }];
        }];
    }
    
    return allHostPlayerDataModelArray;
}

- (NSMutableArray *)calculationallGuestPlayerFullData {
    NSArray *allPlayerArrayG = [self.tSDBManager getObjectById:TeamCheckID_G fromTable:TSCheckTable];
    NSArray *allPlayerModelArrayG = [TSPlayerModel mj_objectArrayWithKeyValuesArray:allPlayerArrayG];
    
    // 把报名比赛客队的所有人员检录数据转换成TSManagerPlayerModel模型数组
    NSMutableArray *allGuestPlayerDataModelArray = [NSMutableArray array];
    [allPlayerModelArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *totalPlayerModel = [[TSManagerPlayerModel alloc] init];
        totalPlayerModel.playerId = playerModel.ID;
        totalPlayerModel.playerName = playerModel.name;
        totalPlayerModel.playerNumber = playerModel.gameNum;
        totalPlayerModel.photo = playerModel.photo;
        [allGuestPlayerDataModelArray addObject:totalPlayerModel];
    }];
    
    NSMutableArray *allHostPlayerDataArray = [self.tSDBManager getAllGuestTeamPlayerData];
    // 把客队有数据统计记录的人员数据转换成TSManagerPlayerModel模型数组
    if (allHostPlayerDataArray.count) {
        NSMutableArray *allPlayerDataedModelArray = [self p_playerFullDataWithAllPlayerDataArray:allHostPlayerDataArray];
        
        [allGuestPlayerDataModelArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *totalPlayerModel, NSUInteger idx1, BOOL * _Nonnull stop) {
            [allPlayerDataedModelArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *playerDataedModel, NSUInteger idx2, BOOL * _Nonnull stop) {
                if ([playerDataedModel.playerId isEqualToString:totalPlayerModel.playerId]) {
                    totalPlayerModel.behaviorNumb1 = playerDataedModel.behaviorNumb1;
                    totalPlayerModel.behaviorNumb31 = playerDataedModel.behaviorNumb31;
                    totalPlayerModel.behaviorNumb2 = playerDataedModel.behaviorNumb2;
                    totalPlayerModel.behaviorNumb3 = playerDataedModel.behaviorNumb3;
                    totalPlayerModel.behaviorNumb4 = playerDataedModel.behaviorNumb4;
                    totalPlayerModel.behaviorNumb5 = playerDataedModel.behaviorNumb5;
                    totalPlayerModel.behaviorNumb6 = playerDataedModel.behaviorNumb6;
                    totalPlayerModel.behaviorNumb7 = playerDataedModel.behaviorNumb7;
                    totalPlayerModel.behaviorNumb8 = playerDataedModel.behaviorNumb8;
                    totalPlayerModel.behaviorNumb9 = playerDataedModel.behaviorNumb9;
                    totalPlayerModel.behaviorNumb10 = playerDataedModel.behaviorNumb10;
                    totalPlayerModel.FreeThrowHit = playerDataedModel.FreeThrowHit;
                    totalPlayerModel.OnePointsHit = playerDataedModel.OnePointsHit;
                    totalPlayerModel.TwoPointsHit = playerDataedModel.TwoPointsHit;
                    totalPlayerModel.ThreePointsHit = playerDataedModel.ThreePointsHit;
                }
            }];
        }];
    }
    
    return allGuestPlayerDataModelArray;
}

- (NSMutableArray *)p_playerFullDataWithAllPlayerDataArray:(NSArray *)allPlayerDataArray {
    NSMutableArray *allPlayerDataedModelArray = [NSMutableArray array];
    [allPlayerDataArray enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        TSManagerPlayerModel *totalPlayerModel = [[TSManagerPlayerModel alloc] init];
        __block int behaviorNumb1Total = 0; // 罚篮
        __block int behaviorNumb31Total = 0; // 1分
        __block int behaviorNumb2Total = 0; // 2分
        __block int behaviorNumb3Total = 0; // 3分
        __block int behaviorNumb4Total = 0; // 进攻篮板
        __block int behaviorNumb5Total = 0; // 防守篮板
        __block int behaviorNumb6Total = 0; // 抢断
        __block int behaviorNumb7Total = 0; // 失误
        __block int behaviorNumb8Total = 0; // 盖帽
        __block int behaviorNumb9Total = 0; // 助攻
        __block int behaviorNumb10Total = 0; // 犯规
        __block int FreeThrowHit = 0; // 罚篮命中数
        __block int OnePointsHit = 0; // 1分命中数
        __block int TwoPointsHit = 0; // 2分命中数
        __block int ThreePointsHit = 0; // 3分命中数
        [subDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull value, BOOL * _Nonnull stop) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                // 获取球员各个节次的数据
                TSManagerPlayerModel *subPlayerModel = [TSManagerPlayerModel mj_objectWithKeyValues:value];
                behaviorNumb1Total += subPlayerModel.behaviorNumb1.intValue;
                behaviorNumb31Total += subPlayerModel.behaviorNumb31.intValue;
                behaviorNumb2Total += subPlayerModel.behaviorNumb2.intValue;
                behaviorNumb3Total += subPlayerModel.behaviorNumb3.intValue;
                behaviorNumb4Total += subPlayerModel.behaviorNumb4.intValue;
                behaviorNumb5Total += subPlayerModel.behaviorNumb5.intValue;
                behaviorNumb6Total += subPlayerModel.behaviorNumb6.intValue;
                behaviorNumb7Total += subPlayerModel.behaviorNumb7.intValue;
                behaviorNumb8Total += subPlayerModel.behaviorNumb8.intValue;
                behaviorNumb9Total += subPlayerModel.behaviorNumb9.intValue;
                behaviorNumb10Total += subPlayerModel.behaviorNumb10.intValue;
                FreeThrowHit += subPlayerModel.FreeThrowHit.intValue;
                OnePointsHit += subPlayerModel.OnePointsHit.intValue;
                TwoPointsHit += subPlayerModel.TwoPointsHit.intValue;
                ThreePointsHit += subPlayerModel.ThreePointsHit.intValue;
            }
        }];
        
        totalPlayerModel.behaviorNumb1 = [NSString stringWithFormat:@"%d", behaviorNumb1Total];
        totalPlayerModel.behaviorNumb31 = [NSString stringWithFormat:@"%d", behaviorNumb31Total];
        totalPlayerModel.behaviorNumb2 = [NSString stringWithFormat:@"%d", behaviorNumb2Total];
        totalPlayerModel.behaviorNumb3 = [NSString stringWithFormat:@"%d", behaviorNumb3Total];
        totalPlayerModel.behaviorNumb4 = [NSString stringWithFormat:@"%d", behaviorNumb4Total];
        totalPlayerModel.behaviorNumb5 = [NSString stringWithFormat:@"%d", behaviorNumb5Total];
        totalPlayerModel.behaviorNumb6 = [NSString stringWithFormat:@"%d", behaviorNumb6Total];
        totalPlayerModel.behaviorNumb7 = [NSString stringWithFormat:@"%d", behaviorNumb7Total];
        totalPlayerModel.behaviorNumb8 = [NSString stringWithFormat:@"%d", behaviorNumb8Total];
        totalPlayerModel.behaviorNumb9 = [NSString stringWithFormat:@"%d", behaviorNumb9Total];
        totalPlayerModel.behaviorNumb10 = [NSString stringWithFormat:@"%d", behaviorNumb10Total];
        totalPlayerModel.FreeThrowHit = [NSString stringWithFormat:@"%d", FreeThrowHit];
        totalPlayerModel.OnePointsHit = [NSString stringWithFormat:@"%d", OnePointsHit];
        totalPlayerModel.TwoPointsHit = [NSString stringWithFormat:@"%d", TwoPointsHit];
        totalPlayerModel.ThreePointsHit = [NSString stringWithFormat:@"%d", ThreePointsHit];
        
        // 将所有球员全场的统计数据转成模型，保存到数组中
        totalPlayerModel.playerId = subDict[@"playerId"];
        [allPlayerDataedModelArray addObject:totalPlayerModel];
    }];
    
    return allPlayerDataedModelArray;
}

#pragma mark - 获取主客队颜色
- (NSArray *)getHostTeamAndGuestTeamColor {
    NSString *documentsPath = nil;
    NSArray *appArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([appArray count] > 0) {
        documentsPath = [appArray objectAtIndex:0];
    }
    NSString *tsdbPath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", TSDBName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tsdbPath]) {
        return @[[UIColor whiteColor], [UIColor whiteColor]];
    }
    
    NSMutableArray *colorArray = [NSMutableArray array];
    NSDictionary *gameCheckDict = [self.tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
    __block UIColor *teamColorH = [UIColor whiteColor];
    __block UIColor *teamColorG = [UIColor whiteColor];
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeBCBC || currentUserType == LoginUserTypeCBO) {
        [ColorArrayH enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subArray[1] isEqualToString:gameCheckDict[@"teamColorH"]]) {
                teamColorH = [TSToolsMethod colorWithHexString:subArray[1]];
                if ([subArray[0] isEqualToString:@"其他"]) { // 如果颜色是其他
                    teamColorH = [UIColor clearColor];
                }
            }
        }];
        [ColorArrayG enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subArray[1] isEqualToString:gameCheckDict[@"teamColorG"]]) {
                teamColorG = [TSToolsMethod colorWithHexString:subArray[1]];
                if ([subArray[0] isEqualToString:@"其他"]) { // 如果颜色是其他
                    teamColorG = [UIColor clearColor];
                }
            }
        }];
        
        
        
    }
    
    [colorArray addObject:teamColorH];
    [colorArray addObject:teamColorG];
    
    return colorArray;
}

#pragma mark - 获取当前节的时间
- (int)getCurrentStageTimes {
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    __block int stageGameTimes = 0;
    NSString *currentStage = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageCount, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentStage isEqualToString:stageCount]) {
            if (idx <= 3) { // 1 - 4节
                if (1 == [gameTableDict[@"sectionType"] intValue]) { // 4节X10分钟
                    stageGameTimes = 600;
                } else if (2 == [gameTableDict[@"sectionType"] intValue]) { // 4节X12分钟
                    stageGameTimes = 720;
                } else if (3 == [gameTableDict[@"sectionType"] intValue]) { // 1节X10分钟
                    stageGameTimes = 600;
                } else if (4 == [gameTableDict[@"sectionType"] intValue]) { // 2节X8分钟
                    stageGameTimes = 480;
                }
            } else if ([stageCount isEqualToString:OverTime1] && 2 == [gameTableDict[@"ruleType"] intValue]) { // 3X3 加时赛
                stageGameTimes = 0;
            } else { // 加时赛
                stageGameTimes = 300;
            }
        }
    }];
    
    return stageGameTimes;
}
@end
