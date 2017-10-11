//
//  RulesSegmentView.m
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "RulesSegmentView.h"

@interface RulesSegmentView ()
@property (nonatomic, copy) ReturnBlock returnBlock;
@property (nonatomic, strong) NSArray *segmentArray;
@property (nonatomic, strong) UIButton *currentSegBtn;
@property (nonatomic, weak) CAShapeLayer *shapeLine;
@end

@implementation RulesSegmentView
- (instancetype)initWithFrame:(CGRect)frame returnBlcok:(ReturnBlock)returnBlock {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x27395D);
        _returnBlock = returnBlock;
        _segmentArray = @[@"5V5", @"3V3"];
        [self p_AddSubViews];
    }
    return self;
}

- (void)p_AddSubViews {
    // add segment button
    CGFloat btnY = 0;
    CGFloat btnWidth = self.width*0.5;
    CGFloat btnHeight = self.height;
    [self.segmentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat btnX = idx*btnWidth;
        UIButton *segBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
        [segBtn setTitle:obj forState:UIControlStateNormal];
        segBtn.adjustsImageWhenDisabled = NO;
        segBtn.adjustsImageWhenHighlighted = NO;
        segBtn.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
        [segBtn setTitleColor:TSHEXCOLOR(0x4365A5) forState:UIControlStateNormal];
        [segBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
        segBtn.tag = idx;
        [segBtn addTarget:self action:@selector(p_SegBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (0 == idx) {
            segBtn.selected = YES;
//            segBtn.userInteractionEnabled = NO;
            self.currentSegBtn = segBtn;
        }
        
        [segBtn addTarget:self action:@selector(tabButtonTapped:forEvent:) forControlEvents:UIControlEventTouchDown];
        [segBtn addTarget:self action:@selector(repeatBtnTapped:forEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        
        [self addSubview:segBtn];
    }];
    
    // add shape line
    CGFloat shapeLineX = W(43);
    CGFloat shapeLineY = self.height - 1.0;
    CGFloat shapeLineW = self.width*0.5 - 2*shapeLineX;
    CAShapeLayer *shapeLine = [self p_CreateLineWithFrame:CGRectMake(shapeLineX, shapeLineY, shapeLineW, 1.0) lineColor:TSHEXCOLOR(0xffffff)];
    [self.layer addSublayer:shapeLine];
    self.shapeLine = shapeLine;
}

- (CAShapeLayer *)p_CreateLineWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor {
    CAShapeLayer *line = [CAShapeLayer layer];
    line.frame = frame;
    line.backgroundColor = lineColor.CGColor;
    return line;
}

- (void)p_SegBtnClick:(UIButton *)segBtn {
    if (segBtn.selected) {
        return;
    }
    
    CGFloat shapeLineX = W(43);
    CGFloat shapeLineY = self.height - 1.0;
    CGFloat shapeLineW = self.width*0.5 - 2*shapeLineX;
    if (1 == segBtn.tag) {
        self.shapeLine.frame = CGRectMake(self.width - shapeLineW - shapeLineX, shapeLineY, shapeLineW, 1.0);
    } else {
        self.shapeLine.frame = CGRectMake(shapeLineX, shapeLineY, shapeLineW, 1.0);
    }
    
    self.currentSegBtn.selected = NO;
    self.currentSegBtn.userInteractionEnabled = YES;
    segBtn.selected = YES;
    segBtn.userInteractionEnabled = YES;
    self.currentSegBtn = segBtn;
    
    self.returnBlock ? self.returnBlock(segBtn.tag) : nil;
}

#pragma mark - add TouchDownRepeat events
- (void)tabButtonTapped:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSelector:@selector(tabButtonTap:) withObject:sender afterDelay:0.2];
}

- (void)tabButtonTap:(UIButton *)sender {
    [self p_SegBtnClick:sender];
}

- (void)repeatBtnTapped:(UIButton *)sender forEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tabButtonTap:) object:sender];
    if (self.currentSegBtn == sender) {
        self.touchDownBtnRepeatBlock ? self.touchDownBtnRepeatBlock(sender) : nil;
    }
}
@end
