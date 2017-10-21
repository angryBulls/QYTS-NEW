//
//  TSPlayerDataCell.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPlayerDataCell.h"
#import "TSPlayerInfoView.h"
#import "TSPlayerStatisticView.h"
#import "TSManagerPlayerModel.h"

@interface TSPlayerDataCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) TSPlayerInfoView *playerInfoView;
@property (nonatomic, weak) TSPlayerStatisticView *topStatisticView;
@property (nonatomic, weak) TSPlayerStatisticView *botStatisticView;
@end

@implementation TSPlayerDataCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TSPlayerDataCell";
    TSPlayerDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TSPlayerDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(94.5);
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
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    // add top and bottom line
    [self p_addTopAndBottomLine];
    
    // add TSPlayerInfoView
    CGFloat playerInfoViewW = W(80);
    CGFloat playerInfoViewH = self.height - 1;
    TSPlayerInfoView *playerInfoView = [[TSPlayerInfoView alloc] initWithFrame:CGRectMake(0, 0, playerInfoViewW, playerInfoViewH)];
    [self.contentView addSubview:playerInfoView];
    self.playerInfoView = playerInfoView;
    
    // add top TSPlayerStatisticView
    CGFloat statisticViewX = self.playerInfoView.width - W(8);
    CGFloat topStatisticViewY = H(5);
    CGFloat statisticViewW = self.width - statisticViewX - W(8);
    CGFloat statisticViewH = (self.height - 1)*0.5 - topStatisticViewY;
    
    TSPlayerStatisticView *topStatisticView = [[TSPlayerStatisticView alloc] initWithFrame:CGRectMake(statisticViewX, topStatisticViewY, statisticViewW, statisticViewH) dataType:DataTypeScore changeDataReturnBlock:^(NSIndexPath *indexPath, NSString *dataType) {
        if ([self.delegate respondsToSelector:@selector(changePlayerDataAction:dataType:)]) {
            [self.delegate changePlayerDataAction:indexPath dataType:dataType];
        }
    }];
    topStatisticView.titleArray = @[@"得分", @"罚篮", @"命中率", @"二分球", @"命中率", @"三分球", @"命中率"];
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3X3
        topStatisticView.titleArray = @[@"得分", @"罚篮", @"命中率", @"一分球", @"命中率", @"二分球", @"命中率"];
        topStatisticView.ruleType = 2;
    }
    topStatisticView.resultArray = @[@"0", @"5/12", @"80%", @"5/12", @"80%", @"5/12", @"80%"];
    [self.contentView addSubview:topStatisticView];
    self.topStatisticView = topStatisticView;
    
    // add divid line
    [self p_addDividLine];
    
    // add bottom TSPlayerStatisticView
    CGFloat botStatisticViewY = CGRectGetMaxY(self.topStatisticView.frame);
    TSPlayerStatisticView *botStatisticView = [[TSPlayerStatisticView alloc] initWithFrame:CGRectMake(statisticViewX, botStatisticViewY, statisticViewW, statisticViewH)  dataType:DataTypeOther changeDataReturnBlock:^(NSIndexPath *indexPath, NSString *dataType) {
        if ([self.delegate respondsToSelector:@selector(changePlayerDataAction:dataType:)]) {
            [self.delegate changePlayerDataAction:indexPath dataType:dataType];
        }
    }];
    botStatisticView.titleArray = @[@"助攻", @"抢断", @"盖帽", @"犯规", @"失误", @"进攻篮板", @"防守篮板"];
    botStatisticView.resultArray = @[@"12", @"12", @"12", @"12", @"12", @"12", @"12"];
    [self.contentView addSubview:botStatisticView];
    self.botStatisticView = botStatisticView;
}

- (void)p_addTopAndBottomLine {
    CAShapeLayer *topline = [CAShapeLayer layer];
    CGFloat MarginX = W(13.5);
    topline.frame = CGRectMake(MarginX, 0, self.width - 2*MarginX, 0.5);
    topline.backgroundColor = TSHEXCOLOR(0xcacaca).CGColor;
    [self.contentView.layer addSublayer:topline];
    
    CAShapeLayer *bottomline = [CAShapeLayer layer];
    bottomline.frame = CGRectMake(MarginX, self.height - 0.5, self.width - 2*MarginX, 0.5);
    bottomline.backgroundColor = TSHEXCOLOR(0xcacaca).CGColor;
    [self.contentView.layer addSublayer:bottomline];
}

- (void)p_addDividLine {
    CAShapeLayer *dividLine = [CAShapeLayer layer];
    CGFloat DividLineX = self.topStatisticView.x + W(10);
    CGFloat DividLineY = CGRectGetMaxY(self.topStatisticView.frame) + 0.5;
    CGFloat DividLineW = self.topStatisticView.width - W(16);
    CGFloat DividLineH = 0.5;
    dividLine.frame = CGRectMake(DividLineX, DividLineY, DividLineW, DividLineH);
    dividLine.backgroundColor = TSHEXCOLOR(0xcacaca).CGColor;
    [self.contentView.layer addSublayer:dividLine];
}

#pragma mark - update views with player model
- (void)setPlayerModel:(TSManagerPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    self.playerInfoView.playerModel = playerModel;
    self.topStatisticView.playerModel = playerModel;
    self.botStatisticView.playerModel = playerModel;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.topStatisticView.indexPath = indexPath;
    self.botStatisticView.indexPath = indexPath;
}
@end
