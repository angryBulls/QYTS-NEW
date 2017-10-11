//
//  TSNetworkManger+CBO.m
//  QYTS
//
//  Created by lxd on 2017/9/25.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSNetworkManger+CBO.h"

@implementation TSNetworkManger (CBO)
+ (void)startLoginCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    unEncodeDict[@"service"] = @"cbo";
    unEncodeDict[@"method"] = @"login";
    unEncodeDict[@"params"] = paramsDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    [self p_PrivatePOST:TS_SERVER_URL_TEST paramsDict:encodeDic responseSuccess:^(id responseObject) {
        success(responseObject);
    } responseFailed:^(NSError *error) {
        failed(error);
    }];
}

+ (void)getGuide:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    unEncodeDict[@"service"] = @"index";
    unEncodeDict[@"method"] = @"getGuide";
    unEncodeDict[@"params"] = paramsDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    [self p_PrivatePOST:TS_SERVER_URL_TEST paramsDict:encodeDic responseSuccess:^(id responseObject) {
        success(responseObject);
    } responseFailed:^(NSError *error) {
        failed(error);
    }];
}

+ (void)cboFindMatchAndTeamInfo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
    unEncodeDict[@"token"] = userInfo.token;
    unEncodeDict[@"service"] = @"cbo";
    unEncodeDict[@"method"] = @"findMatchAndTeamInfo";
    unEncodeDict[@"params"] = paramsDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    [self p_PrivatePOST:TS_SERVER_URL_TEST paramsDict:encodeDic responseSuccess:^(id responseObject) {
        success(responseObject);
    } responseFailed:^(NSError *error) {
        failed(error);
    }];
}

+ (void)getPlaysDataByTeamCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
    unEncodeDict[@"token"] = userInfo.token;
    unEncodeDict[@"service"] = @"cbo";
    unEncodeDict[@"method"] = @"queryPlayByTeam";
    unEncodeDict[@"params"] = paramsDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    [self p_PrivatePOST:TS_SERVER_URL_TEST paramsDict:encodeDic responseSuccess:^(id responseObject) {
        success(responseObject);
    } responseFailed:^(NSError *error) {
        failed(error);
    }];
}

+ (void)abstentionCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
    unEncodeDict[@"token"] = userInfo.token;
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"cbo";
    unEncodeDict[@"method"] = @"abstention";
    unEncodeDict[@"params"] = paramsDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    [self p_PrivatePOST:TS_SERVER_URL_TEST paramsDict:encodeDic responseSuccess:^(id responseObject) {
        success(responseObject);
    } responseFailed:^(NSError *error) {
        failed(error);
    }];
}

+ (void)sendCurrentStageDataCBO:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    
    TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
    unEncodeDict[@"token"] = userInfo.token;
    unEncodeDict[@"service"] = @"cbo";
    unEncodeDict[@"method"] = @"saveMatchInfo";
    unEncodeDict[@"params"] = paramsDict;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    [self p_PrivatePOST:TS_SERVER_URL_TEST paramsDict:encodeDic responseSuccess:^(id responseObject) {
        success(responseObject);
    } responseFailed:^(NSError *error) {
        failed(error);
    }];
}
@end
