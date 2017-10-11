//
//  VoiceBgView.m
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "VoiceBgView.h"
#import "TSInstructionsView.h"

@interface VoiceBgView ()
@property (nonatomic, weak) UIButton *instructionBtn;
@end

@implementation VoiceBgView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self p_setupStyle];
    [self p_addSubViews];
    
    return self;
}

- (void)p_setupStyle {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = W(5);
    self.backgroundColor = TSHEXCOLOR(0x2b3f67);
}

- (void)p_addSubViews {
    // add use instruction button
    CGFloat instructionBtnW = W(70);
    CGFloat instructionBtnH = H(20);
    CGFloat instructionBtnX = self.width - instructionBtnW - W(15);
    CGFloat instructionBtnY = self.height - instructionBtnH - H(10);
    UIButton *instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    instructionBtn.frame = CGRectMake(instructionBtnX, instructionBtnY, instructionBtnW, instructionBtnH);
    instructionBtn.adjustsImageWhenHighlighted = NO;
    instructionBtn.titleLabel.font = [UIFont systemFontOfSize:W(13.0)];
    [instructionBtn setTitleColor:TSHEXCOLOR(0xB5D0FF) forState:UIControlStateNormal];
    instructionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [instructionBtn setTitle:@"使用说明？" forState:UIControlStateNormal];
    [instructionBtn addTarget:self action:@selector(p_instructionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:instructionBtn];
    self.instructionBtn = instructionBtn;
}

- (void)p_instructionBtnClick {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    RuleType ruleType = RuleType5V5;
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        ruleType = RuleType3V3;
    }
    TSInstructionsView *instView = [[TSInstructionsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ruleType:ruleType];
    [instView show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self bringSubviewToFront:self.instructionBtn];
}
@end
