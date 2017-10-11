//
//  PlayersCheckCell.h
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSPlayerModel;

@protocol PlayersCheckCellDelegate <NSObject>
@optional
- (void)reloadTableViewWithSection:(int)section;
@end

@interface PlayersCheckCell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, strong) TSPlayerModel *playerModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PlayersCheckCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
