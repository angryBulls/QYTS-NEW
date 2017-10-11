//
//  TSCreateGameRootViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSBaseTableViewController.h"
#import "CreateGame1Cell.h"
#import "CreateGame2Cell.h"

@interface TSCreateGameRootViewController : TSBaseTableViewController
- (void)setupTableViewWithEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)setupSubmitButtonWithTile:(NSString *)submitTitle;
- (UIView *)createPeopleLimitSectionHeaderView;
- (UIView *)createAddMoreView;
- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title;
@end
