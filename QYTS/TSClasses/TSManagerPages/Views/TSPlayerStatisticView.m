//
//  TSPlayerStatisticView.m
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPlayerStatisticView.h"
#import "TSManagerPlayerModel.h"
#import "CustomUIButton.h"

#define MaxColumn 7
#define TypeDataNone @"none"

@interface TSPlayerStatisticView ()
@property (nonatomic, strong) NSMutableArray *titleLabArray;
@property (nonatomic, strong) NSMutableArray *resultBtnArray;

@property (nonatomic, assign) DataType dataType;
@property (nonatomic, copy) ChangeDataReturnBlock changeDataReturnBlock;
@end

@implementation TSPlayerStatisticView
#pragma mark - lazy method
- (NSMutableArray *)titleLabArray {
    if (!_titleLabArray) {
        _titleLabArray = [NSMutableArray array];
    }
    return _titleLabArray;
}

- (NSMutableArray *)resultBtnArray {
    if (!_resultBtnArray) {
        _resultBtnArray = [NSMutableArray array];
    }
    return _resultBtnArray;
}

- (instancetype)initWithFrame:(CGRect)frame dataType:(DataType)dataType changeDataReturnBlock:(ChangeDataReturnBlock)changeDataReturnBlock {
    if (self = [super initWithFrame:frame]) {
        _dataType = dataType;
        _changeDataReturnBlock = changeDataReturnBlock;
        
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    CGFloat subViewsW = self.width / MaxColumn;
    CGFloat subViewsH = self.height*0.5;
    
    CGFloat titleLabY = 0;
    CGFloat resultBtnY = self.height*0.5;
    for (int i = 0; i < MaxColumn; i ++) {
        // add top title label
        CGFloat subViewsX = i*subViewsW;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(subViewsX, titleLabY, subViewsW, subViewsH)];
        titleLab.font = [UIFont boldSystemFontOfSize:W(10.0)];
        titleLab.textColor = TSHEXCOLOR(0xfffefe);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self.titleLabArray addObject:titleLab];
        [self addSubview:titleLab];
        
        // add bottom result button
        CustomUIButton *resultBtn = [CustomUIButton CustomUIButtonWithType:CustomButtonTypeEdit];
        resultBtn.frame = CGRectMake(subViewsX, resultBtnY, subViewsW, subViewsH);
        if (0 == i) { // 助攻按钮
            (DataTypeScore == self.dataType) ? (resultBtn.typeName = TypeDataNone) : (resultBtn.typeName = Assists);
        }
        
        if (1 == i) { // 罚篮/抢断按钮
            (DataTypeScore == self.dataType) ? (resultBtn.typeName = FreeThrowHit) : (resultBtn.typeName = Steals);
        }
        
        if (2 == i) { // 盖帽
            (DataTypeScore == self.dataType) ? (resultBtn.typeName = TypeDataNone) : (resultBtn.typeName = BlockShots);
        }
        
        if (3 == i) { // 1分球/2分球/犯规按钮
            if (DataTypeScore == self.dataType) {
                resultBtn.typeName = TwoPointsHit;
                if (2 == self.ruleType) {
                    resultBtn.typeName = OnePointsHit;
                }
            } else {
                resultBtn.typeName = Fouls;
            }
        }
        
        if (4 == i) { // 失误按钮
            (DataTypeScore == self.dataType) ? (resultBtn.typeName = TypeDataNone) : (resultBtn.typeName = Turnover);
        }
        
        if (5 == i) { // 3分球/进攻篮板按钮
            if (DataTypeScore == self.dataType) {
                resultBtn.typeName = ThreePointsHit;
                if (2 == self.ruleType) {
                    resultBtn.typeName = TwoPointsHit;
                }
            } else {
                resultBtn.typeName = OffensiveRebound;
            }
        }
        
        if (6 == i) { // 防守篮板按钮
            (DataTypeScore == self.dataType) ? (resultBtn.typeName = TypeDataNone) : (resultBtn.typeName = DefensiveRebound);
        }
        
        [resultBtn addTarget:self action:@selector(p_resultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.resultBtnArray addObject:resultBtn];
        [self addSubview:resultBtn];
    }
}

- (void)p_resultBtnClick:(CustomUIButton *)resultBtn {
    if ([resultBtn.typeName isEqualToString:TypeDataNone]) return;
    
    self.changeDataReturnBlock ? self.changeDataReturnBlock(self.indexPath, resultBtn.typeName) : nil;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    [self.titleLabArray enumerateObjectsUsingBlock:^(UILabel *titleLab, NSUInteger idx, BOOL * _Nonnull stop) {
        titleLab.text = titleArray[idx];
    }];
}

