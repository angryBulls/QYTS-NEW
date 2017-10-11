//
//  AccountSetCell.h
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditInfoCellModel;

@interface AccountSetCell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, weak) CAShapeLayer *bottomLine;
@property (nonatomic, strong) EditInfoCellModel *infoCellModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
