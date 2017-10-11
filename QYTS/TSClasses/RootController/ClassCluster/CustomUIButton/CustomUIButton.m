//
//  CustomUIButton.m
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIButton.h"
#import "CustomUIButtonCircle.h"
#import "CustomUIButtonRound.h"
#import "CustomUIButtonEdit.h"

@implementation CustomUIButton
+ (CustomUIButton *)CustomUIButtonWithType:(CustomButtonType)buttonType {
    if (CustomButtonTypeCircle == buttonType) {
        return [CustomUIButtonCircle buttonWithType:UIButtonTypeCustom];
    } else if (CustomButtonTypeRound == buttonType) {
        return [CustomUIButtonRound buttonWithType:UIButtonTypeCustom];
    } else if (CustomButtonTypeEdit == buttonType) {
        return [CustomUIButtonEdit buttonWithType:UIButtonTypeCustom];
    }
    
    return nil;
}
@end
