//
//  MyGameOverModel.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGameOverModel : NSObject
@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *count3V3;
@property (nonatomic, copy) NSString *count5V5;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSArray *matchList;
@end
