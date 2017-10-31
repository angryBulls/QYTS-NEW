//
//  CustomUIPickerViewScore.m
//  QYTS
//
//  Created by lxd on 2017/9/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CustomUIPickerViewScore.h"

@interface CustomUIPickerViewScore () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int totalValue;
}

@property (nonatomic, weak) UIView *cover;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *numbArray;
@property (nonatomic, strong) NSMutableArray *numbArray2;
@property (nonatomic, weak) UILabel *selectedLab;
@property (nonatomic, copy) NSString *firstSelectValue;
@property (nonatomic, copy) NSString *secondSelectValue;
@property (nonatomic, copy) NSString *titleName;
@end

@implementation CustomUIPickerViewScore
#pragma mark - lazy method ************************************************************************
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGFloat pickViewH = H(238);
        _pickerView = [[UIPickerView alloc] init];
        CALayer *pickerLayer = _pickerView.layer;
        [pickerLayer setFrame:CGRectMake(0, self.height - pickViewH, self.width, pickViewH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (NSMutableArray *)numbArray {
    if (!_numbArray) {
        _numbArray = [NSMutableArray array];
        for (int i = 0; i < totalValue; i ++) {
            [_numbArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _numbArray;
}

-(NSMutableArray *)numbArray2{
    if (_numbArray2 == nil) {
        _numbArray2 = [NSMutableArray array];
    }
    return _numbArray2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        totalValue = 100;
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
    [self addSubview:self.pickerView];
    
    // add ok button
    CGFloat okBgViewH = H(40);
    UIView *okBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - self.pickerView.height - okBgViewH, self.width, okBgViewH)];
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
    
    // add show select value label
    CGFloat selectedLabW = W(130);
    CGFloat selectedLabH = okBgViewH;
    UILabel *selectedLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selectedLabW, selectedLabH)];
    selectedLab.centerX = okBgView.width*0.5;
    selectedLab.backgroundColor = [UIColor clearColor];
    selectedLab.text = @"";
    selectedLab.textAlignment = NSTextAlignmentCenter;
    selectedLab.font = [UIFont systemFontOfSize:W(18.0)];
    selectedLab.textColor = [UIColor blueColor];
    [okBgView addSubview:selectedLab];
    self.selectedLab = selectedLab;
}

- (void)okBtnClick {
    if (2 == self.defaultValueArray.count) {
        if ((self.firstSelectValue.intValue != [self.defaultValueArray[0] intValue]) || (self.secondSelectValue.intValue != [self.defaultValueArray[1] intValue])) {
            if (self.firstSelectValue.intValue <= self.secondSelectValue.intValue) {
                self.didSelectValueReturnBlock ? self.didSelectValueReturnBlock(self.firstSelectValue, self.secondSelectValue) : nil;
            } else {
                [SVProgressHUD showInfoWithStatus:@"“命中数”不能大于“总数”"];
            }
        }
    } else if (1 == self.defaultValueArray.count) {
        if (self.firstSelectValue.intValue != [self.defaultValueArray[0] intValue]) {
            self.didSelectValueReturnBlock ? self.didSelectValueReturnBlock(self.firstSelectValue, self.secondSelectValue) : nil;
        }
    }
    
    [self p_dismiss];
}

- (void)p_cancelBtnClick {
    [self p_dismiss];
}

- (void)p_coverEventTouch {
    [self p_dismiss];
}

- (void)show {
//    UIWindow *window = [[UIApplication sharedApplication] windows].lastObject;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    if (2 == self.defaultValueArray.count) {
        [self p_addDividView];
    }
}

