//
//  TSManagerPlayerModel.h
//  QYTS
//
//  Created by lxd on 2017/7/24.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSManagerPlayerModel : NSObject
@property (nonatomic, copy) NSString *behaviorNumb1; // 罚篮
@property (nonatomic, copy) NSString *behaviorNumb31; // 1分
@property (nonatomic, copy) NSString *behaviorNumb2; // 2分
@property (nonatomic, copy) NSString *behaviorNumb3; // 3分
@property (nonatomic, copy) NSString *behaviorNumb4; // 进攻篮板
@property (nonatomic, copy) NSString *behaviorNumb5; // 防守篮板
@property (nonatomic, copy) NSString *behaviorNumb6; // 抢断
@property (nonatomic, copy) NSString *behaviorNumb7; // 失误
@property (nonatomic, copy) NSString *behaviorNumb8; // 盖帽
@property (nonatomic, copy) NSString *behaviorNumb9; // 助攻
@property (nonatomic, copy) NSString *behaviorNumb10; // 犯规

@property (nonatomic, copy) NSString *FreeThrowHit; // 罚篮命中数
@property (nonatomic, copy) NSString *OnePointsHit; // 1分命中数
@property (nonatomic, copy) NSString *TwoPointsHit; // 2分命中数
@property (nonatomic, copy) NSString *ThreePointsHit; // 3分命中数

@property (nonatomic, copy) NSString *playerId;
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, copy) NSString *playerNumber;
@property (nonatomic, copy) NSString *photo; // 球员头像

@property (nonatomic, assign) BOOL changeStatus; // 标记cell是否可以被修改
@end
