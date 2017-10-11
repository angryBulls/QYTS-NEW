//
//  SubGameInfoView.m
//  QYTS
//
//  Created by lxd on 2017/8/15.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "SubGameInfoView.h"

@interface SubGameInfoView ()

@end

@implementation SubGameInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add left team type label
    CGFloat teamTypeLabW = self.width;
    CGFloat teamTypeLabH = H(15);
    UILabel *teamTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, teamTypeLabW, teamTypeLabH)];
    teamTypeLab.font = [UIFont boldSystemFontOfSize:W(14.0)];
    teamTypeLab.textColor = [UIColor whiteColor];
    teamTypeLab.textAlignment = NSTextAlignmentCenter;
    teamTypeLab.text = @" ";
    [self addSubview:teamTypeLab];
    self.teamTypeLab = teamTypeLab;
    
    // add score label
    CGFloat scoreLabH = H(18);
    CGFloat scoreLabY = self.height - scoreLabH;
    UILabel *scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(0, scoreLabY, self.width, scoreLabH)];
    scoreLab.font = [UIFont boldSystemFontOfSize:W(23.0)];
    scoreLab.textColor = [UIColor whiteColor];
    scoreLab.textAlignment = NSTextAlignmentCenter;
    scoreLab.text = @"0";
    [self addSubview:scoreLab];
    self.scoreLab = scoreLab;
    
    // add team name label
    CGFloat MarginX = W(30);
    CGFloat teamNameLabH = self.height - self.teamTypeLab.height - self.scoreLab.height;
    CGFloat teamNameLabY = self.teamTypeLab.height;
    UILabel *teamNameLab = [[UILabel alloc] initWithFrame:CGRectMake(MarginX, teamNameLabY, self.width - 2*MarginX, teamNameLabH)];
    teamNameLab.font = [UIFont boldSystemFontOfSize:W(14.0)];
    teamNameLab.textColor = [UIColor whiteColor];
    teamNameLab.textAlignment = NSTextAlignmentCenter;
    teamNameLab.text = @"队名";
    teamNameLab.numberOfLines = 0;
    [self addSubview:teamNameLab];
    self.teamNameLab = teamNameLab;
}
@end
