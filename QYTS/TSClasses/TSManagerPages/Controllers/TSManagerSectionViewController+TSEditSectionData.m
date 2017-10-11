//
//  TSManagerSectionViewController+TSEditSectionData.m
//  QYTS
//
//  Created by lxd on 2017/9/28.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSManagerSectionViewController+TSEditSectionData.h"

@implementation TSManagerSectionViewController (TSEditSectionData)
#pragma mark - TSPlayerDataCellDelegate
- (void)changePlayerDataAction:(NSIndexPath *)indexPath dataType:(NSString *)dataType {
    TSManagerPlayerModel *playerModel = [[TSManagerPlayerModel alloc] init];
    
    if (0 == indexPath.section) { // 修改主队的数据
        playerModel = self.hostPlayerDataArray[indexPath.row];
    } else if (1 == indexPath.section) { // 修改客队的数据
        playerModel = self.guestPlayerDataArray[indexPath.row];
    }
    
    NSMutableArray *defaultValueArray = [NSMutableArray array];
    if ([dataType isEqualToString:FreeThrowHit]) { // 罚篮
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.FreeThrowHit.intValue]];
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.behaviorNumb1.intValue]];
    }
    
    if ([dataType isEqualToString:OnePointsHit]) { // 一分
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.OnePointsHit.intValue]];
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.behaviorNumb31.intValue]];
    }
    
    if ([dataType isEqualToString:TwoPointsHit]) { // 两分
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.TwoPointsHit.intValue]];
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.behaviorNumb2.intValue]];
    }
    
    if ([dataType isEqualToString:ThreePointsHit]) { // 三分
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.ThreePointsHit.intValue]];
        [defaultValueArray addObject:[NSString stringWithFormat:@"%d", playerModel.behaviorNumb3.intValue]];
    }
    
    if (0 == defaultValueArray.count) { // 修改除得分外的统计数据
        if ([dataType isEqualToString:Assists]) {
            if (playerModel.behaviorNumb9) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb9]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
        if ([dataType isEqualToString:Steals]) {
            if (playerModel.behaviorNumb6) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb6]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
        if ([dataType isEqualToString:BlockShots]) {
            if (playerModel.behaviorNumb8) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb8]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
        if ([dataType isEqualToString:Fouls]) {
            if (playerModel.behaviorNumb10) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb10]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
        if ([dataType isEqualToString:Turnover]) {
            if (playerModel.behaviorNumb7) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb7]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
        if ([dataType isEqualToString:OffensiveRebound]) {
            if (playerModel.behaviorNumb4) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb4]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
        if ([dataType isEqualToString:DefensiveRebound]) {
            if (playerModel.behaviorNumb5) {
                [defaultValueArray addObject:[NSString stringWithFormat:@"%@", playerModel.behaviorNumb5]];
            } else {
                [defaultValueArray addObject:@"0"];
            }
        }
    }
    
    CustomUIPickerView *pickView = [CustomUIPickerView CustomUIPickViewWithType:CustomPickViewTypeScore frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pickView.dataType = dataType;
    pickView.defaultValueArray = defaultValueArray;
    pickView.didSelectValueReturnBlock = ^(NSString *firstSelectValue, NSString *secondSelectValue) {
        DDLog(@"firstSelectValue:%@", firstSelectValue);
        DDLog(@"secondSelectValue:%@", secondSelectValue);
        id newDataType;
        id newValue;
        if ([dataType isEqualToString:FreeThrowHit]) { // 修改罚篮数据
            newDataType = @[FreeThrowHit, FreeThrow];
            newValue = @[firstSelectValue, secondSelectValue];
        } else if ([dataType isEqualToString:OnePointsHit]) { // 修改一分数据
            newDataType = @[OnePointsHit, OnePoints];
            newValue = @[firstSelectValue, secondSelectValue];
        } else if ([dataType isEqualToString:TwoPointsHit]) { // 修改两分数据
            newDataType = @[TwoPointsHit, TwoPoints];
            newValue = @[firstSelectValue, secondSelectValue];
        } else if ([dataType isEqualToString:ThreePointsHit]) { // 修改三分数据
            newDataType = @[ThreePointsHit, ThreePoints];
            newValue = @[firstSelectValue, secondSelectValue];
        } else {
            newDataType = dataType;
            newValue = firstSelectValue;
        }
        
        [self.tSDBManager updateDBPlayerTabelByPlayerId:playerModel.playerId dataType:newDataType newValue:newValue successReturnBlock:^{
            [self p_changeDataSuccessWithIndexPath:indexPath];
        }];
    };
    [pickView show];
}

- (void)p_changeDataSuccessWithIndexPath:(NSIndexPath *)indexPath {
    [self p_updateStatisticsData];
    if (0 == indexPath.section) { // 修改主队球员罚球命中数、2分命中数、3分命中数
        [self p_setupHostPlayerData]; // 重新设置主队球员数据
        [self.hostPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
            tPlayerModel.changeStatus = YES;
        }];
    } else if (1 == indexPath.section) {
        [self p_setupGuestPlayerData]; // 重新设置客队球员数据
        [self.guestPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *tPlayerModel, NSUInteger idx, BOOL * _Nonnull stop) {
            tPlayerModel.changeStatus = YES;
        }];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    // 通知语音识别页面，球员数据被修改
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayerDataDidChanged object:nil];
}
@end
