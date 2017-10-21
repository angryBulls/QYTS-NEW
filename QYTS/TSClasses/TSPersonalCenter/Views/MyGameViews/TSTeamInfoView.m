//
//  TSTeamInfoView.m
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSTeamInfoView.h"
#import "ShareMatchInfoModel.h"

@interface TeamInfoSubView : UIView
@property (nonatomic, weak) UILabel *topLab;
@property (nonatomic, weak) UILabel *bottomLab;

@property (nonatomic, copy) NSString *topName;
@property (nonatomic, copy) NSString *bottomName;
@end

@implementation TeamInfoSubView
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
    topLab.textColor = TSHEXCOLOR(0xF9A204);
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

@interface TSTeamInfoView ()
@property (nonatomic, weak) UILabel *gameDateLab;
@property (nonatomic, weak) TeamInfoSubView *hostInfoView;
@property (nonatomic, weak) TeamInfoSubView *guestInfoView;
@property (nonatomic, weak) UILabel *ruleTypeLab;
@end

@implementation TSTeamInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add game date label
    CGFloat gameDateLabH = H(50);
    UILabel *gameDateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, gameDateLabH)];
    gameDateLab.font = [UIFont systemFontOfSize:W(13.0)];
    gameDateLab.textColor = TSHEXCOLOR(0x618ABC);
    gameDateLab.textAlignment = NSTextAlignmentCenter;
    gameDateLab.text = @"";
    [self addSubview:gameDateLab];
    self.gameDateLab = gameDateLab;
    
    // add host info subView
    CGFloat hostInfoViewX = W(47.5);
    CGFloat hostInfoViewY = self.gameDateLab.height;
    CGFloat hostInfoViewW = W(83);
    CGFloat hostInfoViewH = self.height - hostInfoViewY;
    TeamInfoSubView *hostInfoView = [[TeamInfoSubView alloc] initWithFrame:CGRectMake(hostInfoViewX, hostInfoViewY, hostInfoViewW, hostInfoViewH)];
    hostInfoView.topName = @"主队";
    hostInfoView.topLab.textColor = TSHEXCOLOR(0xF9A204);
    [self addSubview:hostInfoView];
    self.hostInfoView = hostInfoView;
    
    // add VS imageView
    UIImage *vsImage = [UIImage imageNamed:@"my_game_VS_icon"];
    CGFloat vsImageViewH = H(37.5);
    CGFloat vsImageViewY = self.gameDateLab.height;
    UIImageView *vsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, vsImageViewY, W(28), vsImageViewH)];
    vsImageView.centerX = self.width*0.5;
    vsImageView.image = vsImage;
    [self addSubview:vsImageView];
    
    // add rule type label
    CGFloat ruleTypeLabY = CGRectGetMaxY(vsImageView.frame) + 2;
    CGFloat ruleTypeLabH = H(20);
    UILabel *ruleTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ruleTypeLabY, vsImageView.width, ruleTypeLabH)];
    ruleTypeLab.centerX = self.width*0.5;
    ruleTypeLab.font = [UIFont systemFontOfSize:W(13.0)];
    ruleTypeLab.textColor = TSHEXCOLOR(0xffffff);
    ruleTypeLab.textAlignment = NSTextAlignmentCenter;
    ruleTypeLab.layer.masksToBounds = YES;
    ruleTypeLab.layer.cornerRadius = W(4);
    ruleTypeLab.layer.borderWidth = 0.5;
    ruleTypeLab.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    ruleTypeLab.text = @"5V5";
    [self addSubview:ruleTypeLab];
    self.ruleTypeLab = ruleTypeLab;
    
    // add guest info subView
    CGFloat guestInfoViewW = W(83);
    CGFloat guestInfoViewX = self.width - guestInfoViewW - hostInfoViewX;
    CGFloat guestInfoViewY = hostInfoViewY;
    CGFloat guestInfoViewH = hostInfoViewH;
    TeamInfoSubView *guestInfoView = [[TeamInfoSubView alloc] initWithFrame:CGRectMake(guestInfoViewX, guestInfoViewY, guestInfoViewW, guestInfoViewH)];
    guestInfoView.topName = @"客队";
    guestInfoView.topLab.textColor = TSHEXCOLOR(0x30E45F);
    [self addSubview:guestInfoView];
    self.guestInfoView = guestInfoView;
}

- (void)setMatchInfoModel:(ShareMatchInfoModel *)matchInfoModel {
    _matchInfoModel = matchInfoModel;
    
    if (matchInfoModel.matchTime.length > 10) {
        self.gameDateLab.text = [matchInfoModel.matchTime substringToIndex:10];
    }
    self.hostInfoView.bottomName = matchInfoModel.homeTeamName;
    self.guestInfoView.bottomName = matchInfoModel.awayTeamName;
    if (2 == matchInfoModel.ruleType.intValue) {
        self.ruleTypeLab.text = @"3X3";
    }
}
@end
