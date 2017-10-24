//
//  TSDBManager.h
//  QYTS
//
//  Created by lxd on 2017/7/21.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SaveDBStatusSuccessBlock)(NSDictionary *insertDBDict);//识别完整信息
typedef void (^SaveDBStatusFailBlock)(NSString *error);// 识别有效信息（不完整）
typedef void (^SaveDBStatusWrongBlock)(NSString *error);// 识别无效信息
typedef void (^UpdatePalyerTableSuccessBlock)();

@interface TSDBManager : NSObject
- (void)saveOneResultDataWithDict:(NSDictionary *)resultDict saveDBStatusSuccessBlock:(SaveDBStatusSuccessBlock)saveDBStatusSuccessBlock saveDBStatusFailBlock:(SaveDBStatusFailBlock)saveDBStatusFailBlock saveDBStatusWrongBlock:(SaveDBStatusWrongBlock)saveDBStatusWrongBlock;
- (void)deleteObjectByInsertDBDict:(NSDictionary *)insertDBDict;
- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

 // 修改一条球员数据（包括：罚球、2分和3分命中数）
- (void)updateDBPlayerTabelByPlayerId:(NSString *)playerId dataType:(id)dataType newValue:(id)newValue successReturnBlock:(UpdatePalyerTableSuccessBlock)successReturnBlock;

 // 更新一次所有球员的上场时间
- (void)udatePlayingTimesOnce;

 // 初始化一次球员的上场时间
- (void)initPlayingTimesOnce;

- (void)insertObjectByInsertDBDict:(NSDictionary *)insertDBDict playerId:(NSString *)playerId; // 新增一条球员统计数据

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName; // 保存数据
- (NSMutableArray *)getAllHostTeamPlayerData; // 获取所有主队球员的数据
- (NSMutableArray *)getAllGuestTeamPlayerData; // 获取所有客队球员的数据
- (NSString *)getPlayerIdWithinsertDBDict:(NSDictionary *)insertDBDict; // 获取球员id
@end
