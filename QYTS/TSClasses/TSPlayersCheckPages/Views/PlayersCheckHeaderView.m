//
//  PlayersCheckHeaderView.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PlayersCheckHeaderView.h"
#import "UIView+Extension.h"

@interface PlayersCheckHeaderView ()
@property (nonatomic, assign) TeamType teamType;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *teamLab;
@end

@implementation PlayersCheckHeaderView
- (instancetype)initWithFrame:(CGRect)frame teamType:(TeamType)teamType {
    if (self = [super initWithFrame:frame]) {
        _teamType = teamType;
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add bg view
    CGFloat bgViewX = W(7.5);
    CGFloat bgViewY = 0;
    CGFloat bgViewW = self.width - 2*bgViewX;
    CGFloat bgViewH = self.height;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [bgView setRectCornerWithStyle:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:W(5)];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    // add name,number,register number,start label
    NSArray *titleArray = @[];
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeBCBC || currentUserType == LoginUserTypeCBO) {
        titleArray = @[@"姓名", @"注册号码", @"本场号码", @"首发"];
    } else if (currentUserType == LoginUserTypeNormal) {
        titleArray = @[@"姓名", @"本场号码", @"首发"];
    }
    CGFloat subLabelsW = self.bgView.width/titleArray.count;
    
    [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat titleLabX = idx*subLabelsW;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, 0, subLabelsW, self.bgView.height)];
        titleLab.text = obj;
        titleLab.font = [UIFont systemFontOfSize:W(14.0)];
        titleLab.textColor = TSHEXCOLOR(0xffffff);
        if (0 == idx) {
            titleLab.textAlignment = NSTextAlignmentRight;
            if (currentUserType == LoginUserTypeNormal) {
                titleLab.textAlignment = NSTextAlignmentCenter;
            }
        } else {
            titleLab.textAlignment = NSTextAlignmentCenter;
        }
        
        [self.bgView addSubview:titleLab];
    }];
    
    // add team label
    CGFloat teamLabW = W(35);
    CGFloat teamLabH = H(19);
    CGFloat teamLabX = W(6);
    CGFloat teamLabY = (self.bgView.height - teamLabH)*0.5;
    UILabel *teamLab = [[UILabel alloc] initWithFrame:CGRectMake(teamLabX, teamLabY, teamLabW, teamLabH)];
    teamLab.font = [UIFont systemFontOfSize:W(14.0)];
    teamLab.layer.borderWidth = 0.5;
    if (self.teamType == TeamTypeHost) {
        teamLab.text = @"主队";
        teamLab.textColor = TSHEXCOLOR(0xffa500);
        teamLab.layer.borderColor = TSHEXCOLOR(0xffa500).CGColor;
    } else {
        teamLab.text = @"客队";
        teamLab.textColor = TSHEXCOLOR(0x30e45f);
        teamLab.layer.borderColor = TSHEXCOLOR(0x30e45f).CGColor;
    }
    teamLab.layer.masksToBounds = YES;
    teamLab.layer.cornerRadius = W(5);
    teamLab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:teamLab];
    self.teamLab = teamLab;
}
@end
