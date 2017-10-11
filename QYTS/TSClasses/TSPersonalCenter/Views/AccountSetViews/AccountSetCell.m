//
//  AccountSetCell.m
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AccountSetCell.h"
#import "UIView+Extension.h"
#import "EditInfoCellModel.h"

@interface AccountSetCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *contentLab;
@property (nonatomic, weak) UIImageView *arrowImageView;
@end

@implementation AccountSetCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AccountSetCell";
    AccountSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AccountSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    // add title label
    CGFloat titleLabX = 0;
    CGFloat titleLabY = 0;
    CGFloat titleLabW = W(100);
    CGFloat titleLabH = self.height;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    titleLab.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // add content label
    CGFloat contentLabX = self.titleLab.width;
    CGFloat contentLabY = 0;
    CGFloat contentLabW = self.bgView.width - self.titleLab.width - self.height;
    CGFloat contentLabH = self.height;
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(contentLabX, contentLabY, contentLabW, contentLabH)];
    contentLab.font = [UIFont systemFontOfSize:W(15.0)];
    contentLab.textColor = TSHEXCOLOR(0xffffff);
    contentLab.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:contentLab];
    self.contentLab = contentLab;
    
    // add right arrow image
    UIImage *image = [UIImage imageNamed:@"right_arrow_icon"];
    CGFloat arrowImageViewWH = self.bgView.height;
    CGFloat arrowImageViewY = 0;
    CGFloat arrowImageViewX = self.bgView.width - arrowImageViewWH + W(8);
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowImageViewX, arrowImageViewY, arrowImageViewWH, arrowImageViewWH)];
    arrowImageView.image = image;
    arrowImageView.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:arrowImageView];
    
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
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

- (void)setInfoCellModel:(EditInfoCellModel *)infoCellModel {
    _infoCellModel = infoCellModel;
    
    self.titleLab.text = infoCellModel.title;
    if ([infoCellModel.title containsString:@"密码"]) {
        self.contentLab.text = @"修改密码";
    } else {
        self.contentLab.text = infoCellModel.content;
    }
}
@end
