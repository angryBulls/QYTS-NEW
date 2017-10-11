//
//  PreGameCheckRootViewController.h
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSBaseViewController.h"
#import "DropDownButton.h"
#import "UIImageView+Extension.h"
#import "TSTextFieldView.h"
#import "TSPlayersCheckViewController.h"

@interface PreGameCheckRootViewController : TSBaseViewController
- (UIView *)createBgViewWithFrame:(CGRect)frame;
- (DropDownButton *)createDropDownWithFrame:(CGRect)frame titleName:(NSString *)titleName;
- (void)dpBtnClick:(DropDownButton *)dpBtn;
- (UILabel *)createTitleLabelWithFrame:(CGRect)frame titleName:(NSString *)titleName;
- (void)setupTextfieldStyle:(TSTextFieldView *)textFieldView;
- (void)textFieldBeginEditing:(NSNotification *)obj;
- (void)textFieldDidEndEditing:(NSNotification *)obj;
- (void)createSubmitButtonWithTile:(NSString *)submitTitle buttonY:(CGFloat)buttonY;
@end
