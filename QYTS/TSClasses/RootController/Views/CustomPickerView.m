//
//  CustomPickerView.m
//  QYTS
//
//  Created by lxd on 2017/7/17.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) UIView *cover;
@property (nonatomic, assign) PickerViewType pickerViewType;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *valueArray;
@property (nonatomic, copy) SelectRowDataReturnBlock returnValueBlock;
@property (nonatomic, copy) DismissReturnBlock dismissReturnBlock;

@property (nonatomic, copy) NSString *currentSelectValue;
@end

@implementation CustomPickerView
#pragma mark - lazy method ************************************************************************
- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)pickerViewType valueArray:(NSArray *)valueArray returnValue:(SelectRowDataReturnBlock)returnValueBlock dismissReturnBlock:(DismissReturnBlock)dismissReturnBlock {
    if (self = [super initWithFrame:frame]) {
        _pickerViewType = pickerViewType;
        _valueArray = valueArray;
        _returnValueBlock = returnValueBlock;
        _dismissReturnBlock = dismissReturnBlock;
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add cover
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = TSHEXCOLOR(0x232323);
    cover.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_coverEventTouch)];
    [cover addGestureRecognizer:tap];
    [self addSubview:cover];
    self.cover = cover;
    
    // add picker view
    [self p_setupPickerView];
    
    // add ok button
    CGFloat okBgViewH = H(40);
    UIView *okBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - okBgViewH - self.pickerView.height, self.width, okBgViewH)];
    okBgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:okBgView];
    
    CGFloat okBtnW = W(80);
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(self.width - okBtnW, 0, okBtnW, okBgViewH);
    [okBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:W(20.0)];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [okBgView addSubview:okBtn];
    
    CGFloat cancelBtnW = W(80);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, cancelBtnW, okBgViewH);
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:W(20.0)];
    [cancelBtn addTarget:self action:@selector(p_cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [okBgView addSubview:cancelBtn];
}

- (void)okBtnClick {
    [self p_dismiss];
}

- (void)p_cancelBtnClick {
    if (self.pickerViewType == PickerViewTypeName) {
        self.dismissReturnBlock ? self.dismissReturnBlock(self.defaultValue) : nil;
    } else if (self.pickerViewType == PickerViewTypeColor) {
        self.dismissReturnBlock ? self.dismissReturnBlock(@[self.defaultValue]) : nil;
    }
    [self removeFromSuperview];
}

- (void)p_setupPickerView {
    CGFloat pickViewH = H(238);
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [pickerView setFrame:CGRectMake(0, self.height - pickViewH, self.width, pickViewH)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.valueArray.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return H(38);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UIView *customView = [self p_createCustomPickerViews];
    
    if (self.pickerViewType == PickerViewTypeName) {
        UILabel *titleLab = [self p_createNameLabelWithFrame:customView.frame title:self.valueArray[row]];
        [customView addSubview:titleLab];
        if (self.checkRepeatValue.length) {
            if ([self.checkRepeatValue containsString:[NSString stringWithFormat:@",%@,", titleLab.text]]) {
                titleLab.textColor = [UIColor redColor];
            }
        }
    } else if (self.pickerViewType == PickerViewTypeColor) {
        [self p_createColorViewsWithSuperView:customView valueArray:self.valueArray[row]];
    }
    
    [self p_createHookImageViewWithSuperView:customView];
    
    return customView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentSelectValue = self.valueArray[row];
    self.returnValueBlock ? self.returnValueBlock(self.currentSelectValue) : nil;
    
    UIView *customView = [pickerView viewForRow:row forComponent:component];
    [[customView.subviews lastObject] setHidden:NO];
}

- (UIView *)p_createCustomPickerViews {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pickerView.width, H(38))];
    
    return customView;
}

- (UILabel *)p_createNameLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:frame];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:W(18.0)];
    titleLab.textColor = TSHEXCOLOR(0x333333);
    
    return titleLab;
}

- (void)p_createColorViewsWithSuperView:(UIView *)superView valueArray:(NSArray *)valueArray {
    UILabel *colorLab = [self p_createNameLabelWithFrame:CGRectMake(0, 0, W(40), superView.height) title:valueArray[0]];
    colorLab.x = superView.width*0.5 - colorLab.width - W(6.5);
    [superView addSubview:colorLab];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W(30), H(18))];
    colorView.x = CGRectGetMaxX(colorLab.frame) + W(6.5);
    colorView.centerY = superView.height*0.5;
    colorView.layer.masksToBounds = YES;
    colorView.layer.cornerRadius = W(5);
    colorView.backgroundColor = [TSToolsMethod colorWithHexString:valueArray[1]];
    if ([valueArray[0] isEqualToString:@"白色"]) {
        colorView.layer.borderWidth = 0.5;
        colorView.layer.borderColor = TSHEXCOLOR(0xc9c9c9).CGColor;
    } else if ([valueArray[0] isEqualToString:@"其他"]) {
        UIImage *image = [UIImage imageNamed:@"color_select_other"];
        UIImageView *otherImageView = [[UIImageView alloc] initWithFrame:colorView.bounds];
        otherImageView.image = image;
        otherImageView.backgroundColor = [UIColor magentaColor];
        [colorView addSubview:otherImageView];
    }
    [superView addSubview:colorView];
}

- (void)p_createHookImageViewWithSuperView:(UIView *)superView { // 增加对勾图片
    UIImage *image = [UIImage imageNamed:@"pickerSelected_Icon"];
    UIImageView *hookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width*1.3, image.size.height*1.3)];
    hookImageView.image = image;
    hookImageView.y = (superView.height - hookImageView.height)*0.5;
    hookImageView.x = superView.width - hookImageView.width - W(30);
    hookImageView.hidden = YES;
    [superView addSubview:hookImageView];
}

#pragma mark - updata data
- (void)setDefaultValue:(NSString *)defaultValue {
    _defaultValue = defaultValue;
    
    if (self.pickerViewType == PickerViewTypeName) {
        [self.valueArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:defaultValue]) {
                [self pickerView:self.pickerView didSelectRow:idx inComponent:0];
                [self.pickerView selectRow:idx inComponent:0 animated:YES];
                
                *stop = YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIView *customView = [self.pickerView viewForRow:idx forComponent:0];
                    [[customView.subviews lastObject] setHidden:NO];
                });
            }
        }];
    } else if (self.pickerViewType == PickerViewTypeColor) {
        [self.valueArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[0] isEqualToString:defaultValue]) {
                [self pickerView:self.pickerView didSelectRow:idx inComponent:0];
                [self.pickerView selectRow:idx inComponent:0 animated:YES];
                
                *stop = YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIView *customView = [self.pickerView viewForRow:idx forComponent:0];
                    [[customView.subviews lastObject] setHidden:NO];
                });
            }
        }];
    }
}

- (void)p_coverEventTouch {
    [self p_dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)p_dismiss {
    self.dismissReturnBlock ? self.dismissReturnBlock(self.currentSelectValue) : nil;
    [self removeFromSuperview];
}
@end
