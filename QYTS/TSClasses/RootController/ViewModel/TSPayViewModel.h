//
//  TSPayViewModel.h
//  QYTS
//
//  Created by lxd on 2017/8/17.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

typedef NS_ENUM(NSInteger, PayType) {
    PayTypeWXPay,
    PayTypeAliPay
};

@interface TSPayViewModel : ViewModelClass
@property (nonatomic) PayType payType;

- (instancetype)initWithParamsDict:(NSMutableDictionary *)paramasDict;

- (void)checkCBOAccountStatus;
- (void)checkNormalAccountStatus; // 检查该普通用户的账户状态
- (void)checkBCBCAccountStatus; // 检查BCBC用户账户状态
- (void)getPayOrderId;
- (void)getOnceCombo;
@end
