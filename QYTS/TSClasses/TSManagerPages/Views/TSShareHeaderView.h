//
//  TSShareHeaderView.h
//  QYTS
//
//  Created by lxd on 2017/8/15.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSShareHeaderView : UIView
@property (nonatomic, strong) NSArray *hostPlayerDataArray;
@property (nonatomic, strong) NSArray *guestPlayerDataArray;

@property (nonatomic, copy) NSString *playerPhoto;
@property (nonatomic, copy) NSString *highScorePlayer;
@end
