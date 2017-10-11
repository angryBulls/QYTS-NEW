//
//  MyGameMainViewController.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSBaseViewController.h"

typedef NS_ENUM(NSInteger, MyGameMainDefaultVC) {
    MyGameMainDefaultVCGameOver,
    MyGameMainDefaultVCUnCheck
};

@interface MyGameMainViewController : TSBaseViewController
@property (nonatomic, assign) MyGameMainDefaultVC defaultVC;
@end
