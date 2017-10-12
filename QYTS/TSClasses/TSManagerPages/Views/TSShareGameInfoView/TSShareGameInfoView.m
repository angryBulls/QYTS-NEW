//
//  TSShareGameInfoView.m
//  QYTS
//
//  Created by lxd on 2017/8/15.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSShareGameInfoView.h"
#import "SubGameInfoView.h"
#import "TSGameModel.h"
#import "ShareMatchInfoModel.h"

@interface TSShareGameInfoView ()
@property (nonatomic, weak) SubGameInfoView *leftGameInfoView;
@property (nonatomic, weak) SubGameInfoView *rightGameInfoView;
@property (nonatomic, weak) UILabel *gameDateLab;
@end

@implementation TSShareGameInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add game VS image
    UIImage *vsImage = [UIImage imageNamed:@"share_game_VS_image"];
    UIImageView *vsImageView = [[UIImageView alloc] initWithImage:vsImage];
    vsImageView.centerX = self.width*0.5;
    [self addSubview:vsImageView];
    
    // add game date label
    CGFloat gameDateLabW = W(100);
    CGFloat gameDateLabH = H(12);
    CGFloat gameDateLabY = self.height - gameDateLabH;
    UILabel *gameDateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, gameDateLabY, gameDateLabW, gameDateLabH)];
    gameDateLab.centerX = self.width*0.5;
    gameDateLab.font = [UIFont boldSystemFontOfSize:W(12.0)];
    gameDateLab.textColor = [UIColor whiteColor];
    gameDateLab.textAlignment = NSTextAlignmentCenter;
    gameDateLab.text = @" ";
    [self addSubview:gameDateLab];
    self.gameDateLab = gameDateLab;
    
    // 获取主客队颜色
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    NSMutableArray *hostGuestTeamColorarray = [[calculationTool getHostTeamAndGuestTeamColor] mutableCopy];
    if (hostGuestTeamColorarray[0] == [UIColor whiteColor] || hostGuestTeamColorarray[0] == [UIColor clearColor]) {
        hostGuestTeamColorarray[0] = TSHEXCOLOR(0xF9A204);
    }
    if (hostGuestTeamColorarray[1] == [UIColor whiteColor] || hostGuestTeamColorarray[1] == [UIColor clearColor]) {
        hostGuestTeamColorarray[1] = TSHEXCOLOR(0x30E45F);
    }
    
    // add host team info view
    CGFloat leftGameInfoViewW = (self.width - vsImageView.width)*0.5;
    SubGameInfoView *leftGameInfoView = [[SubGameInfoView alloc] initWithFrame:CGRectMake(0, 0, leftGameInfoViewW, self.height)];
    leftGameInfoView.teamTypeLab.text = @"主队";
    leftGameInfoView.teamTypeLab.textColor = hostGuestTeamColorarray[0];
    [self addSubview:leftGameInfoView];
    self.leftGameInfoView = leftGameInfoView;
    
    // add guest team info view
    SubGameInfoView *rightGameInfoView = [[SubGameInfoView alloc] initWithFrame:CGRectMake(self.width - leftGameInfoViewW, 0, leftGameInfoViewW, self.height)];
    rightGameInfoView.teamTypeLab.text = @"客队";
    rightGameInfoView.teamTypeLab.textColor = hostGuestTeamColorarray[1];
    [self addSubview:rightGameInfoView];
    self.rightGameInfoView = rightGameInfoView;
}

- (void)setMatchInfoModel:(ShareMatchInfoModel *)matchInfoModel {
    _matchInfoModel = matchInfoModel;
    
    self.leftGameInfoView.teamNameLab.text = matchInfoModel.homeTeamName;
    self.leftGameInfoView.scoreLab.text = matchInfoModel.homeTeamScore;
    if (999 == matchInfoModel.homeTeamScore.intValue) {
        self.leftGameInfoView.scoreLab.text = @"W";
    }
    
    self.rightGameInfoView.teamNameLab.text = matchInfoModel.awayTeamName;
    self.rightGameInfoView.scoreLab.text = matchInfoModel.awayTeamScore;
    if (999 == matchInfoModel.awayTeamScore.intValue) {
        self.rightGameInfoView.scoreLab.text = @"W";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSDate *matchTime = [dateFormatter dateFromString:matchInfoModel.matchTime];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    self.gameDateLab.text = [dateFormatter stringFromDate:matchTime];
}
@end
