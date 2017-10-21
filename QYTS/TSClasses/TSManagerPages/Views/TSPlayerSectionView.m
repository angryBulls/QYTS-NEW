//
//  TSPlayerSectionView.m
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPlayerSectionView.h"
#import "UIView+Extension.h"

@interface TSPlayerSectionView ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *teamtypeLab;
@property (nonatomic, weak) UILabel *teamNameLab;
@end

@implementation TSPlayerSectionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
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
    [bgView setRectCornerWithStyle:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:W(5)];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    // add team type lebel
    CGFloat teamtypeLabX = 0;
    CGFloat teamtypeLabY = 0;
    CGFloat teamtypeLabW = W(60);
    CGFloat teamtypeLabH = self.height;
    UILabel *teamtypeLab = [[UILabel alloc] initWithFrame:CGRectMake(teamtypeLabX, teamtypeLabY, teamtypeLabW, teamtypeLabH)];
    teamtypeLab.font = [UIFont boldSystemFontOfSize:W(15.0)];
    teamtypeLab.textColor = TSHEXCOLOR(0xf9a204);
    teamtypeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:teamtypeLab];
    self.teamtypeLab = teamtypeLab;
    
    // add team name label
    CGFloat teamNameLabX = teamtypeLabW;
    CGFloat teamNameLabY = 0;
    CGFloat teamNameLabW = W(250);
    CGFloat teamNameLabH = self.height;
    UILabel *teamNameLab = [[UILabel alloc] initWithFrame:CGRectMake(teamNameLabX, teamNameLabY, teamNameLabW, teamNameLabH)];
    teamNameLab.font = [UIFont boldSystemFontOfSize:W(13.0)];
    teamNameLab.textColor = TSHEXCOLOR(0xf9a204);
    [self addSubview:teamNameLab];
    self.teamNameLab = teamNameLab;
    
    // add change data button
    CGFloat changeBtnW = W(55);
    CGFloat changeBtnH = H(23);
    CGFloat changeBtnX = self.width - changeBtnW - W(14);
    CGFloat changeBtnY = (self.height - changeBtnH)*0.5;
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(changeBtnX, changeBtnY, changeBtnW, changeBtnH);
    [changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [changeBtn setTitle:@"完成" forState:UIControlStateSelected];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:W(15.0)];
    [changeBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.cornerRadius = W(5);
    changeBtn.layer.borderWidth = 0.5;
    changeBtn.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    [changeBtn addTarget:self action:@selector(p_changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeBtn];
    self.changeBtn = changeBtn;
}

- (void)p_changeBtnClick:(UIButton *)changeBtn {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if ([gameTableDict[GameStatus] isEqualToString:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"本场比赛已结束，无法修改"];
        return;
    }
    
    changeBtn.selected = !changeBtn.selected;
    
    if ([self.delegate respondsToSelector:@selector(changeBtnClick:)]) {
        [self.delegate changeBtnClick:self];
    }
}

- (void)setTeamType:(NSString *)teamType {
    _teamType = teamType;
    
    // 获取主客队颜色
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    NSArray *hostGuestTeamColorarray = [calculationTool getHostTeamAndGuestTeamColor];
    
    self.teamtypeLab.text = teamType;
    if ([teamType containsString:@"主"]) {
        if (hostGuestTeamColorarray[0] == [UIColor clearColor]) {
            self.teamtypeLab.textColor = TSHEXCOLOR(0xffffff);
            self.teamNameLab.textColor = TSHEXCOLOR(0xffffff);
        } else {
            self.teamtypeLab.textColor = hostGuestTeamColorarray[0];
            self.teamNameLab.textColor = hostGuestTeamColorarray[0];
        }
    } else {
        if (hostGuestTeamColorarray[1] == [UIColor clearColor]) {
            self.teamtypeLab.textColor = TSHEXCOLOR(0xffffff);
            self.teamNameLab.textColor = TSHEXCOLOR(0xffffff);
        } else {
            self.teamtypeLab.textColor = hostGuestTeamColorarray[1];
            self.teamNameLab.textColor = hostGuestTeamColorarray[1];
        }
    }
}

- (void)setTeamName:(NSString *)teamName {
    _teamName = teamName;
    
    self.teamNameLab.text = teamName;
}
@end
