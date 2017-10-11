//
//  TSBaseTableViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSBaseViewController.h"

@interface TSBaseTableViewController : TSBaseViewController
@property (nonatomic, strong) UITableView *tableView;

- (void)scrollTableToFoot:(BOOL)animated;
- (void)scrollToTop;
- (void)scrollToBottom;
@end
