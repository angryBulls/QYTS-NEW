//
//  TSSelectPayTypeView.m
//  QYTS
//
//  Created by lxd on 2017/8/16.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSSelectPayTypeView.h"

@interface TSSelectPayTypeView ()
@property (nonatomic) PayType payType;
@property (nonatomic, copy) SelectReturnBlock selectReturnBlock;
@end

@implementation TSSelectPayTypeView
- (instancetype)initWithFrame:(CGRect)frame payType:(PayType)payType  selectReturnBlock:(SelectReturnBlock)selectReturnBlock {
    if (self = [super initWithFrame:frame]) {
        _payType = payType;
        _selectReturnBlock = selectReturnBlock;
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add icon image
    UIImage *image;
    NSString *payTypeStr = @"";
    if (self.payType == PayTypeWeiXin) {
        image = [UIImage imageNamed:@"weixin_icon_image"];
        payTypeStr = @"微信支付";
    } else {
        image = [UIImage imageNamed:@"zhifubao_icon_image"];
        payTypeStr = @"支付宝支付";
    }
    CGFloat iconImageViewX = 0;
    CGFloat iconImageViewWH = W(39);
    CGFloat iconImageViewY = (self.height - iconImageViewWH)*0.5;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImageViewX, iconImageViewY, iconImageViewWH, iconImageViewWH)];
    iconImageView.image = image;
    [self addSubview:iconImageView];
    
    // add pay type title
    CGFloat payTypeTitleLabX = CGRectGetMaxX(iconImageView.frame) + W(10.5);
    CGFloat payTypeTitleLabY = 0;
    CGFloat payTypeTitleLabW = W(80);
    CGFloat payTypeTitleLabH = self.height;
    UILabel *payTypeTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(payTypeTitleLabX, payTypeTitleLabY, payTypeTitleLabW, payTypeTitleLabH)];
    payTypeTitleLab.text = payTypeStr;
    payTypeTitleLab.font = [UIFont systemFontOfSize:W(14.0)];
    payTypeTitleLab.textColor = TSHEXCOLOR(0xffffff);
    [self addSubview:payTypeTitleLab];
    
    // add select button
    CGFloat selectPayBtnWH = W(35);
    CGFloat selectPayBtnX = self.width - selectPayBtnWH;
    CGFloat selectPayBtnY = (self.height - selectPayBtnWH)*0.5;
    UIButton *selectPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectPayBtn.frame = CGRectMake(selectPayBtnX, selectPayBtnY, selectPayBtnWH, selectPayBtnWH);
    [selectPayBtn setImage:[UIImage imageNamed:@"pay_type_unselected"] forState:UIControlStateNormal];
    [selectPayBtn setImage:[UIImage imageNamed:@"pay_type_selected"] forState:UIControlStateSelected];
    selectPayBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectPayBtn addTarget:self action:@selector(p_selectPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectPayBtn];
    self.selectPayBtn = selectPayBtn;
}

- (void)p_selectPayBtnClick:(UIButton *)selectPayBtn {
    selectPayBtn.selected = !selectPayBtn.selected;
    
    self.selectReturnBlock ? self.selectReturnBlock(selectPayBtn.selected) : nil;
}
@end
