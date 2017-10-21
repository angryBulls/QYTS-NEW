//
//  TSInstructionsView.h
//  QYTS
//
//  Created by lxd on 2017/8/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RuleType) {
    RuleType5V5,
    RuleType3X3
};

@interface TSInstructionsView : UIView
- (instancetype)initWithFrame:(CGRect)frame ruleType:(RuleType)ruleType;

- (void)show;
@end
