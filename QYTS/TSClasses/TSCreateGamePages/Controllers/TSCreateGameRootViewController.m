//
//  TSCreateGameRootViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSCreateGameRootViewController.h"
#import "UIImage+Extension.h"

@interface TSCreateGameRootViewController ()

@end

@implementation TSCreateGameRootViewController
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:@"UITextFieldTextDidEndEditingNotification" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"创建比赛" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self showNavgationBarBottomLine];
}

- (void)setupTableViewWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = edgeInsets;
    self.tableView.rowHeight = H(54);
}

- (void)setupSubmitButtonWithTile:(NSString *)submitTitle {
    CGFloat bottomViewH = self.tableView.contentInset.bottom;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomViewH, self.view.width, bottomViewH)];
    bottomView.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:bottomView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat MarginX = W(25);
    CGFloat submitBtnH = H(43);
    CGFloat submitBtnY = (bottomView.height - submitBtnH)*0.5;
    CGFloat submitBtnW = bottomView.width - 2*MarginX;
    
    submitBtn.frame = CGRectMake(MarginX, submitBtnY, submitBtnW, submitBtnH);
    [submitBtn setTitle:submitTitle forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [submitBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(submitBtnW, submitBtnH)] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(submitBtnW, submitBtnH)] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = submitBtnH*0.5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitBtn];
}

- (void)submitBtnClick {
    // subclass rewrite;
}

- (UIView *)createPeopleLimitSectionHeaderView {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(38))];
    sectionView.backgroundColor = self.tableView.backgroundColor;
    
    CGFloat sectionLabX = W(11);
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(sectionLabX, 0, sectionView.width - sectionLabX, sectionView.height)];
    sectionLab.text = @"球员人数大于5人或者3人";
    sectionLab.font = [UIFont systemFontOfSize:W(13.0)];
    sectionLab.textColor = TSHEXCOLOR(0x425c8e);
    [sectionView addSubview:sectionLab];
    
    return sectionView;
}

- (UIView *)createAddMoreView {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(57))];
    sectionView.backgroundColor = self.tableView.backgroundColor;
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat moreBtnX = W(8);
    CGFloat moreBtnH = H(45);
    moreBtn.frame = CGRectMake(moreBtnX, sectionView.height - moreBtnH, sectionView.width - 2*moreBtnX, moreBtnH);
    [moreBtn setTitle:@"  添加更多" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
    [moreBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    moreBtn.backgroundColor = TSHEXCOLOR(0x27395d);
    moreBtn.layer.masksToBounds = YES;
    moreBtn.layer.cornerRadius = W(5);
    [moreBtn setImage:[UIImage imageNamed:@"addMore_Icon"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:moreBtn];
    
    return sectionView;
}

- (void)moreBtnClick {
    // subclass rewrite;
}

- (void)textFieldDidEndEditing:(NSNotification *)notif {
    if (self.view.y < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y += H(220);
        }];
    }
}


- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title {
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = frame;
    [submitBtn setTitle:title forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [submitBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(submitBtn.width, submitBtn.height)] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(submitBtn.width, submitBtn.height)] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = submitBtn.height*0.5;
    submitBtn.layer.masksToBounds = YES;
    
    return submitBtn;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
