//
//  TSDBManager+RecognizerResultJudge.m
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSDBManager+RecognizerResultJudge.h"

@implementation TSDBManager (RecognizerResultJudge)
- (BOOL)recognizerSuccessWithDict:(NSMutableDictionary *)insertDBDict {
    DDLog(@"目前识别的结果为:%@", insertDBDict);
    
    if (!insertDBDict[BnfTeameType]) { // 未识别主客队
        return NO;
    }
    
    if ([insertDBDict[BnfTeameType] intValue] > 1) { // 根据颜色判断主客队
        TSDBManager *tSDBManager = [[TSDBManager alloc] init];
        NSDictionary *gameCheckDict = [tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
        
        int index = [insertDBDict[BnfTeameType] intValue] - 2;
        NSString *resultColor = ColorArrayH[index][1];
        NSString *resultColorG = ColorArrayH[index][1];
        
        if ([resultColor isEqualToString:gameCheckDict[@"teamColorH"]]) {
            insertDBDict[BnfTeameType] = @"0";
        }
        if ([resultColorG isEqualToString:gameCheckDict[@"teamColorG"]]) {
            insertDBDict[BnfTeameType] = @"1";
        }
    }
    
    if (insertDBDict[BnfBehaviorType]) { // 这是一条暂停识别
        if (0 == [insertDBDict[BnfBehaviorType] intValue]) {
            return YES;
        }
    }
    
    if (!insertDBDict[NumbResultStr]) { // 这是一条球员统计数据
        return NO;
    }
    
    if (!insertDBDict[BnfBehaviorType]) { // 如果没有球员行为识别
        return NO;
    }
    
    if (1 == [insertDBDict[BnfBehaviorType] intValue] || 31 == [insertDBDict[BnfBehaviorType] intValue] || 2 == [insertDBDict[BnfBehaviorType] intValue] || 3 == [insertDBDict[BnfBehaviorType] intValue]) { // 如果识别行为是罚篮、1分、2分、3分则必须确认是否投中再存储
        if (!insertDBDict[BnfResultType]) {
            return NO;
        }
    }
    
    if (11 == [insertDBDict[BnfBehaviorType] intValue]) { // 这是一条球员下场的数据
        if (![self getPlayerPlayingStatusWithDict:insertDBDict]) { // 球员不在场
            return NO;
        }
    } else if (12 == [insertDBDict[BnfBehaviorType] intValue]) { // 这是一条球员上场的数据
        if ([self getPlayerPlayingStatusWithDict:insertDBDict]) { // 球员在场
            return NO;
        } else { // 球员不在场，继续执行
            int startPlayingNum = [self getStartPlayingNumWithDict:insertDBDict];
            TSDBManager *tSDBManager = [[TSDBManager alloc] init];
            NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
            if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3X3
                if (startPlayingNum >= 3) {
                    return NO;
                }
            } else {
                if (startPlayingNum >= 5) {
                    return NO;
                }
            }
        }
    }
    if (13 == [insertDBDict[BnfBehaviorType] intValue]) {
        
    }
    
    return YES;
}

- (BOOL)p_checkPlayerUpOrDownData {
    return YES;
}

