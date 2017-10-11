//
//  TSInstructionsView.m
//  QYTS
//
//  Created by lxd on 2017/8/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSInstructionsView.h"
#import "UIImage+Extension.h"

static NSString * const TitleLabelText = @"语音技统使用说明";

@interface TSInstructionsView ()
@property (nonatomic, assign) RuleType ruleType;
@end

@implementation TSInstructionsView
- (instancetype)initWithFrame:(CGRect)frame ruleType:(RuleType)ruleType {
    if (self = [super initWithFrame:frame]) {
        _ruleType = ruleType;
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add cover
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    [self addSubview:cover];
    
    // add imageView
    CGFloat MarginX = W(25);
    UIImage *image = [UIImage imageNamed:@"statistics_disclaimer_image"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MarginX, H(60.5), self.width - 2*MarginX, self.height - H(102))];
    bgImageView.image = image;
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    // add title label
    CGFloat titleLabW = bgImageView.width;
    CGFloat titleLabH = H(58);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabW, titleLabH)];
    titleLab.text = TitleLabelText;
    titleLab.font = [UIFont boldSystemFontOfSize:W(17.0)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:titleLab];
    
    // add bg scroView
    CGFloat bgScrollViewX = W(20);
    CGFloat bgScrollViewY = titleLab.height;
    CGFloat bgScrollViewW = bgImageView.width - 2*bgScrollViewX;
    CGFloat bgScrollViewH = bgImageView.height - titleLab.height - H(85);
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bgScrollViewX, bgScrollViewY, bgScrollViewW, bgScrollViewH)];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [bgImageView addSubview:bgScrollView];
    
    // add content image
    UIImage *contentImage;
    if (RuleType3V3 == self.ruleType) {
        contentImage = [UIImage imageNamed:@"use_instructions_content_image"];
    } else if (RuleType5V5 == self.ruleType) {
        contentImage = [UIImage imageNamed:@"use_instructions_5v5_content_image"];
    }
    UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, H(10), bgScrollView.width, H(contentImage.size.height))];
    contentImageView.image = contentImage;
    [bgScrollView addSubview:contentImageView];
    bgScrollView.contentSize = CGSizeMake(bgScrollView.width, contentImageView.height + H(55));
    
    CGFloat okBtnX = W(60);
    CGFloat okBtnW = bgImageView.width - 2*okBtnX;
    CGFloat okBtnH = H(43);
    CGFloat okBtnY = bgImageView.height - okBtnH - H(22);
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(okBtnX, okBtnY, okBtnW, okBtnH);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:W(22.0)];
    [okBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(okBtn.width, okBtn.height)] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(okBtn.width, okBtn.height)] forState:UIControlStateHighlighted];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = okBtnH*0.5;
    [okBtn addTarget:self action:@selector(p_okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:okBtn];
}

- (void)p_okBtnClick {
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
