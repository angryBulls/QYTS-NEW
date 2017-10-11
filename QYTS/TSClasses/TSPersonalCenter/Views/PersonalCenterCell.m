//
//  PersonalCenterCell.m
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalCenterCell.h"
#import "UIView+Extension.h"

@interface PersonalCenterCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) CAShapeLayer *bottomLine;
@property (nonatomic, weak) UIImageView *arrowImageView;
@end

@implementation PersonalCenterCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PersonalCenterCell";
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PersonalCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(60);
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
    
    // add left image
    CGFloat leftImageViewX = 0;
    CGFloat leftImageViewY = 0;
    CGFloat leftImageViewWH = self.height;
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImageViewX, leftImageViewY, leftImageViewWH, leftImageViewWH)];
    leftImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    // add title label
    CGFloat titleLabX = leftImageViewWH;
    CGFloat titleLabY = 0;
    CGFloat titleLabW = self.width - leftImageViewWH - W(60);
    CGFloat titleLabH = self.height;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    [self.bgView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // add right arrow image
    UIImage *image = [UIImage imageNamed:@"right_arrow_icon"];
    CGFloat arrowImageViewWH = self.height;
    CGFloat arrowImageViewX = self.bgView.width - arrowImageViewWH + W(8);
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowImageViewX, 0, arrowImageViewWH, arrowImageViewWH)];
    arrowImageView.image = image;
    arrowImageView.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    // add bottom line
    CGFloat bottomLineX = leftImageViewWH;
    CGFloat bottomLineW = self.bgView.width - bottomLineX - W(10);
    CGFloat bottomLineH = 0.5;
    CGFloat bottomLineY = self.height - bottomLineH;
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    bottomLine.backgroundColor = TSHEXCOLOR(0xffffff).CGColor;
    bottomLine.opacity = 0.3;
    [self.bgView.layer addSublayer:bottomLine];
    self.bottomLine = bottomLine;
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
    
    self.leftImageView.image = [UIImage imageNamed:contentArray[0]];
    self.titleLab.text = contentArray[1];
    if ([(NSString *)contentArray[1] containsString:@"客服"]) {
        self.bottomLine.hidden = YES;
    } else {
        self.bottomLine.hidden = NO;
    }
}
@end
