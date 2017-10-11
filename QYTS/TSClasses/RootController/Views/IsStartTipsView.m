//
//  IsStartTipsView.m
//  QYTS
//
//  Created by lxd on 2017/8/8.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "IsStartTipsView.h"

@implementation IsStartTipsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add cover view
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    [self addSubview:cover];
    
    // add read button
    CGFloat readBtnW = W(184);
    CGFloat readBtnH = H(54);
    CGFloat readBtnX = (SCREEN_WIDTH - readBtnW)*0.5;
    CGFloat readBtnY = SCREEN_HEIGHT - H(120.5) - readBtnH;
    
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(readBtnX, readBtnY, readBtnW, readBtnH);
    readBtn.layer.masksToBounds = YES;
    readBtn.layer.cornerRadius = W(10);
    readBtn.layer.borderWidth = 1.0;
    readBtn.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    readBtn.titleLabel.font = [UIFont systemFontOfSize:W(18)];
    [readBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [readBtn setTitleColor:TSHEXCOLOR(0xf1f6ff) forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(p_readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:readBtn];
    
    // add button bg view
    CGFloat bgViewW = W(97);
    CGFloat bgViewH = H(47);
    CGFloat bgViewX = 0;
    CGFloat bgViewY = 64 + H(36.5);
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeBCBC || currentUserType == LoginUserTypeCBO) {
        bgViewX = SCREEN_WIDTH - bgViewW - W(4);
    } else if (currentUserType == LoginUserTypeNormal) {
        bgViewX = SCREEN_WIDTH - bgViewW - W(20);
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(10);
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    // add arrow image
    UIImage *image = [UIImage imageNamed:@"isStart_arrow_Image"];
    CGFloat arrowImageViewW = W(51.5);
    CGFloat arrowImageViewH = H(35);
    CGFloat arrowImageViewX = bgView.x - arrowImageViewW - W(11);
    CGFloat arrowImageViewY = CGRectGetMaxY(bgView.frame) - arrowImageViewH + H(3);
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowImageViewX, arrowImageViewY, arrowImageViewW, arrowImageViewH)];
    arrowImageView.image = image;
    [self addSubview:arrowImageView];
    
    // add label1
    CGFloat titleLab1W = W(120);
    CGFloat titleLab1H = H(16);
    CGFloat titleLab1Y = CGRectGetMaxY(arrowImageView.frame) + H(8.5);
    UILabel *titleLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLab1Y, titleLab1W, titleLab1H)];
    titleLab1.centerX = arrowImageView.centerX - W(10);
    titleLab1.text = @"首发球员点击";
    titleLab1.font = [UIFont systemFontOfSize:W(14.0)];
    titleLab1.textColor = TSHEXCOLOR(0xffffff);
    titleLab1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab1];
    
    // add label2
    CGFloat titleLab2W = W(120);
    CGFloat titleLab2H = H(16);
    CGFloat titleLab2Y = CGRectGetMaxY(titleLab1.frame);
    UILabel *titleLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLab2Y, titleLab2W, titleLab2H)];
    titleLab2.centerX = titleLab1.centerX;
    titleLab2.text = @"“是”“否”进行切换";
    titleLab2.font = [UIFont systemFontOfSize:W(14.0)];
    titleLab2.textColor = TSHEXCOLOR(0xffffff);
    titleLab2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab2];
}

- (void)p_readBtnClick:(UIButton *)readBtn {
    [self p_dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)p_dismiss {
    [self removeFromSuperview];
}
@end
