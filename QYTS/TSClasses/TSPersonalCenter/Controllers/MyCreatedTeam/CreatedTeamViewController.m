//
//  CreatedTeamViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreatedTeamViewController.h"
#import "PersonalViewModel.h"
#import "MJRefresh.h"
#import "CreatedTeamCell.h"

@interface CreatedTeamViewController ()
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *createdModelArray;
@end

@implementation CreatedTeamViewController
#pragma mark - lazy method
- (NSMutableArray *)createdModelArray {
    if (!_createdModelArray) {
        _createdModelArray = [NSMutableArray array];
    }
    return _createdModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"创建过的球队" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    self.pageIndex = 1;
    
    [self p_initTableView];
}

- (void)p_initTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64 + 9.5, self.view.width, self.view.height - 64 - 9.5);
    self.tableView.rowHeight = H(49);
    
    TSWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [__weakSelf getNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [__weakSelf p_loadMoreData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getNetworkData { // 下拉刷新
    self.pageIndex = 1;
    [self p_getTeamInfoListFromSever:0];
}

- (void)p_loadMoreData {
    self.pageIndex ++;
    [self p_getTeamInfoListFromSever:1];
}

- (void)p_getTeamInfoListFromSever:(NSInteger)refreshType {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"pageIndex"] = @(self.pageIndex);
    paramsDict[@"pageSize"] = @(10);
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        if (0 == refreshType) {
            self.createdModelArray = returnValue;
        } else if (1 == refreshType) {
            [self.createdModelArray addObjectsFromArray:returnValue];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSArray *tempArray = returnValue;
        if (0 == tempArray.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    } WithErrorBlock:^(id errorCode) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    [personalViewModel getTeamInfoList];
}

#pragma mark - UITableView delegate *****************************************************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.createdModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreatedTeamCell *cell = [CreatedTeamCell cellWithTableView:tableView];
    cell.teamInfoModel = self.createdModelArray[indexPath.row];
    if (0 == indexPath.row) {
        cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
    } else if (indexPath.row == self.createdModelArray.count - 1) {
        cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    } else {
        cell.rectCornerStyle = UIRectCornerAllCorners;
    }
    
    if (0 == indexPath.row) {
        cell.topLine.hidden = YES;
    } else {
        cell.topLine.hidden = NO;
    }
    
    if (indexPath.row == self.createdModelArray.count - 1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}
@end
