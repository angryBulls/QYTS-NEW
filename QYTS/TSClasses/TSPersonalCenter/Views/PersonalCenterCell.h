//
//  PersonalCenterCell.h
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterCell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, strong) NSArray *contentArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
