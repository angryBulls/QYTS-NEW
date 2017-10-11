//
//  MyGameOverListModel.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGameOverListModel : NSObject
@property (nonatomic, copy) NSString *awayTeamId;
@property (nonatomic, copy) NSString *awayTeamName;
@property (nonatomic, copy) NSString *awayScore;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *homeTeamId;
@property (nonatomic, copy) NSString *homeTeamName;
@property (nonatomic, copy) NSString *homeScore;
@property (nonatomic, copy) NSString *matchDate;
@property (nonatomic, copy) NSString *matchDateDisplay;
@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, copy) NSString *ruleType;
@property (nonatomic, copy) NSString *sectionType;
@property (nonatomic, copy) NSString *shareNum;
@end
