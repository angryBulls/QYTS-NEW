//
//  PersonalHeaderView.h
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonalInfoModel;

@protocol PersonalHeaderViewDelegate <NSObject>
@optional
- (void)gameStatusSelect:(int)statusType;
@end

@interface PersonalHeaderView : UIView
@property (nonatomic, weak) id<PersonalHeaderViewDelegate> delegate;
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;
@end
