//
//  VoiceStatisticsCell.h
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceStatisticsCell : UITableViewCell
@property (nonatomic, copy) NSString *titleName;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
