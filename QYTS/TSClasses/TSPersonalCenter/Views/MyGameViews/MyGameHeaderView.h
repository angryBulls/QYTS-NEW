//
//  MyGameHeaderView.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyGameOverModel;

typedef NS_ENUM(NSInteger, RulesSelect) {
    RulesSelect5V5,
    RulesSelect3X3
};

@protocol MyGameHeaderViewDelegate <NSObject>
@optional
- (void)gameRulesSelect:(RulesSelect)rulesSelect;
- (void)touchDownBtnRepeat:(UIButton *)repeatBtn;
@end

@interface MyGameHeaderView : UIView
@property (nonatomic, weak) id<MyGameHeaderViewDelegate> delegate;
@property (nonatomic, strong) MyGameOverModel *gameOverModel;
@end
