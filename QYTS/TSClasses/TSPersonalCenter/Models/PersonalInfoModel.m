//
//  PersonalInfoModel.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalInfoModel.h"

@implementation PersonalInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             @"newcount" : @"newCount"};
}
@end
