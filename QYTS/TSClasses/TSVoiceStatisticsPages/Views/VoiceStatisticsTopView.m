//
//  VoiceStatisticsTopView.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "VoiceStatisticsTopView.h"
#import "StatisticsScoreView.h"
#import "TSGameModel.h"
#import "YTKKeyValueStore.h"
#import "UIImage+Extension.h"

#define HostTeamName @"主队"
#define GuestTeamName @"客队"

@interface VoiceStatisticsTopView ()
@property (nonatomic, assign) PageType pageType; // 根据不同的页面类型创建中间的view

@property (nonatomic, weak) UILabel *htNameLab;
@property (nonatomic, weak) UILabel *gtNameLab;

@property (nonatomic, weak) UILabel *hFoulLab;
@property (nonatomic, weak) UILabel *gFoulLab;

@property (nonatomic, weak) UILabel *hPauseLab;
@property (nonatomic, weak) UILabel *gPauseLab;

@property (nonatomic, weak) StatisticsScoreView *scoreView;

// page type is section
@property (nonatomic, weak) UILabel *stageTimesLab;
@property (nonatomic, weak) UILabel *stageRestTimesLab;

@property (nonatomic, strong) TSToolsMethod *toolsMethod;
@end

@implementation VoiceStatisticsTopView
- (instancetype)initWithFrame:(CGRect)frame pageType:(PageType)pageType {
    if (self = [super initWithFrame:frame]) {
        _pageType = pageType;
        TSDBManager *tSDBManager = [[TSDBManager alloc] init];
        NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
        if ([gameTableDict[CurrentStage] isEqualToString:OverTime1] && 2 == [gameTableDict[@"ruleType"] intValue]) {
            _timeCountType = TimeCountTypeUp;
        }
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add background imageView
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"statisticsTopBgImageView"];
    [self addSubview:bgImageView];
    
    // add team label
    CGFloat hostTeamLabX = W(9);
    CGFloat hostTeamLabY = H(35);
    CGFloat hostTeamLabW = W(35);
    CGFloat hostTeamLabH = H(19);
    UILabel *hostTeamLab = [self p_createTeamLabelWithFrame:CGRectMake(hostTeamLabX, hostTeamLabY, hostTeamLabW, hostTeamLabH) title:HostTeamName];
    [self addSubview:hostTeamLab];
    
    UILabel *guestTeamLab = [self p_createTeamLabelWithFrame:CGRectMake(self.width - hostTeamLabW - hostTeamLabX, hostTeamLabY, hostTeamLabW, hostTeamLabH) title:GuestTeamName];
    [self addSubview:guestTeamLab];
    
    // add host team name label
    CGFloat nameLabX = W(7);
    CGFloat nameLabY = CGRectGetMaxY(hostTeamLab.frame) + H(9);
    CGFloat nameLabW = W(40);
    CGFloat nameLabH = H(85);
    
    // 从数据库获取主客队的名称
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:TSDBName];
    NSDictionary *gameCheckDict = [store getObjectById:GameCheckID fromTable:TSCheckTable];
    UILabel *htNameLab = [self p_createNameLabelWithFrame:CGRectMake(nameLabX, nameLabY, nameLabW, nameLabH) title:gameCheckDict[@"homeTeamName"]];
    [self addSubview:htNameLab];
    self.htNameLab = htNameLab;
    
    // add guest team name label
    UILabel *gtNameLab = [self p_createNameLabelWithFrame:CGRectMake(self.width - nameLabW - nameLabX, nameLabY, nameLabW, nameLabH) title:gameCheckDict[@"awayTeamName"]];
    [self addSubview:gtNameLab];
    self.gtNameLab = gtNameLab;
    
    // add host team foul times label
    CGFloat foulLabX = 0;
    CGFloat foulLabY = CGRectGetMaxY(self.htNameLab.frame) + H(11);
    CGFloat foulLabW = W(55);
    CGFloat foulLabH = H(11);
    UILabel *hFoulLab = [self p_createFoulOrPauseLabelWithFrame:CGRectMake(foulLabX, foulLabY, foulLabW, foulLabH) title:@"犯规0次"];
    [self addSubview:hFoulLab];
    self.hFoulLab = hFoulLab;
    
    // add guest team foul times label
    UILabel *gFoulLab = [self p_createFoulOrPauseLabelWithFrame:CGRectMake(self.width - foulLabW, foulLabY, foulLabW, foulLabH) title:@"犯规0次"];
    [self addSubview:gFoulLab];
    self.gFoulLab = gFoulLab;
    
    // add host team pause times label
    CGFloat pauseLabX = foulLabX;
    CGFloat pauseLabY = CGRectGetMaxY(self.hFoulLab.frame) + H(6.5);
    CGFloat pauseLabW = foulLabW;
    CGFloat pauseLabH = foulLabH;
    UILabel *hPauseLab = [self p_createFoulOrPauseLabelWithFrame:CGRectMake(pauseLabX, pauseLabY, pauseLabW, pauseLabH) title:@"暂停0次"];
    [self addSubview:hPauseLab];
    self.hPauseLab = hPauseLab;
    
    UILabel *gPauseLab = [self p_createFoulOrPauseLabelWithFrame:CGRectMake(self.width - pauseLabW, pauseLabY, pauseLabW, pauseLabH) title:@"暂停0次"];
    [self addSubview:gPauseLab];
    self.gPauseLab = gPauseLab;
    
    // add StatisticsScoreView
    CGFloat scoreViewX = W(55);
    CGFloat scoreViewY = H(30);
    if (self.pageType == PageTypeFull) {
        scoreViewY = H(60);
    }
    CGFloat scoreViewW = self.width - 2*scoreViewX;
    CGFloat scoreViewH = H(91);
    StatisticsScoreView *scoreView = [[StatisticsScoreView alloc] initWithFrame:CGRectMake(scoreViewX, scoreViewY, scoreViewW, scoreViewH)];
    [self addSubview:scoreView];
    self.scoreView = scoreView;
    
    [self p_createTimeViews];
}

