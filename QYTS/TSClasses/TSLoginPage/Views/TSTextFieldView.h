//
//  TSTextFieldView.h
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TSTextFieldType) {
    TSTextFieldTypeName,
    TSTextFieldTypePhone,
    TSTextFieldTypePassword,
    TSTextFieldTypeAuth,
    TSTextFieldTypeDatePicker,
    TSTextFieldTypeInviteCode // 邀请码
};

typedef void (^TextFieldShouldReturnBlock)();
typedef void (^TextFieldBeginEditingBlock)();

@interface TSTextFieldView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) TextFieldBeginEditingBlock textFieldBeginEditingBlock;
@property (nonatomic, copy) TextFieldShouldReturnBlock textFieldShouldReturnBlock;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName placeholder:(NSString *)placeholder textfieldType:(TSTextFieldType)textfieldType;
@end
