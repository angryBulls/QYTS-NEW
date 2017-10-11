//
//  PlayersCheckHeaderView.h
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TeamType) {
    TeamTypeHost,
    TeamTypeGuest
};

@interface PlayersCheckHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame teamType:(TeamType)teamType;
@end
