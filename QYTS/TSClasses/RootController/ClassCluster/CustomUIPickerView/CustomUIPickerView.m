//
//  CustomUIPickerView.m
//  QYTS
//
//  Created by lxd on 2017/9/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIPickerView.h"
#import "CustomUIPickerViewScore.h"

@implementation CustomUIPickerView
+ (CustomUIPickerView *)CustomUIPickViewWithType:(CustomPickViewType)pickViewType frame:(CGRect)frame {
    if (CustomPickViewTypeScore == pickViewType) {
        return [[CustomUIPickerViewScore alloc] initWithFrame:frame];
    }
    
    return nil;
}

- (void)show {
    
}
@end
