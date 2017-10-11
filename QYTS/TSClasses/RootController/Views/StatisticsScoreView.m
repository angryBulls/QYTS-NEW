//
//  StatisticsScoreView.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "StatisticsScoreView.h"
#import "TSGameModel.h"

@interface StatisticsScoreView ()
@property (nonatomic, strong) NSMutableArray *scoreLabelArray;
@property (nonatomic, strong) UILabel *stageLabel;
@end

@implementation StatisticsScoreView
#pragma mark - lazy method
- (NSMutableArray *)scoreLabelArray {
    if (!_scoreLabelArray) {
        _scoreLabelArray = [NSMutableArray array];
    }
    return _scoreLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = W(5);
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    NSArray *nameArray = @[@"球队", @"本节比赛", @"总比分", @"主队", @"0", @"0", @"客队", @"0", @"0"];
    
    int maxColumn = 3;
    int maxRow = 3;
    
    CGFloat subLabW = self.width /maxColumn;
    CGFloat subLabH = self.height /maxRow;
    
    // 获取主客队颜色
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    NSArray *hostGuestTeamColorarray = [calculationTool getHostTeamAndGuestTeamColor];
    
    [nameArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat subLabX = idx%maxColumn*subLabW;
        CGFloat subLabY = idx/maxColumn*subLabH;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(subLabX, subLabY, subLabW, subLabH)];
        nameLab.font = [UIFont systemFontOfSize:W(14.0)];
        nameLab.text = obj;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.layer.borderWidth = 0.5;
        nameLab.layer.borderColor = TSHEXCOLOR(0x1b3f7e).CGColor;
        
        if (1 == idx) {
            self.stageLabel = nameLab;
        }
        
        if (3 == idx) {
            if (hostGuestTeamColorarray[0] == [UIColor clearColor]) {
                nameLab.textColor = TSHEXCOLOR(0xffffff);
            } else {
                nameLab.textColor = hostGuestTeamColorarray[0];
            }
        } else if (6 == idx) {
            if (hostGuestTeamColorarray[1] == [UIColor clearColor]) {
                nameLab.textColor = TSHEXCOLOR(0xffffff);
            } else {
                nameLab.textColor = hostGuestTeamColorarray[1];
            }
        } else {
            nameLab.textColor = TSHEXCOLOR(0xffffff);
        }
        
        [self addSubview:nameLab];
        
        if (4 == idx || 5 == idx || 7 == idx || 8 == idx) {
            [self.scoreLabelArray addObject:nameLab];
        }
    }];
}

#pragma mark - update views with game model
- (void)setGameModel:(TSGameModel *)gameModel {
    _gameModel = gameModel;
    
    [self.scoreLabelArray enumerateObjectsUsingBlock:^(UILabel *scoreLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) {
            scoreLabel.text = gameModel.scoreStageH;
        } else if (1 == idx) {
            scoreLabel.text = gameModel.scoreTotalH;
        } else if (2 == idx) {
            scoreLabel.text = gameModel.scoreStageG;
        } else if (3 == idx) {
            scoreLabel.text = gameModel.scoreTotalG;
        }
    }];
    
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSString *stageCount = [tSDBManager getObjectById:GameId fromTable:GameTable][CurrentStage];
    NSArray *tempArray = @[@"第一节", @"第二节", @"第三节", @"第四节", @"加时赛1", @"加时赛2", @"加时赛3"];
    [StageAllArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([stageCount isEqualToString:obj]) {
            self.stageLabel.text = tempArray[idx];
        }
    }];
    
    // 检查是否有弃权的情况
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if (gameTableDict[@"abstention"]) {
        if (1 == [gameTableDict[@"abstention"] intValue]) {
            [self.scoreLabelArray enumerateObjectsUsingBlock:^(UILabel *scoreLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (0 == idx) {
                    scoreLabel.text = @"0";
                } else if (1 == idx) {
                    scoreLabel.text = @"0";
                } else if (2 == idx) {
                    scoreLabel.text = @"W";
                } else if (3 == idx) {
                    scoreLabel.text = @"W";
                }
            }];
        } else if (2 == [gameTableDict[@"abstention"] intValue]) {
            [self.scoreLabelArray enumerateObjectsUsingBlock:^(UILabel *scoreLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (0 == idx) {
                    scoreLabel.text = @"W";
                } else if (1 == idx) {
                    scoreLabel.text = @"W";
                } else if (2 == idx) {
                    scoreLabel.text = @"0";
                } else if (3 == idx) {
                    scoreLabel.text = @"0";
                }
            }];
        }
    }
}
@end
