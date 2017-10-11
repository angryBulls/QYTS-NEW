//
//  PersonalHeaderView.m
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalHeaderView.h"
#import "UIButton+WebCache.h"
#import "PersonalSegmentView.h"
#import "PersonalInfoModel.h"

@interface PersonalHeaderView ()
@property (nonatomic, weak) UIButton *headerBtn;
@property (nonatomic, weak) UILabel *nameLab;
@property (nonatomic, weak) UILabel *signatureLab;
@property (nonatomic, weak) PersonalSegmentView *segmentView;
@end

@implementation PersonalHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add background imageView
    UIImage *image = [UIImage imageNamed:@"personal_header_bg_image"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, self.width, (SCREEN_HEIGHT - 64) * 0.53)];
    bgImageView.image = image;
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    // add user head
    CGFloat headerBtnWH = W(90);
    CGFloat headerBtnY = 64;
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, headerBtnY, headerBtnWH, headerBtnWH);
    headerBtn.centerX = self.width*0.5;
    headerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    headerBtn.backgroundColor = [UIColor blueColor];
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"player_defaultHead_Image"] forState:UIControlStateNormal];
    headerBtn.layer.borderWidth = 3.0;
    headerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    headerBtn.layer.masksToBounds = YES;
    headerBtn.layer.cornerRadius = headerBtnWH*0.5;
    [self addSubview:headerBtn];
    self.headerBtn = headerBtn;
    
    CGFloat nameLabW = self.width;
    CGFloat nameLabH = H(25);
    CGFloat nameLabY = CGRectGetMaxY(self.headerBtn.frame) + H(5);
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabY, nameLabW, nameLabH)];
    nameLab.font = [UIFont systemFontOfSize:W(15.0)];
    nameLab.textColor = TSHEXCOLOR(0xffffff);
    nameLab.text = @" ";
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLab];
    self.nameLab = nameLab;
    
    // add signature label
    CGFloat signatureLabX = W(80);
    CGFloat signatureLabY = CGRectGetMaxY(self.nameLab.frame) + H(5);
    CGFloat signatureLabW = self.width - 2*signatureLabX;
    CGFloat signatureLabH = H(50);
    UILabel *signatureLab = [[UILabel alloc] initWithFrame:CGRectMake(signatureLabX, signatureLabY, signatureLabW, signatureLabH)];
    signatureLab.font = [UIFont systemFontOfSize:W(13.0)];
    signatureLab.textColor = TSHEXCOLOR(0xffffff);
    signatureLab.text = @"个性签名：友谊第一，比赛第二,个性签名：友谊第一，比赛第二";
    signatureLab.numberOfLines = 0;
    [self addSubview:signatureLab];
    self.signatureLab = signatureLab;
    
    // add PersonalSegmentView
    CGFloat segmentViewX = W(7.5);
    CGFloat segmentViewY = CGRectGetMaxY(self.signatureLab.frame) + H(5);
    CGFloat segmentViewH = self.height - segmentViewY - H(20);
    PersonalSegmentView *segmentView = [[PersonalSegmentView alloc] initWithFrame:CGRectMake(segmentViewX, segmentViewY, self.width - 2*segmentViewX, segmentViewH) selectReturnBlock:^(StatusType gameStatus) {
        if ([self.delegate respondsToSelector:@selector(gameStatusSelect:)]) {
            if (StatusTypeOver == gameStatus) {
                [self.delegate gameStatusSelect:StatusTypeOver];
            } else {
                [self.delegate gameStatusSelect:StatusTypeNoplay];
            }
        }
    }];
    [self addSubview:segmentView];
    self.segmentView = segmentView;
}

#pragma mark - update personal date with model info
- (void)setPersonalInfoModel:(PersonalInfoModel *)personalInfoModel {
    _personalInfoModel = personalInfoModel;
    
    self.nameLab.text = personalInfoModel.name;
    self.signatureLab.text = personalInfoModel.sign;
    if (0 == personalInfoModel.sign.length) {
        self.signatureLab.text = @"个性签名：用户尚未填写";
    }
    self.segmentView.personalInfoModel = _personalInfoModel;
}
@end
