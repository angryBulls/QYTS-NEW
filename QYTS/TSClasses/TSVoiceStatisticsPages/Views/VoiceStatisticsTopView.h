//
//  VoiceStatisticsTopView.h
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageType) {
    PageTypeVoice,
    PageTypeSection,
    PageTypeFull
};

typedef NS_ENUM(NSInteger, TimeCountType) { // 计时方式
    TimeCountTypeDown,
    TimeCountTypeUp
};

@class TSGameModel;

@interface VoiceStatisticsTopView : UIView
@property (nonatomic, assign) TimeCountType timeCountType;
@property (nonatomic, assign) int currentSecond;
@property (nonatomic, weak) UILabel *countDownLab;
@property (nonatomic, weak) UIButton *startBtn;
@property (nonatomic, strong) TSGameModel *gameModel;

- (instancetype)initWithFrame:(CGRect)frame pageType:(PageType)pageType;
@end
