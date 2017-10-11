//
//  TSPayManagerView.h
//  QYTS
//
//  Created by lxd on 2017/8/16.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SelectPayType) {
    SelectPayTypeWeiXin,
    SelectPayTypeZhiFuBao
};

typedef void (^SelectPayTypeReturnBlock)(SelectPayType payType);
typedef void (^SelectPayTypeCanceledBlock)();

@interface TSPayManagerView : UIView
@property (nonatomic, copy) NSString *onceComboPrice;

- (instancetype)initWithFrame:(CGRect)frame selectPayTypeReturnBlock:(SelectPayTypeReturnBlock)selectPayTypeReturnBlock selectPayTypeCanceledBlock:(SelectPayTypeCanceledBlock)selectPayTypeCanceledBlock;
- (void)show;
@end
