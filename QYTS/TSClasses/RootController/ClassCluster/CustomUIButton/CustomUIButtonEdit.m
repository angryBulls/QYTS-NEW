//
//  CustomUIButtonEdit.m
//  QYTS
//
//  Created by lxd on 2017/9/28.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIButtonEdit.h"

@implementation CustomUIButtonEdit
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CustomUIButtonEdit *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.enabled = NO;
    
    return button;
}
@end
