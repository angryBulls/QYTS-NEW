//
//  EditInfoSignatureCell.h
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditInfoCellModel;

@interface EditInfoSignatureCell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, strong) EditInfoCellModel *infoCellModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
