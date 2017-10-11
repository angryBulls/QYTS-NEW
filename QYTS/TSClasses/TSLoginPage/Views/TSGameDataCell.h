//
//  TSGameDataCell.h
//  QYTS
//
//  Created by lxd on 2017/8/23.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSGameDataCell : UITableViewCell
@property (nonatomic, copy) NSString *testTitle;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