- (void)p_dismiss {
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.defaultValueArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.defaultValueArray.count == 1) {
        return self.numbArray.count;
    }else{
        if (component == 0) {
            return self.numbArray2.count;
        }
        else
        {
            return self.numbArray.count;
        }
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (0 == component || 1 == component) {
        return self.pickerView.width/3;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return H(38);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (0 == component) {
        if (!view) {
            view = [self p_createFirstCloumViewWithPickView:pickerView];
        }
        UILabel *titleLab = [[view subviews] firstObject];
        titleLab.text = self.numbArray[row];
        if ([self.defaultValueArray[0] intValue] == titleLab.text.intValue) {
            titleLab.textColor = [UIColor redColor];
        } else {
            titleLab.textColor = TSHEXCOLOR(0x333333);
        }
        if (1 == self.defaultValueArray.count) {
            if (self.firstSelectValue.intValue == row) {
                UIView *customView = [pickerView viewForRow:row forComponent:component];
                [[customView.subviews lastObject] setHidden:NO];
            }
        }
    } else if (1 == component) {
        if (!view) {
            view = [self p_createSecondCloumViewWithPickView:pickerView];
        }
        UILabel *titleLab = [[view subviews] firstObject];
        titleLab.text = self.numbArray[row];
        if ([self.defaultValueArray[1] intValue] == titleLab.text.intValue) {
            titleLab.textColor = [UIColor redColor];
        } else {
            titleLab.textColor = TSHEXCOLOR(0x333333);
        }
        if (self.secondSelectValue.intValue == row) {
            UIView *customView = [pickerView viewForRow:row forComponent:component];
            [[customView.subviews lastObject] setHidden:NO];
        }
    }
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (1 == self.defaultValueArray.count) {
        if (0 == component) {
            UIView *customView = [pickerView viewForRow:row forComponent:component];
            [[customView.subviews lastObject] setHidden:NO];
        }
    }
    
    if (1 == component) {
        UIView *customView = [pickerView viewForRow:row forComponent:component];
        [[customView.subviews lastObject] setHidden:NO];
    }
    
    if (0 == component) {
        self.firstSelectValue = self.numbArray2[row];
    } else if (1 == component) {
        self.secondSelectValue = self.numbArray[row];
        self.numbArray2 = [_numbArray subarrayWithRange:NSMakeRange(0, row+1)];
        [self.pickerView reloadComponent:0];
    }
    
    if (2 == self.defaultValueArray.count) {

        self.selectedLab.text = [NSString stringWithFormat:@"%@: %@ / %@", self.titleName, self.firstSelectValue, self.secondSelectValue];
    } else if (1 == self.defaultValueArray.count) {
        self.selectedLab.text = [NSString stringWithFormat:@"%@: %@", self.titleName, self.firstSelectValue];
    }
}

#pragma mark - tools method
- (UIView *)p_createFirstCloumViewWithPickView:(UIPickerView *)pickerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.pickerView.width/3, H(38))];
    // add label view
    UILabel *titleLab = [self p_createNameLabelWithFrame:view.bounds title:@""];
    [view addSubview:titleLab];
    
    [self p_createHookImageViewWithSuperView:view];
    
    return view;
}

- (UIView *)p_createSecondCloumViewWithPickView:(UIPickerView *)pickerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.pickerView.width/3, H(38))];
    // add label view
    UILabel *titleLab = [self p_createNameLabelWithFrame:CGRectMake(0, 0, view.width, view.height) title:@""];
    [view addSubview:titleLab];
    
    [self p_createHookImageViewWithSuperView:view];
    
    return view;
}

- (UILabel *)p_createNameLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:frame];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:W(18.0)];
    titleLab.textColor = TSHEXCOLOR(0x333333);
    
    return titleLab;
}

- (void)p_createHookImageViewWithSuperView:(UIView *)superView { // 增加对勾图片
    UIImage *image = [UIImage imageNamed:@"pickerSelected_Icon"];
    UIImageView *hookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width*1.3, image.size.height*1.3)];
    hookImageView.image = image;
    hookImageView.y = (superView.height - hookImageView.height)*0.5;
    hookImageView.x = superView.width - hookImageView.width + W(20);
    if (1 == self.defaultValueArray.count) {
        hookImageView.x = superView.width - hookImageView.width + W(50);
    }
    hookImageView.hidden = YES;
    [superView addSubview:hookImageView];
}

