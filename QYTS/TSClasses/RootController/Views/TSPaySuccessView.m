//
//  TSPaySuccessView.m
//  QYTS
//
//  Created by lxd on 2017/8/17.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPaySuccessView.h"

@implementation TSPaySuccessView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add cover
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.6;
    [self addSubview:cover];
    
    // add bg imageView
    UIImage *image = [UIImage imageNamed:@"pay_success_bg_image"];
    CGFloat bgImageViewX = W(23);
    CGFloat bgImageViewW = self.width - 2*bgImageViewX;
    CGFloat bgImageViewH = H(85);
    CGFloat bgImageViewY = self.height - bgImageViewH - H(176);
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    bgImageView.image = image;
    [self addSubview:bgImageView];
    
    // add tips label
    UILabel *payTipsLab = [[UILabel alloc] initWithFrame:bgImageView.bounds];
    payTipsLab.text = @"您已购买成功即将进入语音操作页…";
    payTipsLab.font = [UIFont systemFontOfSize:W(15.0)];
    payTipsLab.textColor = TSHEXCOLOR(0x73ceff);
    payTipsLab.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:payTipsLab];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}
@end
