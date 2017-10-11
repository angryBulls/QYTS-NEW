//
//  TSManagerViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectPageType) {
    SelectPageTypeSection,
    SelectPageTypeFull
};

@class TSGameModel;

@interface TSManagerViewController : UIViewController
@property (nonatomic, assign) int currentSecond;

@property (nonatomic, assign) SelectPageType selectPageType;
@property (nonatomic, strong) TSDBManager *tSDBManager;
@property (nonatomic, strong) TSGameModel *gameModel;
@end
