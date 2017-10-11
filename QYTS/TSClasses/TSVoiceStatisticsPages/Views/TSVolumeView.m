//
//  TSVolumeView.m
//  QYTS
//
//  Created by lxd on 2017/7/21.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSVolumeView.h"

#define MaxVolumLines 10
#define LineWidth W(4)

@interface TSVolumeView ()
@property (nonatomic, weak) UIView *coveView;
@end

@implementation TSVolumeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x2b3f67);
        self.hidden = YES;
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    CGFloat volumeLineW = LineWidth;
    CGFloat MarginX = W(6);
    CGFloat DefaultHeight = H(5);
    for (int i = 0; i < MaxVolumLines; i ++) {
        CGFloat volumeLineX = i*(volumeLineW + MarginX);
        CGFloat volumeLineH = DefaultHeight*(i + 1);
        CGFloat volumeLineY = self.height - volumeLineH;
        
        CAShapeLayer *volumeLine = [[CAShapeLayer alloc] init];
        volumeLine.backgroundColor = TSHEXCOLOR(0xe1ecff).CGColor;
        volumeLine.frame = CGRectMake(volumeLineX, volumeLineY, volumeLineW, volumeLineH);
        volumeLine.masksToBounds = YES;
        volumeLine.cornerRadius = 2;
        [self.layer addSublayer:volumeLine];
    }
    
    // add cover view
    UIView *coveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    coveView.backgroundColor = self.backgroundColor;
    [self addSubview:coveView];
    self.coveView = coveView;
}

- (void)setVolume:(int)volume {
    _volume = volume/2;
    
    if (_volume > MaxVolumLines) {
        _volume = MaxVolumLines;
    }
    
    if (_volume == 0) {
        self.coveView.width = self.width;
    } else {
        self.coveView.width = _volume*W(10);
    }
    
    self.coveView.x = self.width - self.coveView.width;
}
@end
