//
//  TSPlayerDataCell.h
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSManagerPlayerModel, TSPlayerDataCell;

@protocol TSPlayerDataCellDelegate <NSObject>
@optional
- (void)changePlayerDataAction:(NSIndexPath *)indexPath dataType:(NSString *)dataType;
@end

@interface TSPlayerDataCell : UITableViewCell
@property (nonatomic, strong) TSManagerPlayerModel *playerModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<TSPlayerDataCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
