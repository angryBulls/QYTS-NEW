//
//  GameSelectViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "GameSelectViewController.h"
#import "UIImage+Extension.h"
#import "TSCreateGameHTViewController.h"
#import "UnCheckListViewController.h"
#import "CheckGameDataViewController.h"
#import "PersonalCenterViewController.h"

#define GameCreate @"我要创建比赛"
#define GameCheck @"我要检录比赛"

@interface GameSelectViewController ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@end

@implementation GameSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"选择比赛" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self createRightBarButtonWithImageName:@"personal_center_icon"];
    
    [self showNavgationBarBottomLine];
    
    [self p_addSubViews];
}

- (void)rightBarBtnClick {
    PersonalCenterViewController *centerVC = [[PersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:centerVC animated:YES];
}

- (void)p_addSubViews {
    CGFloat marginX = W(8);
    CGFloat bgViewW = self.view.width - 2*marginX;
    CGFloat bgViewH = H(260);
    CGFloat bgViewY = H(97);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(marginX, bgViewY, bgViewW, bgViewH)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    // add title
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:W(16.0)];
    titleLab.text = @"请选择";
    [titleLab sizeToFit];
    titleLab.y = H(36);
    titleLab.centerX = bgView.width*0.5;
    titleLab.textColor = TSHEXCOLOR(0xc1d6ff);
    [bgView addSubview:titleLab];
    
    // add bcbc button
    self.createBtn = [self p_createButtonWithTitle:GameCreate];
    self.createBtn.y = H(91);
    [self.createBtn addTarget:self action:@selector(createBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.createBtn];
    
    // add normal button
    self.checkBtn = [self p_createButtonWithTitle:GameCheck];
    self.checkBtn.y = CGRectGetMaxY(self.createBtn.frame) + H(30);
    [self.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.checkBtn];
}

- (void)createBtnClick:(UIButton *)btn {
    TSCreateGameHTViewController *createGameVC = [[TSCreateGameHTViewController alloc] init];
    [self.navigationController pushViewController:createGameVC animated:YES];
}

- (void)checkBtnClick:(UIButton *)btn {
//    CheckGameDataViewController *gameDataVC = [[CheckGameDataViewController alloc] init];
//    [self.navigationController pushViewController:gameDataVC animated:YES];
//    return;
    
    UnCheckListViewController *checkListVC = [[UnCheckListViewController alloc] init];
    [self.navigationController pushViewController:checkListVC animated:YES];
}

- (UIButton *)p_createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat marginX = W(28);
    CGFloat buttonW = self.bgView.width - 2*marginX;
    CGFloat buttonH = H(45);
    button.frame = CGRectMake(marginX, 0, buttonW, buttonH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = W(5);
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:W(17.0)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0x27395d) size:CGSizeMake(buttonW, buttonH)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(buttonW, buttonH)] forState:UIControlStateHighlighted];
    
    return button;
}
@end
