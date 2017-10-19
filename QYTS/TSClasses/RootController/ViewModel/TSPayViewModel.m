//
//  TSPayViewModel.m
//  QYTS
//
//  Created by lxd on 2017/8/17.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPayViewModel.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OnceComboModel.h"

@interface TSPayViewModel ()
@property (nonatomic, strong) NSMutableDictionary *paramasDict;
@end

@implementation TSPayViewModel
- (instancetype)initWithParamsDict:(NSMutableDictionary *)paramasDict {
    if (self = [super init]) {
        _paramasDict = paramasDict;
    }
    return self;
}

- (void)checkCBOAccountStatus {
    self.returnBlock(@{@"success" : @1});
}

- (void)checkNormalAccountStatus {
    [TSNetworkManger checkNormalAccountStatus:self.paramasDict responseSuccess:^(id responseObject) {
//        DDLog(@"get user account status is:%@", responseObject);
        if ([responseObject[@"success"] isEqual:@1]) { // 用户无需购买
            self.returnBlock(responseObject);
        } else if ([responseObject[@"success"] isEqual:@0] && [responseObject[@"reason"] isEqualToString:@"buy"]) {
            self.returnBlock(responseObject);
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)checkBCBCAccountStatus { // 暂时未使用
    [TSNetworkManger checkBCBCAccountStatus:self.paramasDict responseSuccess:^(id responseObject) {
        //        DDLog(@"get user account status is:%@", responseObject);
        if ([responseObject[@"success"] isEqual:@1]) { // 用户无需购买
            self.returnBlock(responseObject);
        } else if ([responseObject[@"success"] isEqual:@0] && [responseObject[@"reason"] isEqualToString:@"buy"]) {
            
            self.returnBlock(responseObject);
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)getOnceCombo {
    [TSNetworkManger getOnceCombo:self.paramasDict responseSuccess:^(id responseObject) {
//        DDLog(@"getOnceCombo responseObject is:%@", responseObject);
        if ([responseObject[@"success"] isEqual:@1]) {
            if ([responseObject[@"entity"] count]) {
                OnceComboModel *onceComboModel = [OnceComboModel mj_objectWithKeyValues:responseObject[@"entity"]];
                self.returnBlock(onceComboModel);
            } else {
                [self errorCodeWithReason:@"请求失败"];
            }
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)getPayOrderId {
    [TSNetworkManger getWechatPayOrderId:self.paramasDict responseSuccess:^(id responseObject) {
//        DDLog(@"get orderId return is:%@", responseObject);
        if ([responseObject[@"success"] isEqual:@1]) {
            if (responseObject[@"entity"][@"orderId"]) {
                if (self.payType == PayTypeWXPay) { // 微信支付
                    [self p_getWechatPaySignWithOrderId:responseObject[@"entity"][@"orderId"]];
                } else if (self.payType == PayTypeAliPay) { // 支付宝支付
                    [self p_getAlipayOrderStringWithOrderId:responseObject[@"entity"][@"orderId"]];
                }
            }
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)p_getWechatPaySignWithOrderId:(NSString *)orderId {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"orderId"] = orderId;
    paramsDict[@"subject"] = @"技统一次套餐";
    
    [TSNetworkManger getWechatPaySign:paramsDict responseSuccess:^(id responseObject) {
//        DDLog(@"get order info return is:%@", responseObject);
        
        if ([responseObject[@"success"] isEqual:@1]) {
//            self.returnBlock(responseObject);
            if ([responseObject[@"entity"] count]) {
                [self p_gotoWeiXinPayRequestWithDict:responseObject];
            } else {
                [self errorCodeWithReason:@"支付失败"];
            }
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)p_gotoWeiXinPayRequestWithDict:(NSDictionary *)returnDict {
    NSDictionary *WXdic = returnDict[@"entity"];
    //调用TenPaySdk进行支付
    NSString *stamp = WXdic[@"timestamp"];
    
    //调起微信支付
    PayReq *request = [[PayReq alloc] init];
    request.openID = WXAppId_Pay;
    request.partnerId = WXPartnerId_Pay; // 商户号
    request.prepayId = WXdic[@"prepay_id"];
    request.nonceStr = WXdic[@"noncestr"];
    request.timeStamp = stamp.intValue;
    request.package = @"Sign=WXPay";
    request.sign = WXdic[@"sign"];
//    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
    
    //日志输出
    DDLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.openID, request.partnerId, request.prepayId, request.nonceStr, (long)request.timeStamp, request.package, request.sign);
}

#pragma mark - 支付宝支付 *************************************** start ******************************************
- (void)p_getAlipayOrderStringWithOrderId:(NSString *)orderId {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"orderId"] = orderId;
    paramsDict[@"subject"] = @"技统一次套餐";
    [TSNetworkManger getAlipayOrderString:paramsDict responseSuccess:^(id responseObject) {
//        DDLog(@"get aliPay order info is:%@", responseObject);
        if ([responseObject[@"success"] isEqual:@1]) {
            if ([responseObject[@"entity"] length]) {
                NSString *appScheme = @"alipaylongcaits";
                
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = [NSString stringWithFormat:@"%@", responseObject[@"entity"]];
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    DDLog(@"reslut = %@",resultDic);
                    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) { //支付成功
                        
                        
                        [self p_PostNotificationWithStatus:@"1"];
                    } else { // 支付失败
                        [self p_PostNotificationWithStatus:@"0"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            }
        } else {
            NSString *reason = @"请求失败";
            if (responseObject[@"reason"]) {
                reason = responseObject[@"reason"];
            }
            [self errorCodeWithReason:reason];
        }
    } responseFailed:^(NSError *error) {
        [self netFailure];
    }];
}

- (void)p_PostNotificationWithStatus:(NSString *)status {
    [[NSNotificationCenter defaultCenter] postNotificationName:TSPaySuccessNotifName object:status];
}

#pragma 对ErrorCode进行处理
- (void)errorCodeWithReason:(NSString *)reason {
    self.errorBlock(reason);
}

#pragma 对网路异常进行处理
- (void)netFailure {
    self.failureBlock ? self.failureBlock() : nil;
}
@end
