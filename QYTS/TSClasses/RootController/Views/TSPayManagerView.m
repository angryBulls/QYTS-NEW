//
//  TSPayManagerView.m
//  QYTS
//
//  Created by lxd on 2017/8/16.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPayManagerView.h"
#import "TSSelectPayTypeView.h"
#import "UIImage+Extension.h"

@interface TSPayManagerView ()
@property (nonatomic, weak) TSSelectPayTypeView *weixinTypeView;
@property (nonatomic, weak) TSSelectPayTypeView *zfbTypeView;
@property (nonatomic, copy) SelectPayTypeReturnBlock selectPayTypeReturnBlock;
@property (nonatomic, copy) SelectPayTypeCanceledBlock selectPayTypeCanceledBlock;
@property (nonatomic) SelectPayType selectPayType;
@property (nonatomic, weak) UILabel *costTipsLab;
@property (nonatomic, weak) UILabel *costValueLab;
@end

@implementation TSPayManagerView
- (instancetype)initWithFrame:(CGRect)frame selectPayTypeReturnBlock:(SelectPayTypeReturnBlock)selectPayTypeReturnBlock selectPayTypeCanceledBlock:(SelectPayTypeCanceledBlock)selectPayTypeCanceledBlock {
    if (self = [super initWithFrame:frame]) {
        _selectPayTypeReturnBlock = selectPayTypeReturnBlock;
        _selectPayTypeCanceledBlock = selectPayTypeCanceledBlock;
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
    
    // add bg view
    CGFloat bgViewX = 0;
    CGFloat bgViewW = self.width;
    CGFloat bgViewH = H(400);
    CGFloat bgViewY = self.height - bgViewH;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    [self addSubview:bgView];
    
    // add cancel button
    CGFloat cancelBtnWH = W(22);
    CGFloat cancelBtnX = (bgView.width - cancelBtnWH)*0.5;
    CGFloat cancelBtnY = bgView.height - cancelBtnWH - H(10);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnWH, cancelBtnWH);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel_pay_image"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(p_cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    // add bg imageView
    UIImage *image = [UIImage imageNamed:@"pay_manager_bg_image"];
    CGFloat bgImageViewX = W(27);
    CGFloat bgImageViewW = bgView.width - 2*bgImageViewX;
    CGFloat bgImageViewH = bgView.height - H(42);
    CGFloat bgImageViewY = 0;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageViewX, bgImageViewY, bgImageViewW, bgImageViewH)];
    bgImageView.image = image;
    bgImageView.userInteractionEnabled = YES;
    [bgView addSubview:bgImageView];
    
    // add title label
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, H(6), bgView.width, H(42))];
    titleLab.text = @"确认订单";
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    
    // title label bold parting line
    UIImage *boldPartingLine = [UIImage imageNamed:@"pay_bold_parting_line"];
    UIImageView *boldLineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(W(5), CGRectGetMaxY(titleLab.frame), bgImageView.width - 2*W(5), boldPartingLine.size.height)];
    boldLineImageView1.image = boldPartingLine;
    [bgImageView addSubview:boldLineImageView1];
    
    // add cost statement label
    CGFloat costTipsLabX = W(30);
    CGFloat costTipsLabY = CGRectGetMaxY(boldLineImageView1.frame);
    CGFloat costTipsLabW = bgImageView.width - costTipsLabX;
    CGFloat costTipsLabH = H(48);
    UILabel *costTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(costTipsLabX, costTipsLabY, costTipsLabW, costTipsLabH)];
    costTipsLab.text = @"语音版技术统计为收费版本，单场?元";
    costTipsLab.font = [UIFont systemFontOfSize:W(13.0)];
    costTipsLab.textColor = TSHEXCOLOR(0x73ceff);
    [bgImageView addSubview:costTipsLab];
    self.costTipsLab = costTipsLab;
    
    // title label small parting line1
    UIImage *smallPartingLine1 = [UIImage imageNamed:@"pay_small_parting_line"];
    UIImageView *smallLineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(W(30), CGRectGetMaxY(costTipsLab.frame), bgImageView.width - W(60), 0.5)];
    smallLineImageView1.image = smallPartingLine1;
    [bgImageView addSubview:smallLineImageView1];
    
    // add buy current label
    CGFloat buyTitleLabX = W(30);
    CGFloat buyTitleLabY = CGRectGetMaxY(smallLineImageView1.frame);
    CGFloat buyTitleLabW = W(80);
    CGFloat buyTitleLabH = H(48);
    UILabel *buyTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(buyTitleLabX, buyTitleLabY, buyTitleLabW, buyTitleLabH)];
    buyTitleLab.text = @"购买本场";
    buyTitleLab.font = [UIFont systemFontOfSize:W(15.0)];
    buyTitleLab.textColor = TSHEXCOLOR(0x73ceff);
    [bgImageView addSubview:buyTitleLab];
    
    // add cost value label
    CGFloat costValueLabY = CGRectGetMaxY(smallLineImageView1.frame);
    CGFloat costValueLabW = W(160);
    CGFloat costValueLabX = bgImageView.width - costValueLabW - W(30);
    CGFloat costValueLabH = H(48);
    UILabel *costValueLab = [[UILabel alloc] initWithFrame:CGRectMake(costValueLabX, costValueLabY, costValueLabW, costValueLabH)];
    costValueLab.font = [UIFont systemFontOfSize:W(15.0)];
    costValueLab.textColor = TSHEXCOLOR(0xffffff);
    costValueLab.text = @"?元/场";
    costValueLab.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:costValueLab];
    self.costValueLab = costValueLab;
    
    TSWeakSelf;
    // add weixin pay select view
    TSSelectPayTypeView *weixinTypeView = [[TSSelectPayTypeView alloc] initWithFrame:CGRectMake(W(35), CGRectGetMaxY(costValueLab.frame), bgImageView.width - W(70), H(48)) payType:PayTypeWeiXin selectReturnBlock:^(BOOL selectStatus) {
        if (selectStatus) {
            __weakSelf.zfbTypeView.selectPayBtn.selected = NO;
        }
    }];
    [bgImageView addSubview:weixinTypeView];
    self.weixinTypeView = weixinTypeView;
    
    UIImageView *smallLineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(W(30), CGRectGetMaxY(weixinTypeView.frame) + H(12), bgImageView.width - W(60), 0.5)];
    smallLineImageView2.image = smallPartingLine1;
    [bgImageView addSubview:smallLineImageView2];
    
    // add zhifubao pay select view
    TSSelectPayTypeView *zfbTypeView = [[TSSelectPayTypeView alloc] initWithFrame:CGRectMake(W(35), CGRectGetMaxY(smallLineImageView2.frame) + H(12), bgImageView.width - W(70), H(48)) payType:PayTypeZhiFuBao selectReturnBlock:^(BOOL selectStatus) {
        __weakSelf.weixinTypeView.selectPayBtn.selected = NO;
    }];
    [bgImageView addSubview:zfbTypeView];
    self.zfbTypeView = zfbTypeView;
    
    UIImageView *boldLineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(W(5), CGRectGetMaxY(zfbTypeView.frame) + H(12), bgImageView.width - 2*W(5), boldPartingLine.size.height)];
    boldLineImageView2.image = boldPartingLine;
    [bgImageView addSubview:boldLineImageView2];
    
    // add immediate pay button
    CGFloat immediatePayBtnH = H(43);
    CGFloat immediatePayBtnW = W(170);
    CGFloat immediatePayBtnX = (bgImageView.width - immediatePayBtnW)*0.5;
    CGFloat immediatePayBtnY = bgImageView.height - immediatePayBtnH - H(20);
    UIButton *immediatePayBtn = [self p_createSubmitButtonWithTile:@"立即支付" frame:CGRectMake(immediatePayBtnX, immediatePayBtnY, immediatePayBtnW, immediatePayBtnH)];
    [immediatePayBtn addTarget:self action:@selector(p_immediatePayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:immediatePayBtn];
}

