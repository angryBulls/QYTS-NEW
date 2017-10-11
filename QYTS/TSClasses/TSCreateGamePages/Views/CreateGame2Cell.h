//
//  CreateGame2Cell.h
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateGame2Cell, TSCreateGameModel;

@protocol CreateGame2CellDelegate <NSObject>
@optional
- (void)textFieldBeginEditDelegate:(CreateGame2Cell *)cell;
@end

@interface CreateGame2Cell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;

@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;

@property (nonatomic, strong) TSCreateGameModel *createGameModel;

@property (nonatomic, strong) NSIndexPath *indexPath; // 用于控制页面y值根据键盘变化
@property (nonatomic, weak) id<CreateGame2CellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