- (void)p_addDividView {
    // add divid view
    UIView *dividView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W(20), H(46))];
    dividView.center = CGPointMake(_pickerView.width*0.5, self.pickerView.height*0.5);
    dividView.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:dividView];
    // add line
    CGFloat lineW = 2.0;
    CGFloat lineH = dividView.height;
    CGFloat lineX = (dividView.width - lineW) * 0.5;
    CAShapeLayer *line = [[CAShapeLayer alloc] init];
    line.masksToBounds = YES;
    line.cornerRadius = 1.0;
    line.frame = CGRectMake(lineX, 8, lineW, lineH - 16);
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    [dividView.layer addSublayer:line];
}

#pragma mark load pickView with data
- (void)setDataType:(NSString *)dataType {
    [super setDataType:dataType];
    
    // 根据数据类型，设置标题
    [self p_setTitleNameWithDataType:dataType];
}

- (void)setDefaultValueArray:(NSArray *)defaultValueArray {
    [super setDefaultValueArray:defaultValueArray];
    
    if (2 == defaultValueArray.count) { // 修改得分数据
        self.selectedLab.text = [NSString stringWithFormat:@"%@: %@ / %@", self.titleName, defaultValueArray[0], defaultValueArray[1]];
        self.firstSelectValue = defaultValueArray[0];
        self.secondSelectValue = defaultValueArray[1];
        [self.pickerView selectRow:self.firstSelectValue.intValue inComponent:0 animated:YES];
        [self.pickerView selectRow:self.secondSelectValue.intValue inComponent:1 animated:YES];
    } else if (1 == defaultValueArray.count) {
        self.selectedLab.text = [NSString stringWithFormat:@"%@: %@", self.titleName, defaultValueArray[0]];
        self.firstSelectValue = [NSString stringWithFormat:@"%@", defaultValueArray[0]];
        [self.pickerView selectRow:self.firstSelectValue.intValue inComponent:0 animated:YES];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        int row = [defaultValueArray[0] intValue];
//        int component = 0;
//        if (2 == defaultValueArray.count) {
//            row = [defaultValueArray[1] intValue];
//            component = 1;
//        }
//        
//        UIView *customView = [self.pickerView viewForRow:row forComponent:component];
//        [[customView.subviews lastObject] setHidden:NO];
//    });
}

#pragma mark - tools method ************************************************************
- (void)p_setTitleNameWithDataType:(NSString *)dataType {
    if ([dataType isEqualToString:FreeThrowHit]) { // 罚篮
        self.titleName = @"罚篮";
        return;
    }
    if ([dataType isEqualToString:OnePointsHit]) { // 一分
        self.titleName = @"一分";
        return;
    }
    if ([dataType isEqualToString:TwoPointsHit]) { // 两分
        self.titleName = @"两分";
        return;
    }
    if ([dataType isEqualToString:ThreePointsHit]) { // 三分
        self.titleName = @"三分";
        return;
    }
    
    if ([dataType isEqualToString:OffensiveRebound]) {
        self.titleName = @"进攻篮板";
        return;
    }
    if ([dataType isEqualToString:DefensiveRebound]) {
        self.titleName = @"防守篮板";
        return;
    }
    
    totalValue = 50;
    
    if ([dataType isEqualToString:Assists]) {
        self.titleName = @"助攻";
        return;
    }
    if ([dataType isEqualToString:Steals]) {
        self.titleName = @"抢断";
        return;
    }
    if ([dataType isEqualToString:BlockShots]) {
        self.titleName = @"盖帽";
        return;
    }
    if ([dataType isEqualToString:Turnover]) {
        self.titleName = @"失误";
        return;
    }
    
    totalValue = 10;
    
    if ([dataType isEqualToString:Fouls]) {
        self.titleName = @"犯规";
    }
}

- (void)dealloc {
    DDLog(@"CustomUIPickerViewScore ------ dealloc");
}
@end
