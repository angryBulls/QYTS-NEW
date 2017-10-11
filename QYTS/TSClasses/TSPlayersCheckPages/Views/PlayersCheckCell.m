//
//  PlayersCheckCell.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PlayersCheckCell.h"
#import "UIView+Extension.h"
#import "DropDownButton.h"
#import "UIImageView+Extension.h"
#import "CustomPickerView.h"
#import "TSPlayerModel.h"
#import "UIImage+Extension.h"

#define MaxColumn 4

@interface PlayersCheckCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *nameLab;
@property (nonatomic, weak) UILabel *registerNumLab;
@property (nonatomic, weak) DropDownButton *numbDpBtn;
@property (nonatomic, weak) UIButton *startBtn;
@end

@implementation PlayersCheckCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PlayersCheckCell";
    PlayersCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PlayersCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(46);
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
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
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    // add name label
    UILabel *nameLab = [self p_createLabelWithTitle:@" "];
    nameLab.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:nameLab];
    self.nameLab = nameLab;
    
    // add register number label
    UILabel *registerNumLab = [self p_createLabelWithTitle:@" "];
    registerNumLab.x = self.nameLab.width;
    [self.bgView addSubview:registerNumLab];
    self.registerNumLab = registerNumLab;
    
    // add number dropdown button
    CGFloat subViewsW = self.bgView.width/MaxColumn;
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        nameLab.textAlignment = NSTextAlignmentCenter;
        subViewsW = self.bgView.width/3;
        self.registerNumLab.width = 0;
    }
    
    CGFloat numbDpBtnW = W(70);
    CGFloat numbDpBtnH = H(35);
    CGFloat marginX = (subViewsW - numbDpBtnW)*0.5;
    CGFloat marginY = (self.bgView.height - numbDpBtnH)*0.5;
    CGFloat numbDpBtnX = CGRectGetMaxX(self.registerNumLab.frame) + marginX;
    
    NSString *gameNumber = registerNumLab.text;
    if (currentUserType == LoginUserTypeNormal) {
        numbDpBtnX = CGRectGetMaxX(self.nameLab.frame) + marginX;
        gameNumber = @"";
    }
    
    DropDownButton *numbDpBtn = [self createDropDownWithFrame:CGRectMake(numbDpBtnX, marginY, numbDpBtnW, numbDpBtnH) titleName:gameNumber];
    numbDpBtn.rightWidth = W(10.5);
    [numbDpBtn addTarget:self action:@selector(p_numbDpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:numbDpBtn];
    self.numbDpBtn = numbDpBtn;
    
    // add if  is starting button
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat startDpBtnX = CGRectGetMaxX(self.numbDpBtn.frame) + 2*marginX;
    startBtn.frame = CGRectMake(startDpBtnX, marginY, numbDpBtnW, numbDpBtnH);
    [startBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0x27395d) size:startBtn.frame.size] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xe8f0ff) size:startBtn.frame.size] forState:UIControlStateSelected];
    startBtn.layer.masksToBounds = YES;
    startBtn.layer.cornerRadius = W(5);
    startBtn.layer.borderWidth = 0.5;
    startBtn.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    startBtn.titleLabel.font = [UIFont systemFontOfSize:W(15)];
    [startBtn setTitle:@"否" forState:UIControlStateNormal];
    [startBtn setTitle:@"是" forState:UIControlStateSelected];
    [startBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [startBtn setTitleColor:TSHEXCOLOR(0x1b2a47) forState:UIControlStateSelected];
    startBtn.selected = NO;
    [startBtn addTarget:self action:@selector(p_startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:startBtn];
    self.startBtn = startBtn;
}

- (void)p_numbDpBtnClick:(DropDownButton *)dpBtn {
    [self p_dpBtnClick:dpBtn];
    
    NSMutableArray *numberArray = [NSMutableArray array];
    for (int i = 0; i < 100; i ++) {
        [numberArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) pickerViewType:PickerViewTypeName valueArray:numberArray returnValue:^(id returnValue) {
        [dpBtn setTitle:returnValue forState:UIControlStateNormal];
    } dismissReturnBlock:^(id returnValue) {
        [self p_dpBtnClick:dpBtn];
        
        if (![returnValue isEqualToString:self.playerModel.gameNum]) {
            self.playerModel.gameNum = returnValue;
            
            if ([self.delegate respondsToSelector:@selector(reloadTableViewWithSection:)]) {
                [self.delegate reloadTableViewWithSection:(int)self.indexPath.section];
            }
        }
    }];
    if (0 == self.numbDpBtn.currentTitle.length) {
        pickView.defaultValue = @"0";
    } else {
        pickView.defaultValue = dpBtn.currentTitle;
    }
    pickView.checkRepeatValue = self.playerModel.allSelectedNumb;
    [pickView show];
}

- (void)p_startBtnClick:(UIButton *)startBtn {
    startBtn.selected = !startBtn.selected;
    
    if (startBtn.selected) {
        self.playerModel.isStartPlayer = @"是";
        self.playerModel.playingStatus = @"1";
    } else {
        self.playerModel.isStartPlayer = @"否";
        self.playerModel.playingStatus = @"0";
    }
}

- (void)p_dpBtnClick:(DropDownButton *)dpBtn {
    [dpBtn.imageView animationWithDuration:0.5 angle:M_PI];
}

- (UILabel *)p_createLabelWithTitle:(NSString *)title {
    CGFloat subViewsW = self.bgView.width/MaxColumn;
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    if (currentUserType == LoginUserTypeNormal) {
        subViewsW = self.bgView.width/3;
    }
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, subViewsW, self.height)];
    nameLab.text = title;
    nameLab.font = [UIFont systemFontOfSize:W(15.0)];
    nameLab.textColor = TSHEXCOLOR(0xffffff);
    nameLab.textAlignment = NSTextAlignmentCenter;
    
    return nameLab;
}

- (DropDownButton *)createDropDownWithFrame:(CGRect)frame titleName:(NSString *)titleName {
    DropDownButton *dpBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    dpBtn.frame = frame;
    [dpBtn setTitle:titleName forState:UIControlStateNormal];
    [dpBtn setImage:[UIImage imageNamed:@"dropDown_Icon"] forState:UIControlStateNormal];
    
    return dpBtn;
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

#pragma mark - update views with playerModel
- (void)setPlayerModel:(TSPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    self.nameLab.text = playerModel.name;
    self.registerNumLab.text = playerModel.playerNumber;
    [self.numbDpBtn setTitle:playerModel.gameNum forState:UIControlStateNormal];
    
    self.numbDpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    NSArray *tempArray = [playerModel.allSelectedNumb componentsSeparatedByString:[NSString stringWithFormat:@",%@,", playerModel.gameNum]];
    if (tempArray.count > 2) {
        self.numbDpBtn.layer.borderColor = [UIColor redColor].CGColor;
    }
    self.startBtn.selected = [self.playerModel.playingStatus intValue];
}
@end
