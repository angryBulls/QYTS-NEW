//
//  TSManagerSectionViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSStatisticsBaseViewController.h"
#import "TSManagerPlayerModel.h"
#import "CustomUIPickerView.h"

@class TSGameModel;

@interface TSManagerSectionViewController : TSStatisticsBaseViewController
@property (nonatomic, assign) int currentSecond;

@property (nonatomic, strong) TSDBManager *tSDBManager;
@property (nonatomic, strong) TSGameModel *gameModel;

@property (nonatomic, strong) NSMutableArray *hostPlayerDataArray;
@property (nonatomic, strong) NSMutableArray *guestPlayerDataArray;

- (void)p_updateStatisticsData;
- (void)p_setupHostPlayerData;
- (void)p_setupGuestPlayerData;
@end
