//
//  TSCalculationTool.h
//  QYTS
//
//  Created by lxd on 2017/7/25.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSGameModel;

@interface TSCalculationTool : NSObject
@property (nonatomic, strong) TSGameModel *gameModel;
// 计算主队本场的数据（包括：本场得分、本场犯规）
- (void)calculationHostTotalScoreFouls;
- (void)calculationGuestTotalScoreFouls;

// 计算主队单节的数据（包括：本节得分、本节犯规）
- (void)calculationHostStageScoreFouls;
- (void)calculationGuestStageScoreFouls;

// 计算主队某个节次的得分和犯规
- (void)calculationHostStageScoreFoulsWithStageCount:(NSString *)stageCount;

// 计算客队某个节次的得分和犯规
- (void)calculationGuestStageScoreFoulsWithStageCount:(NSString *)stageCount;

// 计算本场暂停的数据
- (void)calculationTimeOutGameData;

// 计算单节暂停的数据
- (void)calculationTimeOutSatgeData;

// 计算主队本场每个球员的全部统计数据（已进行的比赛），保存到TSManagerPlayerModel中返回
- (NSMutableArray *)calculationallHostPlayerFullData;

// 计算客队本场每个球员的全部统计数据（已进行的比赛），保存到TSManagerPlayerModel中返回
- (NSMutableArray *)calculationallGuestPlayerFullData;

// 获取主客队的颜色
- (NSArray *)getHostTeamAndGuestTeamColor;
// 获取当前节的时间
- (int)getCurrentStageTimes;
@end
