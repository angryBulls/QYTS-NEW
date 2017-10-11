//
//  CreateGame3Cell.h
//  QYTS
//
//  Created by lxd on 2017/8/10.
//  Copyright © 2017年 longcai. All rights reserved.
//  带pickerView的cell

#import <UIKit/UIKit.h>

@class TSCreateGameModel;

@protocol CreateGame3CellDelegate <NSObject>
@optional
- (void)dpBtnDidShow;
- (void)getDpBtnSelectValue:(NSString *)selectValue;
@end

@interface CreateGame3Cell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, strong) TSCreateGameModel *createGameModel;
@property (nonatomic, weak) id<CreateGame3CellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
