//
//  CreateGameTextfieldView.m
//  QYTS
//
//  Created by lxd on 2017/8/10.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreateGameTextfieldView.h"
#import "TSCreateGameModel.h"
#import "TSTextFieldView.h"

@interface CreateGameTextfieldView ()
@property (nonatomic, weak) UILabel *leftLab;
@property (nonatomic, weak) TSTextFieldView *rightTextfield;
@end

@implementation CreateGameTextfieldView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TSHEXCOLOR(0x27395d);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = W(5);
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add left label
    CGFloat leftLabX = 0;
    CGFloat leftLabY = 0;
    CGFloat leftLabW = W(90);
    CGFloat leftLabH = self.height;
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, leftLabY, leftLabW, leftLabH)];
    leftLab.textAlignment = NSTextAlignmentRight;
    leftLab.font = [UIFont systemFontOfSize:W(15.0)];
    leftLab.textColor = TSHEXCOLOR(0xffffff);
    [self addSubview:leftLab];
    self.leftLab = leftLab;
    
    CGFloat rightTextfieldX = leftLabW;
    CGFloat rightTextfieldY = 0;
    CGFloat rightTextfieldW = self.width - rightTextfieldX;
    CGFloat rightTextfieldH = self.height;
    CGRect textFieldViewFrame = CGRectMake(rightTextfieldX, rightTextfieldY, rightTextfieldW, rightTextfieldH);
    TSTextFieldView *rightTextfield = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:@"请输入" textfieldType:TSTextFieldTypeDatePicker];
    [self p_customTextfieldStyle:rightTextfield];
    __weak typeof(rightTextfield) __weakTextfield = rightTextfield;
    rightTextfield.textFieldBeginEditingBlock = ^{
        if ([self.delegate respondsToSelector:@selector(gameNameTextfieldBeginEditing)]) {
            [self.delegate gameNameTextfieldBeginEditing];
        }
    };
    rightTextfield.textFieldShouldReturnBlock = ^{
        self.createGameModel.customName = __weakTextfield.textField.text;
        if (0 == self.createGameModel.customName.length) {
            self.rightTextfield.textField.text = self.createGameModel.name;
        }
        
        if ([self.delegate respondsToSelector:@selector(gameNameTextfieldEndEdited)]) {
            [self.delegate gameNameTextfieldEndEdited];
        }
    };
    [self addSubview:rightTextfield];
    self.rightTextfield = rightTextfield;
}

- (void)p_customTextfieldStyle:(TSTextFieldView *)textFieldView {
    textFieldView.backgroundColor = TSHEXCOLOR(0x27395d);
    textFieldView.layer.borderWidth = 0;
    textFieldView.textField.x = 0;
    textFieldView.textField.textColor = TSHEXCOLOR(0xbfd4ff);
    
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(0, textFieldView.height - 8, textFieldView.width - W(12), 1);
    bottomLine.backgroundColor = [UIColor whiteColor].CGColor;
    [textFieldView.layer addSublayer:bottomLine];
}

- (void)setCreateGameModel:(TSCreateGameModel *)createGameModel {
    _createGameModel = createGameModel;
    
    self.leftLab.text = createGameModel.leftTitle;
    if (createGameModel.customName.length) {
        self.rightTextfield.textField.text = createGameModel.customName;
    } else {
        self.rightTextfield.textField.text = createGameModel.name;
    }
}
@end
