//
//  MyGameUnCheckViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MyGameUnCheckViewController.h"
#import "MyGameHeaderView.h"
#import "MyGameUnCheckCell.h"
#import "MJRefresh.h"
#import "GameDataViewModel.h"
#import "MyGameOverModel.h"
#import "GameCheckViewModel.h"
#import "PreGameCheckNormalViewController.h"
#import "TSNoGameTipsView.h"

@interface MyGameUnCheckViewController () <UITableViewDelegate, UITableViewDataSource, MyGameHeaderViewDelegate, MyGameUnCheckCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TSNoGameTipsView *noGameTipsView;
@property (nonatomic, weak) MyGameHeaderView *headerView;
@property (nonatomic, assign) RulesSelect rulesSelect; // 赛制  0:5V5   1:3X3
@property (nonatomic, strong) NSMutableArray *game5DataArray;
@property (nonatomic, strong) NSMutableArray *game3DataArray;
@property (nonatomic, assign) NSInteger game5PageIndex;
@property (nonatomic, assign) NSInteger game3PageIndex;
@end

@implementation MyGameUnCheckViewController
#pragma mark - Lazy Method ********************************************************************************
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = TSHEXCOLOR(0x1b2a47);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = H(72);
    }
    return _tableView;
}

- (TSNoGameTipsView *)noGameTipsView {
    if (!_noGameTipsView) {
        CGFloat noGameTipsViewW = W(240);
        CGFloat noGameTipsViewH = H(160);
        _noGameTipsView = [[TSNoGameTipsView alloc] initWithFrame:CGRectMake(0, 0, noGameTipsViewW, noGameTipsViewH)];
        _noGameTipsView.centerX = SCREEN_WIDTH*0.5;
        _noGameTipsView.centerY = (self.view.height - noGameTipsViewH)*0.5 + H(50);
        _noGameTipsView.dataType = DataTypeCheck;
        [self.view addSubview:_noGameTipsView];
    }
    return _noGameTipsView;
}

- (NSMutableArray *)game5DataArray {
    if (!_game5DataArray) {
        _game5DataArray = @[].mutableCopy;
    }
    return _game5DataArray;
}

- (NSMutableArray *)game3DataArray {
    if (!_game3DataArray) {
        _game3DataArray = @[].mutableCopy;
    }
    return _game3DataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initHeaderView];
    
    [self p_initTableView];
}

- (void)p_initHeaderView {
    CGFloat headerViewX = 0;
    CGFloat headerViewY = H(40);
    CGFloat headerViewW = self.view.width;
    CGFloat headerViewH = H(126);
    MyGameHeaderView *headerView = [[MyGameHeaderView alloc] initWithFrame:CGRectMake(headerViewX, headerViewY, headerViewW, headerViewH)];
    headerView.delegate = self;
    [self.view addSubview:headerView];
    self.headerView = headerView;
}

