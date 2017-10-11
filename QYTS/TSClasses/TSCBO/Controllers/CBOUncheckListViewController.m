//
//  CBOUncheckListViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CBOUncheckListViewController.h"
#import "MJRefresh.h"
#import "CBOViewModel.h"
#import "TSNoGameTipsView.h"
#import "MyGameUnCheckCell.h"
#import "PreGameCheckCBOViewController.h"

@interface CBOUncheckListViewController () <MyGameUnCheckCellDelegate>
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *cboUncheckModelArray;
@property (nonatomic, strong) TSNoGameTipsView *noGameTipsView;
@end

@implementation CBOUncheckListViewController
#pragma mark - lazy method
- (TSNoGameTipsView *)noGameTipsView {
    if (!_noGameTipsView) {
        CGFloat noGameTipsViewW = W(240);
        CGFloat noGameTipsViewH = H(160);
        _noGameTipsView = [[TSNoGameTipsView alloc] initWithFrame:CGRectMake(0, 0, noGameTipsViewW, noGameTipsViewH)];
        _noGameTipsView.centerX = SCREEN_WIDTH*0.5;
        _noGameTipsView.centerY = (self.view.height - noGameTipsViewH)*0.5;
        _noGameTipsView.dataType = DataTypeCheck;
        [self.view addSubview:_noGameTipsView];
    }
    return _noGameTipsView;
}

- (NSMutableArray *)cboUncheckModelArray {
    if (!_cboUncheckModelArray) {
        _cboUncheckModelArray = [NSMutableArray array];
    }
    return _cboUncheckModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"检录比赛（CBO）" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    self.pageIndex = 1;
    
    [self p_initTableView];
}

- (void)p_initTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64 + 9.5, self.view.width, self.view.height - 64 - 9.5);
    self.tableView.rowHeight = H(72);
    
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
    CBOViewModel *cboViewModel = [[CBOViewModel alloc] initWithPramasDict:paramsDict];
    [cboViewModel setBlockWithReturnBlock:^(id returnValue) {
        if (0 == refreshType) {
            [self.cboUncheckModelArray removeAllObjects];
        }
        
        [self.cboUncheckModelArray addObjectsFromArray:returnValue];
        
        if (self.cboUncheckModelArray.count) {
            self.noGameTipsView.hidden = YES;
        } else {
            self.noGameTipsView.hidden = NO;
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
    [cboViewModel cboFindMatchAndTeamInfo];
}

#pragma mark - UITableView delegate *****************************************************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cboUncheckModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGameUnCheckCell *cell = [MyGameUnCheckCell cellWithTableView:tableView];
    cell.gameOverListModel = self.cboUncheckModelArray[indexPath.row];
    if (0 == indexPath.row) {
        cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
    } else if (indexPath.row == self.cboUncheckModelArray.count - 1) {
        cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    } else {
        cell.rectCornerStyle = UIRectCornerAllCorners;
    }
    if (indexPath.row == self.cboUncheckModelArray.count - 1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    cell.delegate = self;
    
    return cell;
}

- (void)getModelWithCheckBtnClick:(MyGameOverListModel *)gameOverListModel {
    PreGameCheckCBOViewController *gameCheckCBOVC = [[PreGameCheckCBOViewController alloc] init];
    gameCheckCBOVC.gameOverListModel = gameOverListModel;
    [self.navigationController pushViewController:gameCheckCBOVC animated:YES];
}
@end
