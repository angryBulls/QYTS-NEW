//
//  TSNetworkManger.m
//  TS
//
//  Created by lxd on 2017/2/20.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import "TSNetworkManger.h"

@implementation TSNetworkManger
+ (NetworkStatus)checkCurrentNetWorkType {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    return status;
}

+ (void)ts_hasNetworkByAF:(void(^)(bool has))hasNet { // 网络监听
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                hasNet(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNet(YES);
                break;
        }
    }];
    [manager stopMonitoring];
}

+ (void)getCurrentVersion:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"version";
    unEncodeDict[@"channel"] = @"ios";
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

+ (void)startLoginBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    unEncodeDict[@"service"] = @"playerMatch";
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

+ (void)startLoginNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    unEncodeDict[@"service"] = @"ssouser";
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

+ (void)startLoginNormalByVCode:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"loginByVCode";
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

+ (void)loginOut:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"user";
    unEncodeDict[@"method"] = @"logout";
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
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

+ (void)getTeamFinalsData:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
    unEncodeDict[@"method"] = @"queryTeamByFinalMatch";
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

+ (void)getTeamAreaData:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
    unEncodeDict[@"method"] = @"queryTeamByZone";
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

+ (void)getTeamProvinceData:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
    unEncodeDict[@"method"] = @"queryTeamByProvince";
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

+ (void)getPlaysDataByTeamBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
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

+ (void)getPlaysDataByTeamNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
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

+ (void)getMatchAndTeamInfoNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
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

+ (void)saveAmateurMatchInfo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"saveAmateurMatchInfo";
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

+ (void)sendCurrentStageDataBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
    unEncodeDict[@"method"] = @"save";
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

+ (void)sendCurrentStageDataNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    unEncodeDict[@"sn"] = [NSString stringWithFormat:@"%lf", interval];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
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

+ (void)fetchAuthCode:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"verificationCode";
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

+ (void)registerUser:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"register";
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

+ (void)getUserHistoryMatchList:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"getUserHistoryMatchList";
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

+ (void)uploadThumbnailWithImage:(UIImage *)image responseSuccess:(Success)success responseFailed:(Failed)failed {
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"image";
    unEncodeDict[@"method"] = @"uploadPhoto";
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    unEncodeDict[@"params"] = @{@"image" : encodedImageStr};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unEncodeDict options:0 error:nil];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *encodeDic = [[NSDictionary alloc] initWithObjectsAndKeys:myString, @"body", nil];
    
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"" parameters:encodeDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        PPLog(@"progress is:%lf",1.0*uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        PPLog(@"thumbnail result is:%@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
        [SVProgressHUD showInfoWithStatus:@"加载失败，请检查网络状态"];
    }];
}

+ (void)abstentionNormal:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
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

+ (void)abstentionBCBC:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"playerMatch";
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

#pragma mark - 个人中心相关 ***************************************** start **********************************************
+ (void)changePhone:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"changePhone";
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

+ (void)changePassword:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"changePassword";
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

+ (void)findPassword:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"findPassword";
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

+ (void)getSsoUserDetail:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"getSsoUserDetail";
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

+ (void)getUserMatchCount:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"getUserMatchCount";
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

+ (void)getTeamInfoList:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"getTeamInfoList";
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

+ (void)updateSsoUser:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"ssouser";
    unEncodeDict[@"method"] = @"updateSsoUser";
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

+ (void)getUserHistoryMatchDetail:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"getUserHistoryMatchDetail";
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

+ (void)matchBlankOut:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
        paramsDict[@"type"] = @0;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
        paramsDict[@"type"] = @1;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"matchBlankOut";
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

+ (void)shareMatchInfo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"shareMatchInfo";
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

+ (void)shareLogSave:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else if (currentUserType == LoginUserTypeBCBC) {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelCBO *userInfo = [TSToolsMethod fetchUserInfoModelCBO];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"shareLogSave";
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
#pragma mark - 个人中心相关 ***************************************** end **********************************************

#pragma mark - 支付相关 ***************************************** start **********************************************
+ (void)checkNormalAccountStatus:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 检查普通用户账户状态
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"preMatch";
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

+ (void)getBCBCMatchId:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 获取BCBC的MatchId
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
    unEncodeDict[@"method"] = @"getMatchId";
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

+ (void)checkBCBCAccountStatus:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 检查BCBC用户账户状态
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"playerMatch";
    unEncodeDict[@"method"] = @"preMatchForBcbc";
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

+ (void)getOnceCombo:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 获得一次套餐信息
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"amateurstatistic";
    unEncodeDict[@"method"] = @"getOnceCombo";
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

+ (void)getWechatPayOrderId:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 获取微信支付orderId
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    if (currentUserType == LoginUserTypeNormal) {
        paramsDict[@"orderType"] = @0;
    } else {
        paramsDict[@"orderType"] = @1;
    }
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"order";
    unEncodeDict[@"method"] = @"create";
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

+ (void)getWechatPaySign:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 微信支付
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"tenpay";
    unEncodeDict[@"method"] = @"prePay";
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

+ (void)getAlipayOrderString:(NSMutableDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed { // 获取支付宝支付orderString
    NSMutableDictionary *unEncodeDict = [NSMutableDictionary dictionary];
    
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    
    unEncodeDict[@"sn"] = [TSToolsMethod creatUUID];
    if (currentUserType == LoginUserTypeNormal) {
        TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
        unEncodeDict[@"token"] = userInfo.token;
    } else {
        TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
        unEncodeDict[@"token"] = userInfo.token;
    }
    unEncodeDict[@"service"] = @"alipay";
    unEncodeDict[@"method"] = @"sign";
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

//+ (void)p_PrivateGET:(NSString *)url paramsDict:(NSDictionary *)paramsDict showActivityView:(BOOL)showActivityView responseSuccess:(Success)success responseFailed:(Failed)failed {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    __weak AFHTTPSessionManager *manager = [self sharedGetHTTPSession];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    [manager GET:url parameters:paramsDict progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        DDLog(@"get 请求失败！！！！！！");
//        
//        [self p_PrivatePOST:url paramsDict:paramsDict responseSuccess:^(id responseObject) {
//            success(responseObject);
//        } responseFailed:^(NSError *error) {
//            failed(error);
//        }];
//    }];
//}

// post data agin if get data failed
+ (void)p_PrivatePOST:(NSString *)url paramsDict:(NSDictionary *)paramsDict responseSuccess:(Success)success responseFailed:(Failed)failed {
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:paramsDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
        if (url.length) {
            [SVProgressHUD showInfoWithStatus:@"加载失败，请检查网络状态"];
            DDLog(@"error is:%@ ---------- url is:%@", error, url);
        }
    }];
}

+ (AFHTTPSessionManager *)manager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}
@end
