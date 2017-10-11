//
//  ShareStageScoreView.m
//  QYTS
//
//  Created by lxd on 2017/8/15.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ShareStageScoreView.h"
#import "TSGameModel.h"

@interface ShareStageScoreView ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *stageView;
@property (nonatomic, weak) UIView *hostView;
@property (nonatomic, weak) UIView *guestView;

@property (nonatomic, strong) NSMutableArray *hostLabArray;
@property (nonatomic, strong) NSMutableArray *guestLabArray;
@end

@implementation ShareStageScoreView
- (NSMutableArray *)hostLabArray {
    if (!_hostLabArray) {
        _hostLabArray = [NSMutableArray array];
    }
    return _hostLabArray;
}

- (NSMutableArray *)guestLabArray {
    if (!_guestLabArray) {
        _guestLabArray = [NSMutableArray array];
    }
    return _guestLabArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add bgView
    CGFloat bgViewX = W(17);
    CGFloat bgViewY = 0;
    CGFloat bgViewW = self.width - 2*bgViewX;
    CGFloat bgViewH = self.height;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH - 2*bgViewY)];
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.layer.cornerRadius = W(10);
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    bgView.layer.borderWidth = 0.5;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    __block NSUInteger stageCount = 0;
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    NSString *currentStage = gameTableDict[CurrentStage];
    [StageAllArray enumerateObjectsUsingBlock:^(NSString *stageName, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentStage isEqualToString:stageName]) {
            stageCount = idx + 1;
            if (3 == [gameTableDict[@"sectionType"] intValue]) {
                if ([currentStage isEqualToString:StageOne]) {
                    stageCount = 1;
                } else if ([currentStage isEqualToString:OverTime1]) {
                    stageCount = 2;
                }
            } else if (4 == [gameTableDict[@"sectionType"] intValue]) {
                if ([currentStage isEqualToString:StageTwo]) {
                    stageCount = 2;
                } else if ([currentStage isEqualToString:OverTime1]) {
                    stageCount = 3;
                }
            }
        }
    }];
    
    // add stage view
    NSArray *allStagArray = @[@"", @"第一节", @"第二节", @"第三节", @"第四节", @"加时赛1", @"加时赛2", @"加时赛3"];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        if (3 == [gameTableDict[@"sectionType"] intValue]) {
            allStagArray = @[@"", @"第一节", @"加时赛"];
        } else if (4 == [gameTableDict[@"sectionType"] intValue]) {
            allStagArray = @[@"", @"第一节", @"第二节", @"加时赛"];
        }
    }
    NSMutableArray *stagArray = [NSMutableArray array];
    for (int i = 0; i <= stageCount; i ++) {
        [stagArray addObject:allStagArray[i]];
    }
    
    CGFloat subViewW = self.bgView.width/stagArray.count;
    CGFloat subViewH = self.bgView.height/3;
    UIView *stageView = [self p_createViewWithFrame:CGRectMake(0, 0, subViewW, subViewH) TitleArray:stagArray titleFont:[UIFont systemFontOfSize:W(10)] titleColor:TSHEXCOLOR(0xffffff)];
    [self.bgView addSubview:stageView];
    self.stageView = stageView;
    
    // 获取主客队颜色
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    NSMutableArray *hostGuestTeamColorarray = [[calculationTool getHostTeamAndGuestTeamColor] mutableCopy];
    if (hostGuestTeamColorarray[0] == [UIColor clearColor]) {
        hostGuestTeamColorarray[0] = [UIColor whiteColor];
    }
    if (hostGuestTeamColorarray[1] == [UIColor clearColor]) {
        hostGuestTeamColorarray[1] = [UIColor whiteColor];
    }
    
    // add host view
    NSArray *allHostArray = @[@"主队", @"0", @"0", @"0", @"0", @"0", @"0", @"0"];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        if (3 == [gameTableDict[@"sectionType"] intValue]) {
            allHostArray = @[@"主队", @"0", @"0"];
        } else if (4 == [gameTableDict[@"sectionType"] intValue]) {
            allHostArray = @[@"主队", @"0", @"0", @"0"];
        }
    }
    NSMutableArray *hostArray = [NSMutableArray array];
    for (int i = 0; i <= stageCount; i ++) {
        [hostArray addObject:allHostArray[i]];
    }
    UIView *hostView = [self p_createViewWithFrame:CGRectMake(0, 0, subViewW, subViewH) TitleArray:hostArray titleFont:[UIFont systemFontOfSize:W(14)] titleColor:hostGuestTeamColorarray[0]];
    hostView.y = CGRectGetMaxY(self.stageView.frame);
    [self.bgView addSubview:hostView];
    self.hostView = hostView;
    
    // add guest view
    NSArray *allGuestArray = @[@"客队", @"0", @"0", @"0", @"0", @"0", @"0", @"0"];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        if (3 == [gameTableDict[@"sectionType"] intValue]) {
            allGuestArray = @[@"客队", @"0", @"0"];
        } else if (4 == [gameTableDict[@"sectionType"] intValue]) {
            allGuestArray = @[@"客队", @"0", @"0", @"0"];
        }
    }
    NSMutableArray *guestArray = [NSMutableArray array];
    for (int i = 0; i <= stageCount; i ++) {
        [guestArray addObject:allGuestArray[i]];
    }
    UIView *guestView = [self p_createViewWithFrame:CGRectMake(0, 0, subViewW, subViewH) TitleArray:guestArray titleFont:[UIFont systemFontOfSize:W(14)] titleColor:hostGuestTeamColorarray[1]];
    guestView.y = CGRectGetMaxY(self.hostView.frame);
    [self.bgView addSubview:guestView];
    self.guestView = guestView;
}

