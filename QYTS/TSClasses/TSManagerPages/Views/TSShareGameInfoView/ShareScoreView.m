//
//  ShareScoreView.m
//  QYTS
//
//  Created by lxd on 2017/9/11.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ShareScoreView.h"
#import "ShareMatchInfoModel.h"

@interface ShareScoreView ()
@property (nonatomic, strong) NSMutableArray *hostGuestTeamColorarray;
@property (nonatomic, weak) UIView *teamTypeView;
@property (nonatomic, strong) NSMutableArray *stageSubViewArray;
@end

@implementation ShareScoreView
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
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = W(10);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.5;
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add home and away team type view
    CGFloat teamTypeViewW = W(68);
    UIView *teamTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, teamTypeViewW, self.height)];
    [self addSubview:teamTypeView];
    self.teamTypeView = teamTypeView;
    
    CGFloat teamTypeNameLabH = self.height/3;
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
}

- (void)setMatchInfoModel:(ShareMatchInfoModel *)matchInfoModel {
    _matchInfoModel = matchInfoModel;
    
    NSInteger stageCount ;
    
    if (4 == matchInfoModel.sectionType.intValue) {
        stageCount = 3;
    }else if (3 == matchInfoModel.sectionType.intValue){
        stageCount = 2;
    }else{
        stageCount =  matchInfoModel.homeScores.count;
    }
    
    CGFloat stageSubViewW = (self.width - self.teamTypeView.width)/stageCount;
    CGFloat stageSubViewH = self.height;
    
    CGFloat subLabelH = stageSubViewH/3;
    for (int i = 0; i < stageCount; i ++) {
        CGFloat stageSubViewX = i*stageSubViewW + self.teamTypeView.width;
        UIView *stageSubView = [[UIView alloc] initWithFrame:CGRectMake(stageSubViewX, 0, stageSubViewW, stageSubViewH)];
        [self addSubview:stageSubView];
        
        // add title label
        CGRect titleLabFrame = CGRectMake(0, 0, stageSubViewW, subLabelH);
        UILabel *titleLab = [self p_createLabelWithFrame:titleLabFrame TextColor:[UIColor whiteColor]];
        titleLab.adjustsFontSizeToFitWidth = YES;
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
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = @"加时赛";
                    }
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"fourth"]];
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"secondOt"]];
                    }
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"fourth"]];
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"secondOt"]];
                    }
                }
            }
            
            if (4 == idx1) {
                if (0 == idx2) {
                    subLabel.text = @"加时赛1";
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = @"加时赛";
                    }
                } else if (1 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"firstOt"]];
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"thirdOt"]];
                    }
                } else if (2 == idx2) {
                    subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.awayScores[@"firstOt"]];
                    if (4 == matchInfoModel.sectionType.intValue) { // 2节8分钟
                        subLabel.text = [NSString stringWithFormat:@"%@", matchInfoModel.homeScores[@"thirdOt"]];
                    }
                    
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
            if ([subLabel.text isEqualToString:@""]||[subLabel.text isEqualToString:@"null"]) {
                subLabel.text = @"0";
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
