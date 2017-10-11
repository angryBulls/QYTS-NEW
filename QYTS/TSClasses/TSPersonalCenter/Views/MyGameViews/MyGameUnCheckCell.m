//
//  MyGameUnCheckCell.m
//  QYTS
//
//  Created by lxd on 2017/9/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MyGameUnCheckCell.h"
#import "UIView+Extension.h"
#import "MyGameOverListModel.h"

@interface MyGameUnCheckCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *homeTeamNameLab;
@property (nonatomic, weak) UILabel *awayTeamNameLab;
@property (nonatomic, weak) UIButton *checkBtn;
@property (nonatomic, weak) UILabel *gameDateLab;
@end

@implementation MyGameUnCheckCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MyGameUnCheckCell";
    MyGameUnCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyGameUnCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(72);
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add bg view
    CGFloat bgViewX = W(7.5);
    CGFloat bgViewY = -0.5;
    CGFloat bgViewW = self.width - 2*bgViewX;
    CGFloat bgViewH = self.height + 1;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    // add bottom line
    CGFloat bottomLineX = W(8);
    CGFloat bottomLineW = self.bgView.width - 2*bottomLineX;
    CGFloat bottomLineH = 0.5;
    CGFloat bottomLineY = self.height - bottomLineH;
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    bottomLine.backgroundColor = TSHEXCOLOR(0xffffff).CGColor;
    bottomLine.opacity = 0.3;
    [self.bgView.layer addSublayer:bottomLine];
    self.bottomLine = bottomLine;
    
    // add host name label
    CGFloat homeTeamNameLabX = W(21);
    CGFloat homeTeamNameLabY = H(8);
    CGFloat homeTeamNameLabW = W(83);
    CGFloat homeTeamNameLabH = self.bgView.height - 2*homeTeamNameLabY;
    UILabel *homeTeamNameLab = [[UILabel alloc] initWithFrame:CGRectMake(homeTeamNameLabX, homeTeamNameLabY, homeTeamNameLabW, homeTeamNameLabH)];
    homeTeamNameLab.font = [UIFont systemFontOfSize:W(14.0)];
    homeTeamNameLab.textColor = TSHEXCOLOR(0xffffff);
    homeTeamNameLab.text = @"主队名称";
    homeTeamNameLab.textAlignment = NSTextAlignmentCenter;
    homeTeamNameLab.numberOfLines = 0;
    [self addSubview:homeTeamNameLab];
    self.homeTeamNameLab = homeTeamNameLab;
    
    // add VS imageView
    UIImage *vsImage = [UIImage imageNamed:@"my_game_VS_icon"];
    CGFloat vsImageViewH = H(37.5);
    CGFloat vsImageViewY = (self.bgView.height - vsImageViewH)*0.5;
    UIImageView *vsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.homeTeamNameLab.frame) + W(15), vsImageViewY, W(28), vsImageViewH)];
    vsImageView.image = vsImage;
    [self.bgView addSubview:vsImageView];
    
    // add guest name label
    CGFloat awayTeamNameLabX = CGRectGetMaxX(vsImageView.frame) + W(15);
    CGFloat awayTeamNameLabY = H(8);
    CGFloat awayTeamNameLabW = W(83);
    CGFloat awayTeamNameLabH = self.bgView.height - 2*awayTeamNameLabY;
    UILabel *awayTeamNameLab = [[UILabel alloc] initWithFrame:CGRectMake(awayTeamNameLabX, awayTeamNameLabY, awayTeamNameLabW, awayTeamNameLabH)];
    awayTeamNameLab.font = [UIFont systemFontOfSize:W(14.0)];
    awayTeamNameLab.textColor = TSHEXCOLOR(0xffffff);
    awayTeamNameLab.text = @"客队名称";
    awayTeamNameLab.textAlignment = NSTextAlignmentCenter;
    awayTeamNameLab.numberOfLines = 0;
    [self addSubview:awayTeamNameLab];
    self.awayTeamNameLab = awayTeamNameLab;
    
    // add check button
    CGFloat checkBtnW = W(74);
    CGFloat checkBtnX = self.bgView.width - checkBtnW - W(22);
    CGFloat checkBtnY = H(12);
    CGFloat checkBtnH = H(24);
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(checkBtnX, checkBtnY, checkBtnW, checkBtnH)];
    [checkBtn setTitle:@"进入检录" forState:UIControlStateNormal];
    [checkBtn setTitleColor:TSHEXCOLOR(0x8CDBFF) forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
    checkBtn.layer.borderColor = TSHEXCOLOR(0x8CDBFF).CGColor;
    checkBtn.layer.borderWidth = 1.0;
    checkBtn.layer.masksToBounds = YES;
    checkBtn.layer.cornerRadius = W(7);
    [checkBtn addTarget:self action:@selector(p_checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:checkBtn];
    self.checkBtn = checkBtn;
    
    // add game date label
    CGFloat gameDateLabY = CGRectGetMaxY(self.checkBtn.frame);
    CGFloat gameDateLabW = W(85);
    CGFloat gameDateLabH = H(24.5);
    UILabel *gameDateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, gameDateLabY, gameDateLabW, gameDateLabH)];
    gameDateLab.centerX = self.checkBtn.centerX;
    gameDateLab.font = [UIFont systemFontOfSize:W(13.0)];
    gameDateLab.textColor = TSHEXCOLOR(0xffffff);
    gameDateLab.text = @" ";
    gameDateLab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:gameDateLab];
    self.gameDateLab = gameDateLab;
}

- (void)p_checkBtnClick {
    if ([self.delegate respondsToSelector:@selector(getModelWithCheckBtnClick:)]) {
        [self.delegate getModelWithCheckBtnClick:self.gameOverListModel];
    }
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

- (void)setGameOverListModel:(MyGameOverListModel *)gameOverListModel {
    _gameOverListModel = gameOverListModel;
    
    self.homeTeamNameLab.text = gameOverListModel.homeTeamName;
    self.awayTeamNameLab.text = gameOverListModel.awayTeamName;
    self.gameDateLab.text = gameOverListModel.matchDateDisplay;
}
@end
