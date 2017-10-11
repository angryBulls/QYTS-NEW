//
//  MyGameHeaderView.m
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MyGameHeaderView.h"
#import "RulesSegmentView.h"
#import "MyGameOverModel.h"

@interface MyGameHeaderView ()
@property (nonatomic, weak) UILabel *dateRangeLab;
@property (nonatomic, weak) UILabel *game5CountLab;
@property (nonatomic, weak) UILabel *game3CountLab;
@end

@implementation MyGameHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add date range label
    CGFloat dateRangeLabY = H(10);
    CGFloat dateRangeLabW = self.width;
    CGFloat dateRangeLabH = H(33);
    UILabel *dateRangeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, dateRangeLabY, dateRangeLabW, dateRangeLabH)];
    dateRangeLab.font = [UIFont systemFontOfSize:W(15.0)];
    dateRangeLab.textColor = TSHEXCOLOR(0xffffff);
    dateRangeLab.text = @" ";
    dateRangeLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dateRangeLab];
    self.dateRangeLab = dateRangeLab;
    
    // add 5V5 game count label
    CGFloat labMargin = W(18.5);
    CGFloat game5CountLabX = 0;
    CGFloat game5CountLabY = CGRectGetMaxY(self.dateRangeLab.frame);
    CGFloat game5CountLabW = (self.width - labMargin)*0.5;
    CGFloat game5CountLabH = H(33);
    UILabel *game5CountLab = [[UILabel alloc] initWithFrame:CGRectMake(game5CountLabX, game5CountLabY, game5CountLabW, game5CountLabH)];
    game5CountLab.font = [UIFont systemFontOfSize:W(15.0)];
    game5CountLab.textColor = TSHEXCOLOR(0xffffff);
    game5CountLab.text = @" ";
    game5CountLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:game5CountLab];
    self.game5CountLab = game5CountLab;
    
    CGFloat game3CountLabW = game5CountLabW;
    CGFloat game3CountLabX = self.width - game3CountLabW;
    CGFloat game3CountLabY = game5CountLabY;
    CGFloat game3CountLabH = game5CountLabH;
    UILabel *game3CountLab = [[UILabel alloc] initWithFrame:CGRectMake(game3CountLabX, game3CountLabY, game3CountLabW, game3CountLabH)];
    game3CountLab.font = [UIFont systemFontOfSize:W(15.0)];
    game3CountLab.textColor = TSHEXCOLOR(0xffffff);
    game3CountLab.text = @" ";
    [self addSubview:game3CountLab];
    self.game3CountLab = game3CountLab;
    
    // add RulesSegmentView
    CGFloat rulesSegViewH = H(40);
    CGFloat rulesSegViewY = self.height - rulesSegViewH;
    RulesSegmentView *rulesSegView = [[RulesSegmentView alloc] initWithFrame:CGRectMake(0, rulesSegViewY, self.width, rulesSegViewH) returnBlcok:^(NSUInteger index) {
        RulesSelect rulesSelect = RulesSelect5V5;
        if (0 == index) {
            rulesSelect = RulesSelect5V5;
        } else {
            rulesSelect = RulesSelect3V3;
        }
        
        if ([self.delegate respondsToSelector:@selector(gameRulesSelect:)]) {
            [self.delegate gameRulesSelect:rulesSelect];
        }
    }];
    rulesSegView.touchDownBtnRepeatBlock = ^(UIButton *btn) { // 按钮双击
        if ([self.delegate respondsToSelector:@selector(touchDownBtnRepeat:)]) {
            [self.delegate touchDownBtnRepeat:btn];
        }
    };
    [self addSubview:rulesSegView];
}

- (void)setGameOverModel:(MyGameOverModel *)gameOverModel {
    _gameOverModel = gameOverModel;
    
    self.dateRangeLab.text = [NSString stringWithFormat:@"自%@ 至 %@", gameOverModel.beginDate, gameOverModel.endDate];
    if (gameOverModel.count5V5.length) {
        self.game5CountLab.text = [NSString stringWithFormat:@"5V5比赛%@场", gameOverModel.count5V5];
        NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:self.game5CountLab.text];
        [attrsString addAttribute:NSForegroundColorAttributeName value:TSHEXCOLOR(0x8CDBFF) range:NSMakeRange(5, gameOverModel.count5V5.length)];
        self.game5CountLab.attributedText = attrsString;
    }
    if (gameOverModel.count3V3.length) {
        self.game3CountLab.text = [NSString stringWithFormat:@"3V3比赛%@场", gameOverModel.count3V3];
        NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:self.game3CountLab.text];
        [attrsString addAttribute:NSForegroundColorAttributeName value:TSHEXCOLOR(0x8CDBFF) range:NSMakeRange(5, gameOverModel.count3V3.length)];
        self.game3CountLab.attributedText = attrsString;
    }
}
@end
