//
//  MatchDetailScoreView.m
//  QYTS
//
//  Created by lxd on 2017/9/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MatchDetailScoreView.h"
#import "ShareMatchInfoModel.h"

@interface MatchDetailScoreView ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *hostGuestTeamColorarray;
@property (nonatomic, weak) UIView *teamTypeView;
@property (nonatomic, strong) NSMutableArray *stageSubViewArray;
@end

@implementation MatchDetailScoreView
- (NSMutableArray *)hostGuestTeamColorarray {
    if (!_hostGuestTeamColorarray) { // 获取主客队的颜色
        TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
        _hostGuestTeamColorarray = [[calculationTool getHostTeamAndGuestTeamColor] mutableCopy];
        if (_hostGuestTeamColorarray[0] == [UIColor whiteColor]) {
            _hostGuestTeamColorarray[0] = TSHEXCOLOR(0xF9A204);
        }
        if (_hostGuestTeamColorarray[1] == [UIColor whiteColor]) {
            _hostGuestTeamColorarray[1] = TSHEXCOLOR(0x30E45F);
        }
    }
    return _hostGuestTeamColorarray;
}

- (NSMutableArray *)stageSubViewArray {
    if (!_stageSubViewArray) {
        _stageSubViewArray = @[].mutableCopy;
    }
    return _stageSubViewArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x27395d);
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add bg view
    CGFloat bgViewY = H(10);
    CGFloat bgViewH = self.height - 2*bgViewY;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewY, self.width, bgViewH)];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    // add home and away team type view
    CGFloat teamTypeViewW = W(68);
    UIView *teamTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, teamTypeViewW, self.bgView.height)];
    [self.bgView addSubview:teamTypeView];
    self.teamTypeView = teamTypeView;
    
    CGFloat teamTypeNameLabH = self.bgView.height/3;
    CGFloat homeLabY = teamTypeNameLabH;
    UILabel *homeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, homeLabY, teamTypeViewW, teamTypeNameLabH)];
    homeLab.font = [UIFont systemFontOfSize:W(14)];
    homeLab.textColor = self.hostGuestTeamColorarray[0];
    homeLab.text = @"主队";
    homeLab.textAlignment = NSTextAlignmentCenter;
    [teamTypeView addSubview:homeLab];
    
    UILabel *awayLab = [[UILabel alloc] initWithFrame:CGRectMake(0, teamTypeNameLabH*2, teamTypeViewW, teamTypeNameLabH)];
    awayLab.font = homeLab.font;
    awayLab.textColor = self.hostGuestTeamColorarray[1];
    awayLab.text = @"客队";
    awayLab.textAlignment = NSTextAlignmentCenter;
    [teamTypeView addSubview:awayLab];
    
    // add score view
    CGFloat scrollViewX = teamTypeViewW;
    CGFloat scrollViewW = self.width - scrollViewX;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, 0, scrollViewW, self.bgView.height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.bgView addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setMatchInfoModel:(ShareMatchInfoModel *)matchInfoModel {
    _matchInfoModel = matchInfoModel;
    
    NSInteger stageCount = matchInfoModel.homeScores.count + 1;
    CGFloat stageSubViewW = W(68);
    if (stageCount < 4) {
        stageSubViewW = self.scrollView.width/stageCount;
    }
    if (1 == stageCount) {
        stageSubViewW = self.scrollView.width/stageCount - W(68);
    }
    CGFloat stageSubViewH = self.bgView.height;
    
    self.scrollView.contentSize = CGSizeMake(stageCount*stageSubViewW, self.bgView.height);
    
    CGFloat subLabelH = stageSubViewH/3;
    for (int i = 0; i < stageCount; i ++) {
        CGFloat stageSubViewX = i*stageSubViewW;
        UIView *stageSubView = [[UIView alloc] initWithFrame:CGRectMake(stageSubViewX, 0, stageSubViewW, stageSubViewH)];
        [self.scrollView addSubview:stageSubView];
        
        // add title label
        CGRect titleLabFrame = CGRectMake(0, 0, stageSubViewW, subLabelH);
        UILabel *titleLab = [self p_createLabelWithFrame:titleLabFrame TextColor:[UIColor whiteColor]];
        [stageSubView addSubview:titleLab];
        
        // add home stage score label
        CGRect homeScoreLabFrame = CGRectMake(0, subLabelH, stageSubViewW, subLabelH);
        UILabel *homeScoreLab = [self p_createLabelWithFrame:homeScoreLabFrame TextColor:self.hostGuestTeamColorarray[0]];
        homeScoreLab.text = @"0";
        [stageSubView addSubview:homeScoreLab];
        
        // add away stage score label
        CGRect awayScoreLabFrame = CGRectMake(0, subLabelH*2, stageSubViewW, subLabelH);
        UILabel *awayScoreLab = [self p_createLabelWithFrame:awayScoreLabFrame TextColor:self.hostGuestTeamColorarray[1]];
        awayScoreLab.text = @"0";
        [stageSubView addSubview:awayScoreLab];
        
        [self.stageSubViewArray addObject:stageSubView];
    }
    
    // setup data
    [self.stageSubViewArray enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx1, BOOL * _Nonnull stop) {
        [subView.subviews enumerateObjectsUsingBlock:^(UILabel *subLabel, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (0 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"第一节";
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"first"]];
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"first"]];
                }
            }
            
            if (1 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"第二节";
                    if (3 == matchInfoModel.sectionType.intValue) { // 1节10分钟
                        subLabel.text = @"加时赛";
                    }
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"second"]];
                    if (3 == matchInfoModel.sectionType.intValue) { // 1节10分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"firstOt"]];
                    }
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"second"]];
                    if (3 == matchInfoModel.sectionType.intValue) { // 1节10分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"firstOt"]];
                    }
                }
            }
            
            if (2 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"第三节";
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = @"加时赛";
                    }
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"third"]];
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"firstOt"]];
                    }
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"third"]];
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"firstOt"]];
                    }
                }
            }
            
            if (3 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"第四节";
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"fourth"]];
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"fourth"]];
                }
            }
            
            if (4 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"加时赛1";
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"firstOt"]];
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"firstOt"]];
                }
            }
            
            if (5 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"加时赛2";
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"secondOt"]];
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"secondOt"]];
                }
            }
            
            if (6 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"加时赛3";
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"thirdOt"]];
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"thirdOt"]];
                }
            }
            
            if (idx1 == stageCount - 1) {
                if (0 == idx2) {
                    subLabel.text = @"总比分";
                } else if (1 == idx2) {
                    subLabel.text = matchInfoModel.homeTeamScore;
                    if (999 == matchInfoModel.homeTeamScore.intValue) {
                        subLabel.text = @"W";
                    }
                } else if (2 == idx2) {
                    subLabel.text = matchInfoModel.awayTeamScore;
                    if (999 == matchInfoModel.awayTeamScore.intValue) {
                        subLabel.text = @"W";
                    }
                }
            }
        }];
    }];
}

- (UILabel *)p_createLabelWithFrame:(CGRect)frame TextColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:W(14)];
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}
@end
