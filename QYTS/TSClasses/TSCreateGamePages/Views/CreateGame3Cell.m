//
//  CreateGame3Cell.m
//  QYTS
//
//  Created by lxd on 2017/8/10.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreateGame3Cell.h"
#import "TSCreateGameModel.h"
#import "DropDownButton.h"
#import "UIImageView+Extension.h"
#import "CustomPickerView.h"
#import "UIView+Extension.h"

@interface CreateGame3Cell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *leftLab;
@property (nonatomic, weak) DropDownButton *dpButton;
@end

@implementation CreateGame3Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CreateGame3Cell";
    CreateGame3Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CreateGame3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    // add left label
    CGFloat leftLabX = 0;
    CGFloat leftLabY = 0;
    CGFloat leftLabW = W(90);
    CGFloat leftLabH = self.height;
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, leftLabY, leftLabW, leftLabH)];
    leftLab.textAlignment = NSTextAlignmentRight;
    leftLab.font = [UIFont systemFontOfSize:W(15.0)];
    leftLab.textColor = TSHEXCOLOR(0xffffff);
    [self.bgView addSubview:leftLab];
    self.leftLab = leftLab;
    
    // add dropdown button
    CGFloat dpButtonX = self.leftLab.width + W(7);
    CGFloat dpButtonH = H(35);
    CGFloat dpButtonY = (self.height - dpButtonH)*0.5;
    CGFloat dpButtonW = self.bgView.width - dpButtonX - W(12);
    DropDownButton *dpButton = [self createDropDownWithFrame:CGRectMake(dpButtonX, dpButtonY, dpButtonW, dpButtonH) titleName:@""];
    [dpButton addTarget:self action:@selector(p_dpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:dpButton];
    self.dpButton = dpButton;
}

- (void)p_dpButtonClick:(DropDownButton *)dpButton {
    [self p_dpBtnClick:dpButton];
    
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) pickerViewType:PickerViewTypeName valueArray:self.createGameModel.dpBtnArray returnValue:^(id returnValue) {
        [dpButton setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [dpButton setTitle:returnValue forState:UIControlStateNormal];
        [self p_dpBtnClick:dpButton];
        self.createGameModel.selectValue = returnValue;
        if ([self.createGameModel.selectValue isEqualToString:@"3X3"] || [self.createGameModel.selectValue isEqualToString:@"5V5"]) {
            if ([self.delegate respondsToSelector:@selector(getDpBtnSelectValue:)]) {
                [self.delegate getDpBtnSelectValue:returnValue];
            }
        }
    }];
    pickView.defaultValue = dpButton.currentTitle;
    [pickView show];
    
    if ([self.delegate respondsToSelector:@selector(dpBtnDidShow)]) {
        [self.delegate dpBtnDidShow];
    }
}

- (DropDownButton *)createDropDownWithFrame:(CGRect)frame titleName:(NSString *)titleName {
    DropDownButton *dpBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    dpBtn.frame = frame;
    [dpBtn setTitle:titleName forState:UIControlStateNormal];
    [dpBtn setImage:[UIImage imageNamed:@"dropDown_Icon"] forState:UIControlStateNormal];
    
    return dpBtn;
}

- (void)p_dpBtnClick:(DropDownButton *)dpBtn {
    [dpBtn.imageView animationWithDuration:0.5 angle:M_PI];
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
    [self.dpButton setTitle:createGameModel.selectValue forState:UIControlStateNormal];
}
@end
