//
//  EditInfoCell1.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "EditInfoCell1.h"
#import "UIView+Extension.h"
#import "TSTextFieldView.h"
#import "EditInfoCellModel.h"

@interface EditInfoCell1 ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) TSTextFieldView *rightTextfield;
@end

@implementation EditInfoCell1
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EditInfoCell1";
    EditInfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditInfoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    // add inpu textfieldView
    CGFloat rightTextfieldX = CGRectGetMaxX(self.titleLab.frame);
    CGFloat rightTextfieldY = 0;
    CGFloat rightTextfieldW = self.bgView.width - rightTextfieldX - W(22);
    CGFloat rightTextfieldH = self.bgView.height;
    CGRect rightRextFieldViewFrame = CGRectMake(rightTextfieldX, rightTextfieldY, rightTextfieldW, rightTextfieldH);
    TSTextFieldView *rightTextfield = [[TSTextFieldView alloc] initWithFrame:rightRextFieldViewFrame imageName:@"" placeholder:@"请输入" textfieldType:TSTextFieldTypeName];
    rightTextfield.textField.font = [UIFont systemFontOfSize:W(15.0)];
    rightTextfield.backgroundColor = TSHEXCOLOR(0x27395d);
    rightTextfield.layer.borderWidth = 0;
    rightTextfield.textField.x = 0;
    rightTextfield.textField.textColor = [UIColor whiteColor];
    __weak typeof(rightTextfield) __weakRightTextfield = rightTextfield;
    rightTextfield.textFieldShouldReturnBlock = ^{
        self.infoCellModel.content = __weakRightTextfield.textField.text;
    };
    [self.bgView addSubview:rightTextfield];
    self.rightTextfield = rightTextfield;
    
    // add bottom line
    CGFloat bottomLineX = rightTextfield.x;
    CGFloat bottomLineW = rightTextfield.width + W(10);
    CGFloat bottomLineH = 0.5;
    CGFloat bottomLineY = self.bgView.height - bottomLineH - H(15);
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    bottomLine.backgroundColor = TSHEXCOLOR(0xffffff).CGColor;
    bottomLine.opacity = 0.3;
    [self.bgView.layer addSublayer:bottomLine];
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
    self.rightTextfield.textField.text = infoCellModel.content;
}
@end
