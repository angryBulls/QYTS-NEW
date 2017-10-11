//
//  CustomUIButton.h
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomButtonType) {
    CustomButtonTypeCircle,
    CustomButtonTypeRound,
    CustomButtonTypeEdit
};

@interface CustomUIButton : UIButton
@property (nonatomic, copy) NSString *typeName; // 标记按钮类型

+ (CustomUIButton *)CustomUIButtonWithType:(CustomButtonType)buttonType;
@end