- (NSString *)appendResultStringWithDict:(NSDictionary *)insertDBDict {
    NSMutableString *resultString = [[NSMutableString alloc] init];
    if (0 == [insertDBDict[BnfTeameType] intValue]) { // 主队
        [resultString appendString:@"主队"];
    } else {
        [resultString appendString:@"客队"];
    }
    
    if (0 == [insertDBDict[BnfBehaviorType] intValue]) { // 暂停
        [resultString appendString:@"暂停"];
        return resultString;
    }
    
    [resultString appendString:[NSString stringWithFormat:@"%@号", insertDBDict[NumbResultStr]]];
    
    if (1 == [insertDBDict[BnfBehaviorType] intValue]) { // 罚篮
        [resultString appendString:@"罚篮"];
    } else if (2 == [insertDBDict[BnfBehaviorType] intValue]) { // 两分
        [resultString appendString:@"两分"];
    } else if (3 == [insertDBDict[BnfBehaviorType] intValue]) { // 三分
        [resultString appendString:@"三分"];
    } else if (4 == [insertDBDict[BnfBehaviorType] intValue]) { // 进攻篮板
        [resultString appendString:@"进攻篮板"];
    } else if (5 == [insertDBDict[BnfBehaviorType] intValue]) { // 防守篮板
        [resultString appendString:@"防守篮板"];
    } else if (6 == [insertDBDict[BnfBehaviorType] intValue]) { // 抢断
        [resultString appendString:@"抢断"];
    } else if (7 == [insertDBDict[BnfBehaviorType] intValue]) { // 失误
        [resultString appendString:@"失误"];
    } else if (8 == [insertDBDict[BnfBehaviorType] intValue]) { // 盖帽
        [resultString appendString:@"盖帽"];
    } else if (9 == [insertDBDict[BnfBehaviorType] intValue]) { // 助攻
        [resultString appendString:@"助攻"];
    } else if (10 == [insertDBDict[BnfBehaviorType] intValue]) { // 犯规
        [resultString appendString:@"犯规"];
    } else if (11 == [insertDBDict[BnfBehaviorType] intValue]) { // 下场
        [resultString appendString:@"下场"];
    } else if (12 == [insertDBDict[BnfBehaviorType] intValue]) { // 上场
        [resultString appendString:@"上场"];
    } else if (13 == [insertDBDict[BnfBehaviorType] intValue]) { // 换人
        [resultString appendString:@"换"];
        [resultString appendString:[NSString stringWithFormat:@"%@号", insertDBDict[NumbResultStr2]]];
    }
    
    else if (31 == [insertDBDict[BnfBehaviorType] intValue]) { // 一分
        [resultString appendString:@"一分"];
    }
    
    if (1 == [insertDBDict[BnfBehaviorType] intValue] || 31 == [insertDBDict[BnfBehaviorType] intValue] || 2 == [insertDBDict[BnfBehaviorType] intValue] || 3 == [insertDBDict[BnfBehaviorType] intValue]) {
        if (0 == [insertDBDict[BnfResultType] intValue]) { // 不中
            [resultString appendString:@"不中"];
        } else {
            [resultString appendString:@"中"];
        }
    }
    
    return resultString;
}

#pragma mark - 获取球员的在场状态
- (BOOL)getPlayerPlayingStatusWithDict:(NSDictionary *)insertDBDict {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSArray *playerCheckArray = @[];
    if (0 == [insertDBDict[BnfTeameType] intValue]) { // 主队
        playerCheckArray = [tSDBManager getObjectById:TeamCheckID_H fromTable:TSCheckTable];
    } else { // 客队
        playerCheckArray = [tSDBManager getObjectById:TeamCheckID_G fromTable:TSCheckTable];
    }
    
    __block int playingStatus = 0; // 标记球员在场状态
    [playerCheckArray enumerateObjectsUsingBlock:^(NSMutableDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subDict[@"gameNum"] intValue] == [insertDBDict[NumbResultStr] intValue]) {
            playingStatus = [subDict[@"playingStatus"] intValue];
        }
    }];
    
    return playingStatus;
}

#pragma mark - 获取主客队当前首发人数
- (int)getStartPlayingNumWithDict:(NSDictionary *)insertDBDict {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSArray *playerCheckArray = @[];
    if (0 == [insertDBDict[BnfTeameType] intValue]) { // 主队
        playerCheckArray = [tSDBManager getObjectById:TeamCheckID_H fromTable:TSCheckTable];
    } else { // 客队
        playerCheckArray = [tSDBManager getObjectById:TeamCheckID_G fromTable:TSCheckTable];
    }
    
    __block int startPlayingNum = 0;
    [playerCheckArray enumerateObjectsUsingBlock:^(NSMutableDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (1 == [subDict[@"playingStatus"] intValue]) {
            startPlayingNum ++;
        }
    }];
    
    return startPlayingNum;
}
@end