- (void)p_cancelBtnClick {
    self.selectPayTypeCanceledBlock ? self.selectPayTypeCanceledBlock() : nil;
    [self p_dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)p_dismiss {
    [self removeFromSuperview];
}

- (UIButton *)p_createSubmitButtonWithTile:(NSString *)submitTitle frame:(CGRect)frame {
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    submitBtn.frame = frame;
    [submitBtn setTitle:submitTitle forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [submitBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(frame.size.width, frame.size.height)] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(frame.size.width, frame.size.height)] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = frame.size.height*0.5;
    submitBtn.layer.masksToBounds = YES;
    
    return submitBtn;
}

- (void)p_immediatePayBtnClick { // 立即支付按钮点击
    if (self.weixinTypeView.selectPayBtn.selected) {
        self.selectPayType = SelectPayTypeWeiXin;
        self.selectPayTypeReturnBlock ? self.selectPayTypeReturnBlock(self.selectPayType) : nil;
        [self p_dismiss];
    } else if (self.zfbTypeView.selectPayBtn.selected) {
        self.selectPayType = SelectPayTypeZhiFuBao;
        self.selectPayTypeReturnBlock ? self.selectPayTypeReturnBlock(self.selectPayType) : nil;
        [self p_dismiss];
    }
}

- (void)setOnceComboPrice:(NSString *)onceComboPrice {
    _onceComboPrice = onceComboPrice;
    
    CGFloat price = 0;
    if (onceComboPrice.length) {
        price = onceComboPrice.floatValue / 100;
        NSString *priceString = [NSString stringWithFormat:@"%.2f", price];
        self.costTipsLab.text = [NSString stringWithFormat:@"语音版技术统计为收费版本，单场%@元", priceString];
        
        self.costValueLab.text = [NSString stringWithFormat:@"%@元/场", priceString];
        NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:self.costValueLab.text];
        [attribString addAttribute:NSForegroundColorAttributeName value:TSHEXCOLOR(0x73ceff) range:NSMakeRange(priceString.length + 1, attribString.length - priceString.length - 1)];
        self.costValueLab.attributedText = attribString;
    }
}
@end
