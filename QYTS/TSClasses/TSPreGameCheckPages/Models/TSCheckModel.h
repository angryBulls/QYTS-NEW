//
//  TSCheckModel.h
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//  BCBC赛前检录模型

#import <Foundation/Foundation.h>

@interface TSCheckModel : NSObject
@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, copy) NSString *matchName;

@property (nonatomic, copy) NSString *matchDate;

@property (nonatomic, copy) NSString *gameLevel;
@property (nonatomic, copy) NSString *gameArea;
@property (nonatomic, copy) NSString *gameProvince;

@property (nonatomic, copy) NSString *homeTeamId;
@property (nonatomic, copy) NSString *homeTeamName;

@property (nonatomic, copy) NSString *awayTeamId;
@property (nonatomic, copy) NSString *awayTeamName;

@property (nonatomic, copy) NSString *teamColorH;
@property (nonatomic, copy) NSString *teamColorG;

@property (nonatomic, copy) NSString *ruleType; // 赛制 5V5或其他
@property (nonatomic, copy) NSString *sectionType; // 单节时间4节X10分钟或其他

@property (nonatomic, copy) NSString *mainReferee; // 主裁判
@property (nonatomic, copy) NSString *firstReferee; // 第一副裁
@property (nonatomic, copy) NSString *secondReferee; // 第二副裁
@property (nonatomic, copy) NSString *td; // 技术代表
@property (nonatomic, copy) NSString *recorder; // 记录员
@end
