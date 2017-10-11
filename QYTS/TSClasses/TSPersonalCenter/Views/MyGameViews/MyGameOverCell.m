//
//  MyGameOverCell.m
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MyGameOverCell.h"
#import "UIView+Extension.h"
#import "MyGameOverListModel.h"

@interface MyGameOverSubView : UIView
@property (nonatomic, weak) UILabel *topLab;
@property (nonatomic, weak) UILabel *bottomLab;

@property (nonatomic, copy) NSString *topName;
@property (nonatomic, copy) NSString *bottomName;
@end

@implementation MyGameOverSubView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add top label
    CGFloat labW = self.width;
    CGFloat topLabH = self.height*0.35;
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labW, topLabH)];
    topLab.font = [UIFont boldSystemFontOfSize:W(17.0)];
    topLab.textColor = TSHEXCOLOR(0xffffff);
    topLab.text = @"0";
    topLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:topLab];
    self.topLab = topLab;
    
    // add bottm label
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, topLabH, labW, self.height - topLabH)];
    bottomLab.font = [UIFont systemFontOfSize:W(14.0)];
    bottomLab.textColor = TSHEXCOLOR(0xffffff);
    bottomLab.text = @"队名";
    bottomLab.textAlignment = NSTextAlignmentCenter;
    bottomLab.numberOfLines = 0;
    [self addSubview:bottomLab];
    self.bottomLab = bottomLab;
}

- (void)setTopName:(NSString *)topName {
    _topName = topName;
    self.topLab.text = topName;
}

- (void)setBottomName:(NSString *)bottomName {
    _bottomName = bottomName;
    self.bottomLab.text = bottomName;
}
@end
// ***********************************************************************************************
@interface MyGameOverCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) MyGameOverSubView *hostInfoView;
@property (nonatomic, weak) MyGameOverSubView *guestInfoView;
@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UILabel *gameDateLab;
@end

@implementation MyGameOverCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MyGameOverCell";
    MyGameOverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyGameOverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    // add host info subView
    CGFloat hostInfoViewX = W(21);
    CGFloat hostInfoViewY = H(8);
    CGFloat hostInfoViewW = W(83);
    CGFloat hostInfoViewH = self.bgView.height - 2*hostInfoViewY;
    MyGameOverSubView *hostInfoView = [[MyGameOverSubView alloc] initWithFrame:CGRectMake(hostInfoViewX, hostInfoViewY, hostInfoViewW, hostInfoViewH)];
    [self.bgView addSubview:hostInfoView];
    self.hostInfoView = hostInfoView;
    
    // add VS imageView
    UIImage *vsImage = [UIImage imageNamed:@"my_game_VS_icon"];
    CGFloat vsImageViewH = H(37.5);
    CGFloat vsImageViewY = (self.bgView.height - vsImageViewH)*0.5;
    UIImageView *vsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hostInfoView.frame) + W(15), vsImageViewY, W(28), vsImageViewH)];
    vsImageView.image = vsImage;
    [self.bgView addSubview:vsImageView];
    
    // add guest info subView
    CGFloat guestInfoViewX = CGRectGetMaxX(vsImageView.frame) + W(15);
    CGFloat guestInfoViewY = H(8);
    CGFloat guestInfoViewW = W(83);
    CGFloat guestInfoViewH = self.bgView.height - 2*hostInfoViewY;
    MyGameOverSubView *guestInfoView = [[MyGameOverSubView alloc] initWithFrame:CGRectMake(guestInfoViewX, guestInfoViewY, guestInfoViewW, guestInfoViewH)];
    [self.bgView addSubview:guestInfoView];
    self.guestInfoView = guestInfoView;
    
    // add share button
    CGFloat shareBtnW = W(60);
    CGFloat shareBtnX = self.bgView.width - shareBtnW - W(30);
    CGFloat shareBtnY = H(12);
    CGFloat shareBtnH = H(24);
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtnX, shareBtnY, shareBtnW, shareBtnH)];
    [shareBtn setTitle:@"已分享" forState:UIControlStateDisabled];
    [shareBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateDisabled];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:TSHEXCOLOR(0x8CDBFF) forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
    [shareBtn addTarget:self action:@selector(p_shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:shareBtn];
    self.shareBtn = shareBtn;
    
    // add game date label
    CGFloat gameDateLabY = CGRectGetMaxY(self.shareBtn.frame);
    CGFloat gameDateLabW = W(85);
    CGFloat gameDateLabH = H(24.5);
    UILabel *gameDateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, gameDateLabY, gameDateLabW, gameDateLabH)];
    gameDateLab.centerX = self.shareBtn.centerX;
    gameDateLab.font = [UIFont systemFontOfSize:W(13.0)];
    gameDateLab.textColor = TSHEXCOLOR(0xffffff);
    gameDateLab.text = @"2017-9-20";
    gameDateLab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:gameDateLab];
    self.gameDateLab = gameDateLab;
}

- (void)p_shareBtnClick {
    if ([self.delegate respondsToSelector:@selector(shareAction:)]) {
        [self.delegate shareAction:self.gameOverListModel];
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
    
    if (gameOverListModel.homeScore.length) {
        self.hostInfoView.topName = gameOverListModel.homeScore;
        if ([gameOverListModel.homeScore isEqualToString:@"999"]) { // 客队弃权
            self.hostInfoView.topName = @"W";
        }
    }
    self.hostInfoView.bottomName = gameOverListModel.homeTeamName;
    if (gameOverListModel.awayScore.length) {
        self.guestInfoView.topName = gameOverListModel.awayScore;
        if ([gameOverListModel.awayScore isEqualToString:@"999"]) { // 主队弃权
            self.guestInfoView.topName = @"W";
        }
    }
    self.guestInfoView.bottomName = gameOverListModel.awayTeamName;
    if (gameOverListModel.shareNum.intValue) {
        self.shareBtn.enabled = NO;
        self.shareBtn.layer.borderWidth = 0;
    } else {
        self.shareBtn.enabled = YES;
        self.shareBtn.layer.borderColor = TSHEXCOLOR(0x8CDBFF).CGColor;
        self.shareBtn.layer.borderWidth = 1.0;
        self.shareBtn.layer.masksToBounds = YES;
        self.shareBtn.layer.cornerRadius = W(7);
    }
    self.gameDateLab.text = gameOverListModel.matchDateDisplay;
}
@end
