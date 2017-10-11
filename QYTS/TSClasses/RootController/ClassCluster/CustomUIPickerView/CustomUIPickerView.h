//
//  CustomUIPickerView.h
//  QYTS
//
//  Created by lxd on 2017/9/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomPickViewType) {
    CustomPickViewTypeNormal,
    CustomPickViewTypeScore
};

typedef void (^DidSelectValueReturnBlock)(NSString *firstSelectValue, NSString *secondSelectValue);

@interface CustomUIPickerView : UIView
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, strong) NSArray *defaultValueArray;

+ (CustomUIPickerView *)CustomUIPickViewWithType:(CustomPickViewType)pickViewType frame:(CGRect)frame;

- (void)show;

@property (nonatomic, copy) DidSelectValueReturnBlock didSelectValueReturnBlock;
@end
