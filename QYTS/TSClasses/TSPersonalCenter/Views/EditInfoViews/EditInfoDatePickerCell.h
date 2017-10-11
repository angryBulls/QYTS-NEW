//
//  EditInfoDatePickerCell.h
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditInfoCellModel;

typedef NS_ENUM(NSUInteger, TextfieldInputView) {
    TextfieldInputViewTextField,
    TextfieldInputViewDatePicker
};

@interface EditInfoDatePickerCell : UITableViewCell
@property (nonatomic, strong) EditInfoCellModel *infoCellModel;
@property (nonatomic, assign) TextfieldInputView textfieldInputView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