- (void)p_createTimeViews {
    self.currentSecond = 0;
    
    if (self.pageType == PageTypeVoice) { // 语音识别页面
        // add count down label
        UILabel *countDownLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scoreView.frame) + H(8.5), self.scoreView.width, H(27))];
        countDownLab.centerX = self.scoreView.centerX;
        countDownLab.font = [UIFont boldSystemFontOfSize:W(20.0)];
        countDownLab.layer.borderWidth = 0.5;
        countDownLab.layer.borderColor = TSHEXCOLOR(0x6896ed).CGColor;
        countDownLab.textColor = TSHEXCOLOR(0xffdd1f);
        countDownLab.text = @"00 : 00";
        countDownLab.layer.masksToBounds = YES;
        countDownLab.layer.cornerRadius = W(5);
        countDownLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countDownLab];
        self.countDownLab = countDownLab;
        
        // add start or pause button
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.frame = CGRectMake(self.countDownLab.x, CGRectGetMaxY(self.countDownLab.frame) + H(7.5), self.countDownLab.width, H(36));
        [startBtn setTitle:@"开   始" forState:UIControlStateNormal];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:W(17.0)];
        [startBtn setTitleColor:TSHEXCOLOR(0xbfd4ff) forState:UIControlStateNormal];
        startBtn.layer.masksToBounds = YES;
        startBtn.layer.cornerRadius = W(5);
        [startBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0x10b4ff) size:startBtn.frame.size] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xFF4769) size:startBtn.frame.size] forState:UIControlStateSelected];
        [startBtn addTarget:self action:@selector(p_startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        self.startBtn = startBtn;
    } else if (self.pageType == PageTypeSection) { // 单节统计页面
        CGFloat stageTimesLabX = self.gPauseLab.width;
        CGFloat stageTimesLabY = CGRectGetMaxY(self.scoreView.frame) + H(22);
        CGFloat stageTimesLabW = self.width - 2*stageTimesLabX;
        CGFloat stageTimesLabH = H(16);
        
        UILabel *stageTimesLab = [[UILabel alloc] initWithFrame:CGRectMake(stageTimesLabX, stageTimesLabY, stageTimesLabW, stageTimesLabH)];
        stageTimesLab.font = [UIFont systemFontOfSize:W(15.0)];
        stageTimesLab.textColor = TSHEXCOLOR(0xffffff);
        stageTimesLab.text = @"本节比赛已进行 00:00";
        stageTimesLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:stageTimesLab];
        self.stageTimesLab = stageTimesLab;
        
        UILabel *stageRestTimesLab = [[UILabel alloc] initWithFrame:CGRectMake(stageTimesLabX, CGRectGetMaxY(self.stageTimesLab.frame) + H(8), stageTimesLabW, stageTimesLabH)];
        stageRestTimesLab.font = [UIFont systemFontOfSize:W(15.0)];
        stageRestTimesLab.textColor = TSHEXCOLOR(0xffffff);
        stageRestTimesLab.text = @"本节比赛剩余    00:00";
        stageRestTimesLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:stageRestTimesLab];
        self.stageRestTimesLab = stageRestTimesLab;
    }
}

