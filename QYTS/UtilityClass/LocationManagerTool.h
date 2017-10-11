//
//  LocationManagerTool.h
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LocationSuccessBlock)(NSDictionary *locationDict);
typedef void (^LocationFailedBlock)();

@interface LocationManagerTool : NSObject
- (instancetype)initWithLocationSuccess:(LocationSuccessBlock)locationSuccessBlock locationFailedBlock:(LocationFailedBlock)locationFailedBlock;

- (void)startUpdatLocation;
- (void)stopUpdatLocation;
@end