- (UIView *)p_createViewWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    CGFloat titleLabY = 0;
    CGFloat titleLabW = frame.size.width;
    CGFloat titleLabH = frame.size.height;
    
    [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat titleLabX = idx*titleLabW;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
        titleLab.font = titleFont;
        titleLab.textColor = titleColor;
        titleLab.text = obj;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLab];
        
        if ([titleArray[0] isEqualToString:@"主队"]) {
            [self.hostLabArray addObject:titleLab];
        }
        
        if ([titleArray[0] isEqualToString:@"客队"]) {
            [self.guestLabArray addObject:titleLab];
        }
    }];
    
    return view;
}

#pragma mark - update views with game model
- (void)setGameModel:(TSGameModel *)gameModel {
    _gameModel = gameModel;
    
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    [self.hostLabArray enumerateObjectsUsingBlock:^(UILabel *scoreLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (1 == idx) { // 主队第一节得分
            scoreLabel.text = gameModel.scoreStageOneH;
        } else if (2 == idx) { // 主队第二节得分
            scoreLabel.text = gameModel.scoreStageTwoH;
            if (3 == [gameTableDict[@"sectionType"] intValue]) {
                scoreLabel.text = gameModel.scoreOvertime1H;
            }
        } else if (3 == idx) { // 主队第三节得分
            scoreLabel.text = gameModel.scoreStageThreeH;
            if (4 == [gameTableDict[@"sectionType"] intValue]) {
                scoreLabel.text = gameModel.scoreOvertime1H;
            }
        } else if (4 == idx) { // 主队第四节得分
            scoreLabel.text = gameModel.scoreStageFourH;
        } else if (5 == idx) { // 主队加时赛1得分
            scoreLabel.text = gameModel.scoreOvertime1H;
        } else if (6 == idx) { // 主队加时赛2得分
            scoreLabel.text = gameModel.scoreOvertime2H;
        } else if (7 == idx) { // 主队加时赛3得分
            scoreLabel.text = gameModel.scoreOvertime3H;
        }
    }];
    
    [self.guestLabArray enumerateObjectsUsingBlock:^(UILabel *scoreLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (1 == idx) { // 客队第一节得分
            scoreLabel.text = gameModel.scoreStageOneG;
        } else if (2 == idx) { // 客队第二节得分
            scoreLabel.text = gameModel.scoreStageTwoG;
            if (3 == [gameTableDict[@"sectionType"] intValue]) {
                scoreLabel.text = gameModel.scoreOvertime1G;
            }
        } else if (3 == idx) { // 客队第三节得分
            scoreLabel.text = gameModel.scoreStageThreeG;
            if (4 == [gameTableDict[@"sectionType"] intValue]) {
                scoreLabel.text = gameModel.scoreOvertime1G;
            }
        } else if (4 == idx) { // 客队第四节得分
            scoreLabel.text = gameModel.scoreStageFourG;
        } else if (5 == idx) { // 客队加时赛1得分
            scoreLabel.text = gameModel.scoreOvertime1G;
        } else if (6 == idx) { // 客队加时赛2得分
            scoreLabel.text = gameModel.scoreOvertime2G;
        } else if (7 == idx) { // 客队加时赛3得分
            scoreLabel.text = gameModel.scoreOvertime3G;
        }
    }];
}
@end
