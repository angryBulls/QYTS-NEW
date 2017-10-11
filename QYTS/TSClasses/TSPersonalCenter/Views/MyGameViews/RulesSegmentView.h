//
//  RulesSegmentView.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(NSUInteger index);

typedef void (^TouchDownBtnRepeatBlock)(UIButton *btn);

@interface RulesSegmentView : UIView
@property (nonatomic, copy) TouchDownBtnRepeatBlock touchDownBtnRepeatBlock;

- (instancetype)initWithFrame:(CGRect)frame returnBlcok:(ReturnBlock)returnBlock;
@end