- (void)setResultArray:(NSArray *)resultArray {
    _resultArray = resultArray;
    
    [self.resultBtnArray enumerateObjectsUsingBlock:^(UIButton *resultBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultBtn setTitle:resultArray[idx] forState:UIControlStateNormal];
    }];
}

#pragma mark - update views with player model
- (void)setPlayerModel:(TSManagerPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    if ([self.titleArray[0] isEqualToString:@"助攻"]) { // 表示助攻、抢断、盖帽等数据
        [self p_updateBottomStatisticViewWithModel:_playerModel];
    } else { // 表示罚篮、2分、3分、总得分等数据
        [self p_updateTopStatisticViewWithModel:_playerModel];
    }
    
    if (playerModel.changeStatus) {
        // 根据修改状态，决定罚篮、二分球、三分球按钮是否可以被点击
        [self.resultBtnArray enumerateObjectsUsingBlock:^(CustomUIButton *resultBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![resultBtn.typeName isEqualToString:TypeDataNone]) { // 罚篮按钮、2分球按钮
                resultBtn.enabled = YES;
                [resultBtn setTitleColor:TSHEXCOLOR(0x10b4ff) forState:UIControlStateNormal];
            }
        }];
    } else {
        [self.resultBtnArray enumerateObjectsUsingBlock:^(CustomUIButton *resultBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![resultBtn.typeName isEqualToString:TypeDataNone]) { // 罚篮按钮、2分球按钮
                resultBtn.enabled = NO;
                [resultBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)p_updateBottomStatisticViewWithModel:(TSManagerPlayerModel *)playerModel {
    [self.resultBtnArray enumerateObjectsUsingBlock:^(UIButton *resultBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) { // 助攻
            [resultBtn setTitle:playerModel.behaviorNumb9 forState:UIControlStateNormal];
        } else if (1 == idx) { // 抢断
            [resultBtn setTitle:playerModel.behaviorNumb6 forState:UIControlStateNormal];
        } else if (2 == idx) { // 盖帽
            [resultBtn setTitle:playerModel.behaviorNumb8 forState:UIControlStateNormal];
        } else if (3 == idx) { // 犯规
            [resultBtn setTitle:playerModel.behaviorNumb10 forState:UIControlStateNormal];
        } else if (4 == idx) { // 失误
            [resultBtn setTitle:playerModel.behaviorNumb7 forState:UIControlStateNormal];
        } else if (5 == idx) { // 进攻篮板
            [resultBtn setTitle:playerModel.behaviorNumb4 forState:UIControlStateNormal];
        } else if (6 == idx) { // 防守篮板
            [resultBtn setTitle:playerModel.behaviorNumb5 forState:UIControlStateNormal];
        }
        
        if (0 == resultBtn.currentTitle.length) {
            [resultBtn setTitle:@"0" forState:UIControlStateNormal];
        }
    }];
}

- (void)p_updateTopStatisticViewWithModel:(TSManagerPlayerModel *)playerModel {
    [self.resultBtnArray enumerateObjectsUsingBlock:^(UIButton *resultBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (1 == idx || 2 == idx) { // 罚篮
            NSString *freeThowHit = @"";
            playerModel.FreeThrowHit.length ? (freeThowHit = playerModel.FreeThrowHit) : (freeThowHit = @"0");
            
            NSString *freeThow = @"";
            playerModel.behaviorNumb1.length ? (freeThow = playerModel.behaviorNumb1) : (freeThow = @"0");
            
            if (1 == idx) { // 罚篮
                NSString *FreeThrowResult = [NSString stringWithFormat:@"%@/%@", freeThowHit, freeThow];
                [resultBtn setTitle:FreeThrowResult forState:UIControlStateNormal];
            }
            
            if (2 == idx) { // 罚篮命中率
                NSString *percentage = @"0%";
                if (freeThow.intValue > 0) {
                    percentage = [NSString stringWithFormat:@"%.0f%%", (freeThowHit.floatValue/freeThow.floatValue)*100];
                }
                [resultBtn setTitle:percentage forState:UIControlStateNormal];
            }
        } else if (3 == idx || 4 == idx) { // 2分球或者1分球
            if (2 == self.ruleType) { // 3V3赛制
                NSString *onePointsHit = @"";
                playerModel.OnePointsHit.length ? (onePointsHit = playerModel.OnePointsHit) : (onePointsHit = @"0");
                
                NSString *onePoints = @"";
                playerModel.behaviorNumb31.length ? (onePoints = playerModel.behaviorNumb31) : (onePoints = @"0");
                
                if (3 == idx) { // 1分球
                    NSString *onePointsResult = [NSString stringWithFormat:@"%@/%@", onePointsHit, onePoints];
                    [resultBtn setTitle:onePointsResult forState:UIControlStateNormal];
                }
                
                if (4 == idx) { // 1分球命中率
                    NSString *percentage = @"0%";
                    if (onePoints.intValue > 0) {
                        percentage = [NSString stringWithFormat:@"%.0f%%", (onePointsHit.floatValue/onePoints.floatValue)*100];
                    }
                    [resultBtn setTitle:percentage forState:UIControlStateNormal];
                }
            } else { // 5V5赛制
                NSString *twoPointsHit = @"";
                playerModel.TwoPointsHit.length ? (twoPointsHit = playerModel.TwoPointsHit) : (twoPointsHit = @"0");
                
                NSString *twoPoints = @"";
                playerModel.behaviorNumb2.length ? (twoPoints = playerModel.behaviorNumb2) : (twoPoints = @"0");
                
                if (3 == idx) { // 2分球
                    NSString *twoPointsResult = [NSString stringWithFormat:@"%@/%@", twoPointsHit, twoPoints];
                    [resultBtn setTitle:twoPointsResult forState:UIControlStateNormal];
                }
                
                if (4 == idx) { // 2分球命中率
                    NSString *percentage = @"0%";
                    if (twoPoints.intValue > 0) {
                        percentage = [NSString stringWithFormat:@"%.0f%%", (twoPointsHit.floatValue/twoPoints.floatValue)*100];
                    }
                    [resultBtn setTitle:percentage forState:UIControlStateNormal];
                }
            }
        } else if (5 == idx || 6 == idx) { // 3分球或者2分球
            if (2 == self.ruleType) { // 3V3赛制
                NSString *twoPointsHit = @"";
                playerModel.TwoPointsHit.length ? (twoPointsHit = playerModel.TwoPointsHit) : (twoPointsHit = @"0");
                
                NSString *twoPoints = @"";
                playerModel.behaviorNumb2.length ? (twoPoints = playerModel.behaviorNumb2) : (twoPoints = @"0");
                
                if (5 == idx) { // 2分球
                    NSString *twoPointsResult = [NSString stringWithFormat:@"%@/%@", twoPointsHit, twoPoints];
                    [resultBtn setTitle:twoPointsResult forState:UIControlStateNormal];
                }
                
                if (6 == idx) { // 2分球命中率
                    NSString *percentage = @"0%";
                    if (twoPoints.intValue > 0) {
                        percentage = [NSString stringWithFormat:@"%.0f%%", (twoPointsHit.floatValue/twoPoints.floatValue)*100];
                    }
                    [resultBtn setTitle:percentage forState:UIControlStateNormal];
                }
            } else { // 5V5赛制
                NSString *threePointsHit = @"";
                playerModel.ThreePointsHit.length ? (threePointsHit = playerModel.ThreePointsHit) : (threePointsHit = @"0");
                
                NSString *threePoints = @"";
                playerModel.behaviorNumb3.length ? (threePoints = playerModel.behaviorNumb3) : (threePoints = @"0");
                
                if (5 == idx) { // 3分球
                    NSString *threePointsResult = [NSString stringWithFormat:@"%@/%@", threePointsHit, threePoints];
                    [resultBtn setTitle:threePointsResult forState:UIControlStateNormal];
                }
                
                if (6 == idx) { // 3分球命中率
                    NSString *percentage = @"0%";
                    if (threePoints.intValue > 0) {
                        percentage = [NSString stringWithFormat:@"%.0f%%", (threePointsHit.floatValue/threePoints.floatValue)*100];
                    }
                    [resultBtn setTitle:percentage forState:UIControlStateNormal];
                }
            }
        } else if (0 == idx) { // 得分
//            DDLog(@"%@ --- %@ --- %@ --- %@", playerModel.FreeThrowHit, playerModel.OnePointsHit, playerModel.TwoPointsHit, playerModel.ThreePointsHit);
            NSString *scoreResult = [NSString stringWithFormat:@"%d", playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3];
            [resultBtn setTitle:scoreResult forState:UIControlStateNormal];
            
            if ([self.titleArray[0] containsString:@"得"]) {
                [resultBtn setTitleColor:TSHEXCOLOR(0xff8686) forState:UIControlStateNormal];
            }
        }
        
        if (0 == resultBtn.currentTitle.length) {
            [resultBtn setTitle:@"0" forState:UIControlStateNormal];
        }
    }];
}
@end
