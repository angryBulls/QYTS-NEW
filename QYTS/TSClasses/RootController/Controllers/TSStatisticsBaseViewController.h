//
//  TSStatisticsBaseViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceStatisticsTopView.h"

@interface TSStatisticsBaseViewController : UIViewController
@property (nonatomic, weak) VoiceStatisticsTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)scrollTableToFoot:(BOOL)animated;

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title;

- (void)addTopViewWithPageType:(PageType)pageType;
@end
