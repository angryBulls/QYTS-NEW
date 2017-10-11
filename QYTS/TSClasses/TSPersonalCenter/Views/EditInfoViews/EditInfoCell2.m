//
//  EditInfoCell2.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "EditInfoCell2.h"
#import "EditInfoCellModel.h"
#import "UIView+Extension.h"

@interface EditInfoCell2 ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *contentLab;
@end

@implementation EditInfoCell2
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EditInfoCell2";
    EditInfoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditInfoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGFloat titleLabX = W(12.5);
    CGFloat titleLabY = 0;
    CGFloat titleLabW = W(65);
    CGFloat titleLabH = self.bgView.height;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    [self.bgView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // add content label
    CGFloat contentLabX = CGRectGetMaxX(self.titleLab.frame);
    CGFloat contentLabY = 0;
    CGFloat contentLabW = self.bgView.width - contentLabX - W(22);
    CGFloat contentLabH = self.bgView.height;
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(contentLabX, contentLabY, contentLabW, contentLabH)];
    contentLab.font = [UIFont systemFontOfSize:W(15.0)];
    contentLab.textColor = TSHEXCOLOR(0xffffff);
    contentLab.numberOfLines = 0;
    [self.bgView addSubview:contentLab];
    self.contentLab = contentLab;
    
    // add bottom line
    CGFloat bottomLineX = contentLab.x;
    CGFloat bottomLineW = contentLab.width + W(10);
    CGFloat bottomLineH = 0.5;
    CGFloat bottomLineY = self.bgView.height - bottomLineH - H(15);
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    bottomLine.backgroundColor = TSHEXCOLOR(0xffffff).CGColor;
    bottomLine.opacity = 0.3;
    [self.bgView.layer addSublayer:bottomLine];
    
    // add right arrow image
    UIImage *image = [UIImage imageNamed:@"right_arrow_icon"];
    CGFloat arrowImageViewWH = self.bgView.height;
    CGFloat arrowImageViewY = 0;
    CGFloat arrowImageViewX = self.bgView.width - arrowImageViewWH + W(8);
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowImageViewX, arrowImageViewY, arrowImageViewWH, arrowImageViewWH)];
    arrowImageView.image = image;
    arrowImageView.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:arrowImageView];
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
    self.contentLab.text = infoCellModel.content;
}
@end
