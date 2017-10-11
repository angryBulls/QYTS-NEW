//
//  CheckGameDataViewController.m
//  QYTS
//
//  Created by lxd on 2017/8/23.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CheckGameDataViewController.h"
#import "MJRefresh.h"
#import "TSGameDataCell.h"
#import "GameDataViewModel.h"

@interface CheckGameDataViewController ()
@property (nonatomic, strong) NSMutableArray *gameDataArray;
@end

@implementation CheckGameDataViewController
- (NSMutableArray *)gameDataArray {
    if (!_gameDataArray) {
        _gameDataArray = @[].mutableCopy;
    }
    return _gameDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"查看比赛" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self showNavgationBarBottomLine];
    
    [self p_setupTableView];
}

- (void)p_setupTableView {
    [self.view addSubview:self.tableView];
    
    TSWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [__weakSelf p_getNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [__weakSelf p_loadMoreData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.rowHeight = H(50);
}

- (void)p_getNetworkData {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"pageIndex"] = @0;
    paramsDict[@"pageSize"] = @10;
    GameDataViewModel *gameDataViewModel = [[GameDataViewModel alloc] initWithPramasDict:paramsDict];
    [gameDataViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"matchList returnValue is:%@", returnValue);
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [gameDataViewModel getUserHistoryMatchList];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

- (void)p_loadMoreData {
    for (int i = 0; i < 5; i ++) {
        [self.gameDataArray addObject:[NSString stringWithFormat:@"第 %d Cell", i]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (self.gameDataArray.count > 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    });
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gameDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSGameDataCell *cell = [TSGameDataCell cellWithTableView:tableView];
    cell.testTitle = self.gameDataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
