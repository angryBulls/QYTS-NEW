//
//  PersonalSegmentView.h
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonalInfoModel;

typedef NS_ENUM(NSInteger, StatusType) {
    StatusTypeOver,
    StatusTypeNoplay
};

typedef void (^SelectReturnBlock)(StatusType gameStatus);

@interface PersonalSegmentView : UIView
@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;

- (instancetype)initWithFrame:(CGRect)frame selectReturnBlock:(SelectReturnBlock)selectReturnBlock;
@end
