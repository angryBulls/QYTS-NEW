//
//  MyGameOverCell.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyGameOverListModel;

@protocol MyGameOverCellDelegate <NSObject>
@optional
- (void)shareAction:(MyGameOverListModel *)gameOverListModel;
@end

@interface MyGameOverCell : UITableViewCell
@property (nonatomic, weak) CAShapeLayer *bottomLine;
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, strong) MyGameOverListModel *gameOverListModel;
@property (nonatomic, weak) id<MyGameOverCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