- (void)p_initTableView {
    self.game5PageIndex = 1;
    self.game3PageIndex = 1;
    self.rulesSelect = RulesSelect5V5;
    
    [self.view addSubview:self.tableView];
    CGFloat tableViewY = CGRectGetMaxY(self.headerView.frame) + H(9);
    self.tableView.frame = CGRectMake(0, tableViewY, self.view.width, self.view.height - tableViewY - H(98) - 64);
    
    TSWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [__weakSelf getNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [__weakSelf p_loadMoreData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getNetworkData { // 下拉刷新
    if (RulesSelect5V5 == self.rulesSelect) {
        self.game5PageIndex = 1;
    } else if (RulesSelect3X3 == self.rulesSelect) {
        self.game3PageIndex = 1;
        
    }
    
    [self p_getDataFromSeviceWithRefreshType:0];
}

- (void)p_loadMoreData { // 上拉加载
    if (RulesSelect5V5 == self.rulesSelect) {
        self.game5PageIndex ++;
    } else if (RulesSelect3X3 == self.rulesSelect) {
        self.game3PageIndex ++;
        
    }
    
    [self p_getDataFromSeviceWithRefreshType:1];
}

- (void)p_getDataFromSeviceWithRefreshType:(NSInteger)refreshType {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if (RulesSelect5V5 == self.rulesSelect) {
        paramsDict[@"pageIndex"] = @(self.game5PageIndex);
        paramsDict[@"ruleType"] = @1;
    } else if (RulesSelect3X3 == self.rulesSelect) {
        paramsDict[@"pageIndex"] = @(self.game3PageIndex);
        paramsDict[@"ruleType"] = @2;
    }
    
    paramsDict[@"pageSize"] = @10;
    GameDataViewModel *gameDataViewModel = [[GameDataViewModel alloc] initWithPramasDict:paramsDict];
    [gameDataViewModel setBlockWithReturnBlock:^(id returnValue) {
        //        DDLog(@"gameOverModel returnValue is:%@", returnValue);
        MyGameOverModel *gameOverModel = returnValue;
        self.headerView.gameOverModel = gameOverModel;
        if (RulesSelect5V5 == self.rulesSelect) {
            if (0 == refreshType) {
                [self.game5DataArray removeAllObjects];
            }
            [self.game5DataArray addObjectsFromArray:gameOverModel.matchList];
            
            if (self.game5DataArray.count) {
                self.noGameTipsView.hidden = YES;
            } else {
                self.noGameTipsView.hidden = NO;
            }
        } else if (RulesSelect3X3 == self.rulesSelect) {
            if (0 == refreshType) {
                [self.game3DataArray removeAllObjects];
            }
            [self.game3DataArray addObjectsFromArray:gameOverModel.matchList];
            if (self.game3DataArray.count) {
                self.noGameTipsView.hidden = YES;
            } else {
                self.noGameTipsView.hidden = NO;
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } WithErrorBlock:^(id errorCode) {
        if (RulesSelect5V5 == self.rulesSelect && 0 == refreshType) {
            [self.game5DataArray removeAllObjects];
            self.noGameTipsView.hidden = NO;
        } else if (RulesSelect3X3 == self.rulesSelect && 0 == refreshType) {
            [self.game3DataArray removeAllObjects];
            self.noGameTipsView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    [gameDataViewModel getMatchAndTeamInfoNormal];
}

#pragma mark - UITableView delegate *****************************************************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (RulesSelect5V5 == self.rulesSelect) {
        return self.game5DataArray.count;
    }
    
    return self.game3DataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGameUnCheckCell *cell = [MyGameUnCheckCell cellWithTableView:tableView];
    if (RulesSelect5V5 == self.rulesSelect) {
        cell.gameOverListModel = self.game5DataArray[indexPath.row];
        if (0 == indexPath.row) {
            cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
        } else if (indexPath.row == self.game5DataArray.count - 1) {
            cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } else {
            cell.rectCornerStyle = UIRectCornerAllCorners;
        }
        if (indexPath.row == self.game5DataArray.count - 1) {
            cell.bottomLine.hidden = YES;
        } else {
            cell.bottomLine.hidden = NO;
        }
    } else if (RulesSelect3X3 == self.rulesSelect) {
        cell.gameOverListModel = self.game3DataArray[indexPath.row];
        if (0 == indexPath.row) {
            cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
        } else if (indexPath.row == self.game3DataArray.count - 1) {
            cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } else {
            cell.rectCornerStyle = UIRectCornerAllCorners;
        }
        if (indexPath.row == self.game3DataArray.count - 1) {
            cell.bottomLine.hidden = YES;
        } else {
            cell.bottomLine.hidden = NO;
        }
    }
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MyGameHeaderViewDelegate
- (void)gameRulesSelect:(RulesSelect)rulesSelect {
    self.rulesSelect = rulesSelect;
    
    if (RulesSelect3X3 == rulesSelect) {
        if (0 == self.game3DataArray.count) {
            [self getNetworkData];
            return;
        }
    }
    
    [self.tableView reloadData];
    
    if ((RulesSelect5V5 == self.rulesSelect)) {
        if (0 == self.game5DataArray.count) {
            self.noGameTipsView.hidden = NO;
        } else {
            self.noGameTipsView.hidden = YES;
        }
    }
    
    if ((RulesSelect3X3 == self.rulesSelect)) {
        if (0 == self.game3DataArray.count) {
            self.noGameTipsView.hidden = NO;
        } else {
            self.noGameTipsView.hidden = YES;
        }
    }
}

- (void)touchDownBtnRepeat:(UIButton *)repeatBtn { // repeat btn refresh data
    [self.tableView.mj_header beginRefreshing];
    [self getNetworkData];
}

#pragma mark - MyGameUnCheckCellDelegate
- (void)getModelWithCheckBtnClick:(MyGameOverListModel *)gameOverListModel {
    PreGameCheckNormalViewController *gameCheckVC = [[PreGameCheckNormalViewController alloc] init];
    gameCheckVC.gameOverListModel = gameOverListModel;
    [self.navigationController pushViewController:gameCheckVC animated:YES];
}
@end
