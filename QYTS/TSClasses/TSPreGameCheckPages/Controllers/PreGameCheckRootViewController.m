//
//  PreGameCheckRootViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PreGameCheckRootViewController.h"
#import "UIImage+Extension.h"

@interface PreGameCheckRootViewController ()

@end

@implementation PreGameCheckRootViewController
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBeginEditing:) name:@"UITextFieldTextDidBeginEditingNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:@"UITextFieldTextDidEndEditingNotification" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"赛前检录" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self showNavgationBarBottomLine];
}

- (UIView *)createBgViewWithFrame:(CGRect)frame {
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    
    return bgView;
}

- (DropDownButton *)createDropDownWithFrame:(CGRect)frame titleName:(NSString *)titleName {
    DropDownButton *dpBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    dpBtn.frame = frame;
    [dpBtn setTitle:titleName forState:UIControlStateNormal];
    [dpBtn setImage:[UIImage imageNamed:@"dropDown_Icon"] forState:UIControlStateNormal];
    
    return dpBtn;
}

- (void)dpBtnClick:(DropDownButton *)dpBtn {
    [self.view endEditing:YES];
    [dpBtn.imageView animationWithDuration:0.5 angle:M_PI];
}

- (UILabel *)createTitleLabelWithFrame:(CGRect)frame titleName:(NSString *)titleName {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:frame];
    titleLab.text = titleName;
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    
    return titleLab;
}

- (void)setupTextfieldStyle:(TSTextFieldView *)textFieldView {
    textFieldView.backgroundColor = TSHEXCOLOR(0x27395d);
    textFieldView.layer.borderWidth = 1;
    textFieldView.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    textFieldView.textField.textColor = TSHEXCOLOR(0xbfd4ff);
}

- (void)createSubmitButtonWithTile:(NSString *)submitTitle buttonY:(CGFloat)buttonY {
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat MarginX = W(25);
    CGFloat submitBtnH = H(43);
    CGFloat submitBtnY = buttonY;
    CGFloat submitBtnW = self.view.width - 2*MarginX;
    
    submitBtn.frame = CGRectMake(MarginX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn setTitle:submitTitle forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [submitBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(submitBtnW, submitBtnH)] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(submitBtnW, submitBtnH)] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = submitBtnH*0.5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)submitBtnClick {
    // subclass rewrite;
}

- (void)textFieldBeginEditing:(NSNotification *)obj {
    // subclass rewrite;
}

- (void)textFieldDidEndEditing:(NSNotification *)obj {
    // subclass rewrite;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