- (void)p_startBtnClick:(UIButton *)startBtn {
    if (TimeCountTypeUp == self.timeCountType) { // 如果是3X3加时赛
        [self p_begin3X3TimeCountUpWithStartBtn:startBtn];
        return;
    }
    
    if (0 == self.currentSecond) {
        return;
    }
    
    startBtn.selected = !startBtn.selected;
    
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    int stageGameTimes = [calculationTool getCurrentStageTimes];
    
    if (startBtn.selected) {
        [startBtn setTitle:@"暂   停" forState:UIControlStateNormal];
        TSToolsMethod *toolsMethod = [[TSToolsMethod alloc] init];
        [toolsMethod startGCDTimerWithDuration:self.currentSecond countdownReturnBlock:^(NSString *timeString) {
            int minutes = [timeString intValue] / 60;
            int seconds = [timeString intValue] % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d",minutes, seconds];
            self.currentSecond = [timeString intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownLab.text = strTime;
                if (0 == self.currentSecond) {
                    startBtn.selected = !startBtn.selected;
                    [startBtn setTitle:@"开   始" forState:UIControlStateNormal];
                }
            });
            
            if (timeString.intValue < stageGameTimes) {
                if (0 == (stageGameTimes - timeString.intValue)%30) {
                    [self p_updataPlayingTimesOnce];
                }
            }
        }];
        self.toolsMethod = toolsMethod;
    } else {
        [self.toolsMethod stopGCDTimer];
        [startBtn setTitle:@"开   始" forState:UIControlStateNormal];
    }
    
    // save the matchDate
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TSDBManager *tSDBManager = [[TSDBManager alloc] init];
        NSMutableDictionary *gameTableDict = [[tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
        if ([gameTableDict[@"currentStage"] isEqualToString:StageOne]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
            gameTableDict[@"matchDate"] = [fmt stringFromDate:[NSDate date]];
            [tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
        }
    });
}

- (void)p_begin3X3TimeCountUpWithStartBtn:(UIButton *)startBtn {
    startBtn.selected = !startBtn.selected;
    
    if (startBtn.selected) {
        [startBtn setTitle:@"暂   停" forState:UIControlStateNormal];
        TSToolsMethod *toolsMethod = [[TSToolsMethod alloc] init];
        [toolsMethod startGCDTimerWithDuration:self.currentSecond timeupReturnBlock:^(NSString *timeString) {
            int minutes = [timeString intValue] / 60;
            int seconds = [timeString intValue] % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d",minutes, seconds];
            self.currentSecond = [timeString intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownLab.text = strTime;
            });
            
            if (timeString.intValue > 0) {
                if (0 == (timeString.intValue)%30) {
                    [self p_updataPlayingTimesOnce];
                }
            }
        }];
        
        self.toolsMethod = toolsMethod;
    } else {
        [self.toolsMethod stopGCDTimer];
        [startBtn setTitle:@"开   始" forState:UIControlStateNormal];
    }
}

- (UILabel *)p_createTeamLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *teamLab = [[UILabel alloc] initWithFrame:frame];
    teamLab.font = [UIFont systemFontOfSize:W(14.0)];
    teamLab.layer.borderWidth = 0.5;
    teamLab.text = title;
    // 获取主客队颜色
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    NSArray *hostGuestTeamColorarray = [calculationTool getHostTeamAndGuestTeamColor];
    if ([title isEqualToString:HostTeamName]) {
        if (hostGuestTeamColorarray[0] == [UIColor clearColor]) {
            teamLab.textColor = TSHEXCOLOR(0xffffff);
            teamLab.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
        } else {
            teamLab.textColor = hostGuestTeamColorarray[0];
            teamLab.layer.borderColor = [hostGuestTeamColorarray[0] CGColor];
        }
    } else {
        if (hostGuestTeamColorarray[1] == [UIColor clearColor]) {
            teamLab.textColor = TSHEXCOLOR(0xffffff);
            teamLab.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
        } else {
            teamLab.textColor = hostGuestTeamColorarray[1];
            teamLab.layer.borderColor = [hostGuestTeamColorarray[1] CGColor];
        }
    }
    teamLab.layer.masksToBounds = YES;
    teamLab.layer.cornerRadius = W(5);
    teamLab.textAlignment = NSTextAlignmentCenter;
    
    return teamLab;
}

