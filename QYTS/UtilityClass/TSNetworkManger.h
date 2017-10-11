//
//  TSNetworkManger.h
//  TS
//
//  Created by lxd on 2017/2/20.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef void (^Success)(id responseObject);
typedef void (^Failed)(NSError * error);

@interface TSNetworkManger : NSObject
+ (NetworkStatus)checkCurrentNetWorkType;
+ (void)ts_hasNetworkByAF:(void(^)(bool has))hasNet;

+ (void)getCurrentVersion:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)startLoginBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)startLoginNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)startLoginNormalByVCode:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)loginOut:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)fetchAuthCode:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)registerUser:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)getSsoUserDetail:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getUserMatchCount:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getTeamInfoList:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)updateSsoUser:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getUserHistoryMatchDetail:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)changePhone:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)changePassword:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)findPassword:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)matchBlankOut:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)shareMatchInfo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)shareLogSave:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)abstentionNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)abstentionBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)getTeamFinalsData:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getTeamAreaData:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getTeamProvinceData:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getPlaysDataByTeamBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getPlaysDataByTeamNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getMatchAndTeamInfoNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)saveAmateurMatchInfo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)sendCurrentStageDataBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)sendCurrentStageDataNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)checkNormalAccountStatus:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getBCBCMatchId:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)checkBCBCAccountStatus:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getOnceCombo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getUserHistoryMatchList:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

+ (void)getWechatPayOrderId:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getWechatPaySign:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
+ (void)getAlipayOrderString:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;

#pragma request base method ***************************************
+ (void)p_PrivatePOST:(NSString *)url paramsDict:(NSDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed;
@end
