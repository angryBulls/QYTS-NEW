//
//  CreateGame1Cell.h
//  QYTS
//
//  Created by lxd on 2017/7/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSCreateGameModel;

typedef NS_ENUM(NSUInteger, TextfieldInputView) {
    TextfieldInputViewTextField,
    TextfieldInputViewDatePicker
};

@protocol CreateGame1CellDelegate <NSObject>
@optional
- (void)textfieldReturn;
@end

@interface CreateGame1Cell : UITableViewCell
@property (nonatomic, assign) UIRectCorner rectCornerStyle;
@property (nonatomic, assign) TextfieldInputView textfieldInputView;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, strong) TSCreateGameModel *createGameModel;
@property (nonatomic, weak) id<CreateGame1CellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
