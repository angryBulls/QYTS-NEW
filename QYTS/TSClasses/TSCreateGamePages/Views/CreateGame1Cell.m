//
//  CreateGame1Cell.m
//  QYTS
//
//  Created by lxd on 2017/7/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "CreateGame1Cell.h"
#import "UIView+Extension.h"
#import "TSTextFieldView.h"
#import "TSCreateGameModel.h"

@interface CreateGame1Cell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *leftLab;
@property (nonatomic, weak) TSTextFieldView *rightTextfield;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong)UIToolbar *toolBar;
@end

@implementation CreateGame1Cell
#pragma mark - lazy method ************************************************************************
-(UIDatePicker *)datePicker{
    if (_datePicker==nil) {
        //自定义文本框的键盘
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        //只显示日期
//        picker.datePickerMode = UIDatePickerModeDateAndTime;
        //设置地理区域
        picker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        
        //设置时间的选择范围
        float minDate = 0; //选择时间的最小值
        NSInteger maxDate = 30; //选择时间的最大值
        NSDate *nowDate = [NSDate date];
        NSDate *theDateStart,*theDateEnd;
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDateStart = [nowDate initWithTimeIntervalSinceNow: +oneDay*minDate];
        theDateEnd = [nowDate initWithTimeIntervalSinceNow:+oneDay*maxDate];
        [picker setMinimumDate:theDateStart];
//        [picker setMaximumDate:theDateEnd];
        
        _datePicker.date = [NSDate date];
        //监听UIDatePicker的滚动
        [picker addTarget:self action:@selector(p_dateChange:) forControlEvents:UIControlEventValueChanged];
        _datePicker=picker;
    }
    return _datePicker;
}

- (UIToolbar *)toolBar {
    if (_toolBar==nil) {
        //自定义文本框键盘上面显示的工具控件
        UIToolbar *tool = [[UIToolbar alloc]init];
        tool.frame=CGRectMake(0, 0, 0, 36);
        tool.barTintColor = [UIColor whiteColor];
        UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(p_cancelClick)];
        [item0 setTintColor:[UIColor blackColor]];
        //添加弹簧，将“完成”按钮顶到最右侧
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(p_doneClick)];
        [item2 setTintColor:[UIColor blackColor]];
        tool.items = @[item0, item1, item2];
        _toolBar=tool;
    }
    return _toolBar;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CreateGame1Cell";
    CreateGame1Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CreateGame1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGFloat leftLabW = self.bgView.width * 0.253;
    CGFloat leftLabH = self.height;
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, leftLabY, leftLabW, leftLabH)];
    leftLab.textAlignment = NSTextAlignmentRight;
    leftLab.font = [UIFont systemFontOfSize:W(15.0)];
    leftLab.textColor = TSHEXCOLOR(0xffffff);
    [self.bgView addSubview:leftLab];
    self.leftLab = leftLab;
    
    // add right textfield
    CGFloat rightTextfieldX = self.bgView.width * 0.27;
    CGFloat rightTextfieldY = 0;
    CGFloat rightTextfieldW = (self.bgView.width - rightTextfieldX)*0.95;
    CGFloat rightTextfieldH = self.height;
    CGRect textFieldViewFrame = CGRectMake(rightTextfieldX, rightTextfieldY, rightTextfieldW, rightTextfieldH);
    TSTextFieldView *rightTextfield = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:@"请输入" textfieldType:TSTextFieldTypeDatePicker];
    [self p_customTextfieldStyle:rightTextfield];
    __weak typeof(rightTextfield) weakTextfield = rightTextfield;
    rightTextfield.textFieldShouldReturnBlock = ^{
        self.createGameModel.name = weakTextfield.textField.text;
        if ([self.createGameModel.leftTitle containsString:@"客队"]) {
            if ([self.delegate respondsToSelector:@selector(textfieldReturn)]) {
                [self.delegate textfieldReturn];
            }
        }
    };
    [self.bgView addSubview:rightTextfield];
    self.rightTextfield = rightTextfield;
}

- (void)p_customTextfieldStyle:(TSTextFieldView *)textFieldView {
    textFieldView.backgroundColor = TSHEXCOLOR(0x27395d);
    textFieldView.layer.borderWidth = 0;
    textFieldView.textField.x = 0;
    textFieldView.textField.textColor = TSHEXCOLOR(0xffffff);
    
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(0, textFieldView.height - 8, textFieldView.width, 1);
    bottomLine.backgroundColor = [UIColor whiteColor].CGColor;
    [textFieldView.layer addSublayer:bottomLine];
}

- (void)setTextfieldInputView:(TextfieldInputView)textfieldInputView {
    _textfieldInputView = textfieldInputView;
    
    if (textfieldInputView == TextfieldInputViewDatePicker) {
        self.rightTextfield.textField.inputView = self.datePicker;
        self.rightTextfield.textField.inputAccessoryView = self.toolBar;
        [self p_dateFormatter];
    } else {
        self.rightTextfield.textField.inputView = nil;
    }
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
}

#pragma mark - datePicker的监听事件
- (void)p_dateChange:(UIDatePicker *)datePicker {
//     用于上传到服务器的时间格式
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
//    self.createGameModel.matchDate = [fmt stringFromDate:datePicker.date];
//    
//    // 用于cell的展示的时间格式
////    fmt.dateFormat = @"YYYY年MM月dd日 (EEE) HH:mm";
//    [self p_dateFormatter];
}

#pragma mark - UIToolBar按钮的监听事件
- (void)p_cancelClick {
    [self.rightTextfield.textField resignFirstResponder];
}

- (void)p_doneClick {
    [self.rightTextfield.textField resignFirstResponder];
    // 用于上传到服务器的时间格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    self.createGameModel.matchDate = [fmt stringFromDate:self.datePicker.date];
    
    // 用于cell的展示的时间格式
    //    fmt.dateFormat = @"YYYY年MM月dd日 (EEE) HH:mm";
    [self p_dateFormatter];
}

- (void)p_dateFormatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"YYYY年MM月dd日 HH:mm:ss"; // old
    fmt.dateFormat = @"YYYY年MM月dd日 HH点";
    self.rightTextfield.textField.text = [fmt stringFromDate:self.datePicker.date];
    self.createGameModel.name = self.rightTextfield.textField.text;
}

- (void)setCreateGameModel:(TSCreateGameModel *)createGameModel {
    _createGameModel = createGameModel;
    
    self.leftLab.text = createGameModel.leftTitle;
    self.rightTextfield.textField.text = createGameModel.name;
}
@end
