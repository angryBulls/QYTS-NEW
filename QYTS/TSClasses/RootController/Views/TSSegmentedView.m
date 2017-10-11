//
//  TSSegmentedView.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSSegmentedView.h"
#import "TSSegCustomButton.h"

@interface TSSegmentedView ()
@property (nonatomic, assign) SelectStyle selectStyle;
@property (nonatomic, copy) ReturnBlock returnBlock;

@property (nonatomic, strong) NSArray *segmentArray;
@property (nonatomic, strong) TSSegCustomButton *currentSegBtn;
@end

@implementation TSSegmentedView
- (instancetype)initWithSelectStyle:(SelectStyle)selectStyle defaultSelect:(DefaultSelect)defaultSelect returnBlcok:(ReturnBlock)returnBlock {
    if (self = [super init]) {
        self.backgroundColor = TSHEXCOLOR(0x27395d);
        self.frame = CGRectMake(0, SCREEN_HEIGHT - H(50), SCREEN_WIDTH, H(50));
        
        _selectStyle = selectStyle;
        _defaultSelect = defaultSelect;
        _returnBlock = returnBlock;
        _segmentArray = @[@"本节比赛", @"整场比赛"];
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
        TSSegCustomButton *segBtn = [TSSegCustomButton buttonWithType:UIButtonTypeCustom];
        segBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
        [segBtn setTitle:obj forState:UIControlStateNormal];
        segBtn.tag = idx;
        [segBtn addTarget:self action:@selector(p_SegBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.defaultSelect == idx && self.selectStyle == SelectStyleBorderColor) {
            segBtn.selected = YES;
            segBtn.layer.borderWidth = 0.5;
            self.currentSegBtn = segBtn;
        }
        segBtn.layer.borderColor = TSHEXCOLOR(0xff4769).CGColor;
        
        if (self.selectStyle == SelectStyleBorderColor) {
            [segBtn setTitle:@"返回统计" forState:UIControlStateSelected];
        }
        
        if (0 == idx) {
            [segBtn setImage:[UIImage imageNamed:@"statistics_Clock_Icon"] forState:UIControlStateNormal];
            [segBtn setImage:[UIImage imageNamed:@"statistics_Clock_Select_Icon"] forState:UIControlStateSelected];
            segBtn.imageViewX = W(32);
        } else {
            [segBtn setImage:[UIImage imageNamed:@"statistics_Stadium_Icon"] forState:UIControlStateNormal];
            [segBtn setImage:[UIImage imageNamed:@"statistics_Stadium_Select_Icon"] forState:UIControlStateSelected];
            segBtn.imageViewX = W(65);
        }
        
        [self addSubview:segBtn];
    }];
}

- (CAShapeLayer *)p_CreateLineWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor {
    CAShapeLayer *line = [CAShapeLayer layer];
    line.frame = frame;
    line.backgroundColor = lineColor.CGColor;
    return line;
}

- (void)p_SegBtnClick:(TSSegCustomButton *)segBtn {
    if (segBtn.selected) {
        self.returnBlock ? self.returnBlock(2) : nil;
        
        return;
    }
    
    if (self.selectStyle == SelectStyleNone) {
        self.returnBlock ? self.returnBlock(segBtn.tag) : nil;
        return;
    }
    
    self.currentSegBtn.selected = NO;
    self.currentSegBtn.layer.borderWidth = 0;
    
    segBtn.selected = YES;
    segBtn.layer.borderWidth = 0.5;
    self.currentSegBtn = segBtn;
    
    self.returnBlock ? self.returnBlock(segBtn.tag) : nil;
}
@end
