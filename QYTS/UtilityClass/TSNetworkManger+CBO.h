//
//  TSNetworkManger+CBO.h
//  QYTS
//
//  Created by lxd on 2017/9/25.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSNetworkManger.h"

@interface TSNetworkManger (CBO)
+ (void)startLoginCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)getGuide:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)cboFindMatchAndTeamInfo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)getPlaysDataByTeamCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)abstentionCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)sendCurrentStageDataCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
@end
