//
//  CreateGame2Cell.m
//  QYTS
//
//  Created by lxd on 2017/7/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreateGame2Cell.h"
#import "TSTextFieldView.h"
#import "UIView+Extension.h"
#import "TSCreateGameModel.h"

@interface CreateGame2Cell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UILabel *leftLab;
@property (nonatomic, weak) TSTextFieldView *leftTextfield;
@property (nonatomic, weak) UILabel *rightLab;
@property (nonatomic, weak) TSTextFieldView *rightTextfield;
@end

@implementation CreateGame2Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CreateGame2Cell";
    CreateGame2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CreateGame2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(54);
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
    
    // add left view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width*0.5, self.bgView.height)];
    [self.bgView addSubview:leftView];
    self.leftView = leftView;
    
    // add left title label
    CGFloat leftLabX = 0;
    CGFloat leftLabY = 0;
    CGFloat leftLabW = leftView.width * 0.5;
    CGFloat leftLabH = leftView.height;
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, leftLabY, leftLabW, leftLabH)];
    leftLab.textAlignment = NSTextAlignmentRight;
    leftLab.font = [UIFont systemFontOfSize:W(15.0)];
    leftLab.textColor = TSHEXCOLOR(0xffffff);
    [leftView addSubview:leftLab];
    self.leftLab = leftLab;
    
    // add left textfield
    CGFloat leftTextfieldX = leftLab.width;
    CGFloat leftTextfieldY = 0;
    CGFloat leftTextfieldW = leftView.width - leftTextfieldX;
    CGFloat leftTextfieldH = leftView.height;
    CGRect textFieldViewFrame = CGRectMake(leftTextfieldX, leftTextfieldY, leftTextfieldW, leftTextfieldH);
    TSTextFieldView *leftTextfield = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:@"请输入" textfieldType:TSTextFieldTypeName];
    [self p_customTextfieldStyle:leftTextfield leftMargin:0 rightMargin:0];
    __weak typeof(leftTextfield) weakLeftTextfield = leftTextfield;
    leftTextfield.textFieldBeginEditingBlock = ^{
        if ([self.delegate respondsToSelector:@selector(textFieldBeginEditDelegate:)]) {
            [self.delegate textFieldBeginEditDelegate:self];
        }
    };
    leftTextfield.textFieldShouldReturnBlock = ^{
        self.createGameModel.name = weakLeftTextfield.textField.text;
    };
    [leftView addSubview:leftTextfield];
    self.leftTextfield = leftTextfield;
    
    // add right view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.width, 0, self.bgView.width - leftView.width, self.bgView.height)];
    [self.bgView addSubview:rightView];
    
    // add right title label
    CGFloat rightLabX = 0;
    CGFloat rightLabY = 0;
    CGFloat rightLabW = rightView.width * 0.5 - W(25);
    CGFloat rightLabH = rightView.height;
    UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(rightLabX, rightLabY, rightLabW, rightLabH)];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont systemFontOfSize:W(15.0)];
    rightLab.textColor = TSHEXCOLOR(0xffffff);
    [rightView addSubview:rightLab];
    self.rightLab = rightLab;
    
    // add right textfield
    CGFloat rightTextfieldX = rightLabW;
    CGFloat rightTextfieldY = 0;
    CGFloat rightTextfieldW = rightView.width - rightTextfieldX;
    CGFloat rightTextfieldH = rightView.height;
    CGRect rightRextFieldViewFrame = CGRectMake(rightTextfieldX, rightTextfieldY, rightTextfieldW, rightTextfieldH);
    TSTextFieldView *rightTextfield = [[TSTextFieldView alloc] initWithFrame:rightRextFieldViewFrame imageName:@"" placeholder:@"请输入" textfieldType:TSTextFieldTypePhone];
    [self p_customTextfieldStyle:rightTextfield leftMargin:0 rightMargin:W(13)];
    __weak typeof(rightTextfield) weakRightTextfield = rightTextfield;
    rightTextfield.textFieldBeginEditingBlock = ^{
        if ([self.delegate respondsToSelector:@selector(textFieldBeginEditDelegate:)]) {
            [self.delegate textFieldBeginEditDelegate:self];
        }
    };
    rightTextfield.textFieldShouldReturnBlock = ^{
        self.createGameModel.phone = weakRightTextfield.textField.text;
    };
    [rightView addSubview:rightTextfield];
    self.rightTextfield = rightTextfield;
}

- (void)p_customTextfieldStyle:(TSTextFieldView *)textFieldView leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    textFieldView.textField.font = [UIFont systemFontOfSize:W(14.0)];
    textFieldView.backgroundColor = TSHEXCOLOR(0x27395d);
    textFieldView.layer.borderWidth = 0;
    textFieldView.textField.x = 0;
    if (textFieldView == self.leftTextfield) {
        textFieldView.textField.width = self.leftView.width*0.55;
    } else {
        textFieldView.textField.width = self.leftView.width*0.6;
    }
    textFieldView.textField.textColor = TSHEXCOLOR(0xffffff);
    
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(leftMargin, textFieldView.height - H(14), textFieldView.width - leftMargin - rightMargin, 1);
    bottomLine.backgroundColor = [UIColor whiteColor].CGColor;
    [textFieldView.layer addSublayer:bottomLine];
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

- (void)setCreateGameModel:(TSCreateGameModel *)createGameModel {
    _createGameModel = createGameModel;
    
    self.leftLab.text = createGameModel.leftTitle;
    self.leftTextfield.textField.text = createGameModel.name;
    self.rightLab.text = createGameModel.rightTitle;
    self.rightTextfield.textField.text = createGameModel.phone;
}
@end
