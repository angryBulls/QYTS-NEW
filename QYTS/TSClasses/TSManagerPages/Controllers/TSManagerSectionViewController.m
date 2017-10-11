//
//  TSManagerSectionViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSManagerSectionViewController.h"
#import "TSPlayerDataCell.h"
#import "TSPlayerSectionView.h"
#import "CustomPickerView.h"
#import "TSPlayerModel.h"

@interface TSManagerSectionViewController () <TSPlayerSectionViewDelegate, TSPlayerDataCellDelegate>
@property (nonatomic, strong) TSPlayerSectionView *sectionViewH;
@property (nonatomic, strong) TSPlayerSectionView *sectionViewG;
@end

@implementation TSManagerSectionViewController
- (TSPlayerSectionView *)sectionViewH {
    if (!_sectionViewH) {
        _sectionViewH = [[TSPlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(38))];
        NSDictionary *gameCheckDict = [self.tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
        _sectionViewH.teamName = gameCheckDict[@"homeTeamName"];
        _sectionViewH.delegate = self;
    }
    return _sectionViewH;
}

- (TSPlayerSectionView *)sectionViewG {
    if (!_sectionViewG) {
        _sectionViewG = [[TSPlayerSectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(38))];
        NSDictionary *gameCheckDict = [self.tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable];
        _sectionViewG.teamName = gameCheckDict[@"awayTeamName"];
        _sectionViewG.delegate = self;
    }
    return _sectionViewG;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupTopView];
    
    [self p_createTableView];
    
    [self p_setupHostPlayerData]; // 设置主队球员数据
    
    [self p_setupGuestPlayerData]; // 设置客队球员数据
}

- (void)p_setupTopView {
    [self addTopViewWithPageType:PageTypeSection];
    self.topView.gameModel = self.gameModel;
    self.topView.currentSecond = self.currentSecond;
}

- (void)p_setupHostPlayerData {
    NSArray *playerArrayH = [self.tSDBManager getObjectById:TeamCheckID_H fromTable:TSCheckTable];
    NSArray *playerModelArrayH = [TSPlayerModel mj_objectArrayWithKeyValuesArray:playerArrayH];
    
    NSMutableArray *hostPlayerDataArray = [NSMutableArray array];
    [playerModelArrayH enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *playerDataDict = [self.tSDBManager getObjectById:playerModel.ID fromTable:PlayerTable];
        NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
        
        NSDictionary *stagePlayerDataDict = playerDataDict[stageCount];
        if (!stagePlayerDataDict) {
            stagePlayerDataDict = @{};
        }
        TSManagerPlayerModel *tPlayerModel = [TSManagerPlayerModel mj_objectWithKeyValues:stagePlayerDataDict];
        tPlayerModel.playerId = playerModel.ID;
        tPlayerModel.playerName = playerModel.name;
        tPlayerModel.playerNumber = playerModel.gameNum;
        tPlayerModel.photo = playerModel.photo;
        tPlayerModel.changeStatus = NO;
        
        [hostPlayerDataArray addObject:tPlayerModel];
    }];
    self.hostPlayerDataArray = hostPlayerDataArray;
//    DDLog(@"所有主队球员的统计数据为:%@", self.hostPlayerDataArray);
}

- (void)p_setupGuestPlayerData {
    NSArray *playerArrayG = [self.tSDBManager getObjectById:TeamCheckID_G fromTable:TSCheckTable];
    NSArray *playerModelArrayG = [TSPlayerModel mj_objectArrayWithKeyValuesArray:playerArrayG];
    
    NSMutableArray *guestPlayerDataArray = [NSMutableArray array];
    [playerModelArrayG enumerateObjectsUsingBlock:^(TSPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *playerDataDict = [self.tSDBManager getObjectById:playerModel.ID fromTable:PlayerTable];
        NSString *stageCount = [self.tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
        
        NSDictionary *stagePlayerDataDict = playerDataDict[stageCount];
        if (!stagePlayerDataDict) {
            stagePlayerDataDict = @{};
        }
        TSManagerPlayerModel *tPlayerModel = [TSManagerPlayerModel mj_objectWithKeyValues:stagePlayerDataDict];
        tPlayerModel.playerId = playerModel.ID;
        tPlayerModel.playerName = playerModel.name;
        tPlayerModel.playerNumber = playerModel.gameNum;
        tPlayerModel.photo = playerModel.photo;
        tPlayerModel.changeStatus = NO;
        
        [guestPlayerDataArray addObject:tPlayerModel];
    }];
    self.guestPlayerDataArray = guestPlayerDataArray;
//    DDLog(@"所有客队球员的统计数据为:%@", self.guestPlayerDataArray);
}

- (void)p_createTableView {
    CGFloat tableViewX = 0;
    CGFloat tableViewY = CGRectGetMaxY(self.topView.frame) + H(8);
    CGFloat tableViewW = self.view.width;
    CGFloat tableViewH = SCREEN_HEIGHT - tableViewY - H(58);
    self.tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    self.tableView.rowHeight = H(94.5);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.hostPlayerDataArray.count;
    } else if (1 == section) {
        return self.guestPlayerDataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPlayerDataCell *cell = [TSPlayerDataCell cellWithTableView:tableView];
    if (0 == indexPath.section) {
        cell.playerModel = self.hostPlayerDataArray[indexPath.row];
    } else if (1 == indexPath.section) {
        cell.playerModel = self.guestPlayerDataArray[indexPath.row];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        self.sectionViewH.teamType = @"主队：";
        
        return self.sectionViewH;
    } else if (1 == section) {
        self.sectionViewG.teamType = @"客队：";
        
        return self.sectionViewG;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return H(38);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(11.5))];
    footView.backgroundColor = self.view.backgroundColor;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return H(11.5);
}

#pragma mark - TSPlayerSectionViewDelegate
- (void)changeBtnClick:(TSPlayerSectionView *)sectionView {
    if (sectionView == self.sectionViewH) {
        if (sectionView.changeBtn.selected) { // 开始修改主队本节数据
            [self.hostPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                tPlayerModel.changeStatus = YES;
            }];
        } else {  // 主队本节数据修改完成
            [self.hostPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                tPlayerModel.changeStatus = NO;
            }];
        }
    } else if (sectionView == self.sectionViewG) {
        if (sectionView.changeBtn.selected) { // 开始修改客队本节数据
            [self.guestPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                tPlayerModel.changeStatus = YES;
            }];
        } else {  // 客队本节数据修改完成
            [self.guestPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                tPlayerModel.changeStatus = NO;
            }];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - update game statistics method
- (void)p_updateStatisticsData {
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    [calculationTool calculationHostTotalScoreFouls];
    [calculationTool calculationGuestTotalScoreFouls];
    
    [calculationTool calculationHostStageScoreFouls];
    [calculationTool calculationGuestStageScoreFouls];
    
    [calculationTool calculationTimeOutSatgeData];
    
    self.topView.gameModel = calculationTool.gameModel;
    self.gameModel = calculationTool.gameModel;
    self.topView.gameModel = self.gameModel;
}
@end
