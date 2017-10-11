//
//  ShareMatchInfoModel.h
//  QYTS
//
//  Created by lxd on 2017/9/11.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareMatchInfoModel : NSObject
@property (nonatomic, copy) NSString *highScorePlayer;

@property (nonatomic, copy) NSString *awayTeamName;
@property (nonatomic, copy) NSString *awayTeamScore;
@property (nonatomic, strong) NSDictionary *awayScores;

@property (nonatomic, copy) NSString *homeTeamName;
@property (nonatomic, copy) NSString *homeTeamScore;
@property (nonatomic, strong) NSDictionary *homeScores;

@property (nonatomic, copy) NSString *matchTime;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *playerPhoto;

@property (nonatomic, copy) NSString *ruleType;
@property (nonatomic, copy) NSString *sectionNum;
@property (nonatomic, copy) NSString *sectionType;

@property (nonatomic, copy) NSString *mainReferee; // 主裁判
@property (nonatomic, copy) NSString *firstReferee; // 第一副裁判
@property (nonatomic, copy) NSString *secondReferee; // 第二副裁判
@property (nonatomic, copy) NSString *td; // 技术代表
@property (nonatomic, copy) NSString *recorder; // 记录员
@end
