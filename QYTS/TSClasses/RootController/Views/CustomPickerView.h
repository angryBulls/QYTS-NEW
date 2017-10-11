//
//  CustomPickerView.h
//  QYTS
//
//  Created by lxd on 2017/7/17.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerViewType) {
    PickerViewTypeName,
    PickerViewTypeColor
};

typedef void (^SelectRowDataReturnBlock)(id returnValue);

typedef void (^DismissReturnBlock)(id returnValue);

@interface CustomPickerView : UIView
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, copy) NSString *checkRepeatValue;

- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)pickerViewType valueArray:(NSArray *)valueArray returnValue:(SelectRowDataReturnBlock)returnValueBlock dismissReturnBlock:(DismissReturnBlock)dismissReturnBlock;
- (void)show;
@end
