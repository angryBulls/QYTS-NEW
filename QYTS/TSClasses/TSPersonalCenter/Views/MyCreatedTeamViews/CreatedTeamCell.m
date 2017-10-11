//
//  CreatedTeamCell.m
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreatedTeamCell.h"
#import "UIView+Extension.h"
#import "CreatedTeamInfoModel.h"

@interface CreatedTeamCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *teamNameLab;
@property (nonatomic, weak) UILabel *createDateLab;
@end

@implementation CreatedTeamCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CreatedTeamCell";
    CreatedTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CreatedTeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(49);
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
    
    // add top line
    CGFloat topLineX = W(8);
    CGFloat topLineW = self.bgView.width - 2*topLineX;
    CGFloat topLineH = 0.5;
    CGFloat topLineY = 0;
    CAShapeLayer *topLine = [[CAShapeLayer alloc] init];
    topLine.frame = CGRectMake(topLineX, topLineY, topLineW, topLineH);
    topLine.backgroundColor = TSHEXCOLOR(0xffffff).CGColor;
    topLine.opacity = 0.3;
    [self.bgView.layer addSublayer:topLine];
    self.topLine = topLine;
    
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
    
    // add team name label
    CGFloat teamNameLabX = W(20);
    CGFloat teamNameLabW = self.bgView.width*0.5 - teamNameLabX;
    UILabel *teamNameLab = [[UILabel alloc] initWithFrame:CGRectMake(teamNameLabX, 0, teamNameLabW, self.bgView.height)];
    teamNameLab.font = [UIFont systemFontOfSize:W(14.0)];
    teamNameLab.textColor = TSHEXCOLOR(0xffffff);
    [self.bgView addSubview:teamNameLab];
    self.teamNameLab = teamNameLab;
    
    // add displayCreateDate label
    CGFloat createDateLabW = self.bgView.width*0.5 - W(24.5);
    UILabel *createDateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.width*0.5, 0, createDateLabW, self.bgView.height)];
    createDateLab.font = [UIFont systemFontOfSize:W(13.0)];
    createDateLab.textColor = TSHEXCOLOR(0xffffff);
    createDateLab.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:createDateLab];
    self.createDateLab = createDateLab;
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

- (void)setTeamInfoModel:(CreatedTeamInfoModel *)teamInfoModel {
    _teamInfoModel = teamInfoModel;
    
    self.teamNameLab.text = teamInfoModel.teamName;
    self.createDateLab.text = teamInfoModel.displayCreateDate;
}
@end
