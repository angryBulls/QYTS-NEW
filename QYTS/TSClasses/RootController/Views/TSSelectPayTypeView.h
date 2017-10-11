//
//  TSSelectPayTypeView.h
//  QYTS
//
//  Created by lxd on 2017/8/16.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeWeiXin,
    PayTypeZhiFuBao
};

typedef void (^SelectReturnBlock)(BOOL selectStatus);

@interface TSSelectPayTypeView : UIView
@property (nonatomic, weak) UIButton *selectPayBtn;

- (instancetype)initWithFrame:(CGRect)frame payType:(PayType)payType  selectReturnBlock:(SelectReturnBlock)selectReturnBlock;
@end