- (UILabel *)p_createNameLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *nameLab = [[UILabel alloc] initWithFrame:frame];
    nameLab.font = [UIFont systemFontOfSize:W(13.0)];
    nameLab.text = title;
    nameLab.textColor = TSHEXCOLOR(0xe2ecff);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.numberOfLines = 0;
    
    return nameLab;
}

- (UILabel *)p_createFoulOrPauseLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *foulLab = [[UILabel alloc] initWithFrame:frame];
    foulLab.font = [UIFont systemFontOfSize:W(11.0)];
    foulLab.text = title;
    foulLab.textColor = TSHEXCOLOR(0xb5d0ff);
    foulLab.textAlignment = NSTextAlignmentCenter;
    
    return foulLab;
}

#pragma mark - update views with game model
- (void)setGameModel:(TSGameModel *)gameModel {
    _gameModel = gameModel;
    
    self.scoreView.gameModel = gameModel;
    if (gameModel.foulsStageH) {
        self.hFoulLab.text = [NSString stringWithFormat:@"犯规%@次", gameModel.foulsStageH];
    }
    if (gameModel.timeOutStageH) {
        self.hPauseLab.text = [NSString stringWithFormat:@"暂停%@次", gameModel.timeOutStageH];
    }
    
    if (gameModel.foulsStageG) {
        self.gFoulLab.text = [NSString stringWithFormat:@"犯规%@次", gameModel.foulsStageG];
    }
    if (gameModel.timeOutStageG) {
        self.gPauseLab.text = [NSString stringWithFormat:@"暂停%@次", gameModel.timeOutStageG];
    }
    
    // 如果是全场统计页面
    if (self.pageType == PageTypeFull) {
        NSInteger totalFoulsH = gameModel.foulsStageOneH.intValue + gameModel.foulsStageTwoH.intValue + gameModel.foulsStageThreeH.intValue + gameModel.foulsStageFourH.intValue + gameModel.foulsOvertime1H.intValue + gameModel.foulsOvertime2H.intValue + gameModel.foulsOvertime3H.intValue;
        self.hFoulLab.text = [NSString stringWithFormat:@"犯规%ld次", totalFoulsH];
        
        NSInteger totalFoulsG = gameModel.foulsStageOneG.intValue + gameModel.foulsStageTwoG.intValue + gameModel.foulsStageThreeG.intValue + gameModel.foulsStageFourG.intValue + gameModel.foulsOvertime1G.intValue + gameModel.foulsOvertime2G.intValue + gameModel.foulsOvertime3G.intValue;
        self.gFoulLab.text = [NSString stringWithFormat:@"犯规%ld次", totalFoulsG];
        
        if (gameModel.timeOutTotalH) {
            self.hPauseLab.text = [NSString stringWithFormat:@"暂停%@次", gameModel.timeOutTotalH];
        }
        
        if (gameModel.timeOutTotalG) {
            self.gPauseLab.text = [NSString stringWithFormat:@"暂停%@次", gameModel.timeOutTotalG];
        }
    }
}

- (void)setCurrentSecond:(int)currentSecond {
    _currentSecond = currentSecond;
    
    if (self.pageType == PageTypeSection) {
        TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
        int stageGameTimes = [calculationTool getCurrentStageTimes];
        int minutes1 = (stageGameTimes - currentSecond) / 60;
        int seconds1 = (stageGameTimes - currentSecond) % 60;
        if ((TimeCountTypeUp == self.timeCountType) && 0 == stageGameTimes) {
            minutes1 = currentSecond / 60;
            seconds1 = currentSecond % 60;
        }
        NSString *strTime1 = [NSString stringWithFormat:@"本节比赛已进行 %.2d:%.2d",minutes1, seconds1];
        self.stageTimesLab.text = strTime1;
        
        int minutes2 = currentSecond / 60;
        int seconds2 = currentSecond % 60;
        NSString *strTime2 = [NSString stringWithFormat:@"本节比赛剩余    %.2d:%.2d",minutes2, seconds2];
        self.stageRestTimesLab.text = strTime2;
        if ((TimeCountTypeUp == self.timeCountType) && 0 == stageGameTimes) {
            self.stageRestTimesLab.text = @"本节比赛剩余    00:00";
        }
    }
}

#pragma mark - 每隔30秒更新一次球员的上场时间
- (void)p_updataPlayingTimesOnce {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    [tSDBManager udatePlayingTimesOnce];
}
@end
