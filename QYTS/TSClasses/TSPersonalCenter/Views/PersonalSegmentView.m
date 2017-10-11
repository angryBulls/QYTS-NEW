//
//  PersonalSegmentView.m
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalSegmentView.h"
#import "CustomSegmentButton.h"
#import "PersonalInfoModel.h"

@interface PersonalSegmentView ()
@property (nonatomic, copy) SelectReturnBlock selectReturnBlock;
@property (nonatomic, weak) CustomSegmentButton *finishCountBtn;
@property (nonatomic, weak) CustomSegmentButton *newcountBtn;
@end

@implementation PersonalSegmentView
- (instancetype)initWithFrame:(CGRect)frame selectReturnBlock:(SelectReturnBlock)selectReturnBlock {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        _selectReturnBlock = selectReturnBlock;
        [self p_AddSubViews];
    }
    return self;
}

- (void)p_AddSubViews {
    CGFloat Margin = W(5);
    CGFloat buttonW = (self.width - Margin)*0.5;
    CGFloat buttonH = self.height;
    
    for (int i = 0; i < 2; i ++) {
        CGFloat segmentBtnX = (buttonW + Margin)*i;
        
        CustomSegmentButton *segmentBtn = [CustomSegmentButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(segmentBtnX, 0, buttonW, buttonH);
        segmentBtn.backgroundColor = TSHEXCOLOR(0x27395d);
        segmentBtn.titleLabel.numberOfLines = 0;
        segmentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
        if (0 == i) {
            segmentBtn.tag = StatusTypeOver;
            [segmentBtn setTitle:@"0" forState:UIControlStateNormal];
            self.finishCountBtn = segmentBtn;
        } else {
            segmentBtn.tag = StatusTypeNoplay;
            [segmentBtn setTitle:@"0" forState:UIControlStateNormal];
            self.newcountBtn = segmentBtn;
        }
        [segmentBtn addTarget:self action:@selector(p_segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:segmentBtn];
        
        // add status label
        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(segmentBtnX, self.height - H(30), buttonW, H(20))];
        statusLab.font = [UIFont systemFontOfSize:W(15.0)];
        statusLab.textColor = TSHEXCOLOR(0xffffff);
        statusLab.textAlignment = NSTextAlignmentCenter;
        if (0 == i) {
            statusLab.text = @"已结束";
        } else {
            statusLab.text = @"未开打";
        }
        [self addSubview:statusLab];
    }
}

- (void)p_segmentBtnClick:(CustomSegmentButton *)segmentBtn {
    if (StatusTypeOver == segmentBtn.tag) { // 已结束
        self.selectReturnBlock ? self.selectReturnBlock(StatusTypeOver) : nil;
    } else {
        self.selectReturnBlock ? self.selectReturnBlock(StatusTypeNoplay) : nil;
    }
}

#pragma mark - update personal date with model info
- (void)setPersonalInfoModel:(PersonalInfoModel *)personalInfoModel {
    _personalInfoModel = personalInfoModel;
    
    [self.finishCountBtn setTitle:personalInfoModel.finishCount forState:UIControlStateNormal];
    [self.newcountBtn setTitle:personalInfoModel.newcount forState:UIControlStateNormal];
}
@end
