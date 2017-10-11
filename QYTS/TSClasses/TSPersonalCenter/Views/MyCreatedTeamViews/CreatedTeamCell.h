//
//  CreatedTeamCell.h
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreatedTeamInfoModel;

@interface CreatedTeamCell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, weak) CAShapeLayer *topLine;
@property (nonatomic, weak) CAShapeLayer *bottomLine;
@property (nonatomic, strong) CreatedTeamInfoModel *teamInfoModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
