//
//  CheckGameDataModel.h
//  QYTS
//
//  Created by lxd on 2017/8/24.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckGameDataModel : NSObject
@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, copy) NSString *homeId;
@property (nonatomic, copy) NSString *homeScore;
@property (nonatomic, copy) NSString *awayId;
@property (nonatomic, copy) NSString *awayScore;
@property (nonatomic, copy) NSString *endTime;
@end
