//
//  MyGameUnCheckCell.h
//  QYTS
//
//  Created by lxd on 2017/9/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyGameOverListModel;

@protocol MyGameUnCheckCellDelegate <NSObject>
@optional
- (void)getModelWithCheckBtnClick:(MyGameOverListModel *)gameOverListModel;
@end

@interface MyGameUnCheckCell : UITableViewCell
@property (nonatomic, weak) CAShapeLayer *bottomLine;
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, strong) MyGameOverListModel *gameOverListModel;
@property (nonatomic, weak) id<MyGameUnCheckCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
