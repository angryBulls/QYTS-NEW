//
//  FullGameTableHeadView.h
//  QYTS
//
//  Created by lxd on 2017/7/26.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSGameModel;

@interface FullGameTableHeadView : UIView
@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, strong) TSGameModel *gameModel;
@end
