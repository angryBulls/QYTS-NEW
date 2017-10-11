//
//  EditInfoDatePickerCell.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "EditInfoDatePickerCell.h"
#import "EditInfoCellModel.h"
#import "TSTextFieldView.h"

@interface EditInfoDatePickerCell ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLab;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong)UIToolbar *toolBar;
@property (nonatomic, weak) TSTextFieldView *textfieldView;
@end

@implementation EditInfoDatePickerCell
#pragma mark - lazy method ************************************************************************
-(UIDatePicker *)datePicker{
    if (_datePicker==nil) {
        //自定义文本框的键盘
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        //只显示日期
        picker.datePickerMode = UIDatePickerModeDate;
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
//        [picker setMinimumDate:theDateStart];
//        [picker setMaximumDate:theDateEnd];
        
//        _datePicker.date = [NSDate date];
        //监听UIDatePicker的滚动
        [picker addTarget:self action:@selector(p_dateChange:) forControlEvents:UIControlEventValueChanged];
        _datePicker = picker;
    }
    return _datePicker;
}

- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        //自定义文本框键盘上面显示的工具控件
        UIToolbar *tool = [[UIToolbar alloc]init];
        tool.frame=CGRectMake(0, 0, 0, 36);
        tool.barTintColor = [UIColor whiteColor];
        //添加弹簧，将“完成”按钮顶到最右侧
        UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(p_cancelClick)];
        [item0 setTintColor:[UIColor blackColor]];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(p_doneClick)];
        [item2 setTintColor:[UIColor blackColor]];
        tool.items = @[item0, item1, item2];
        _toolBar=tool;
    }
    return _toolBar;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EditInfoDatePickerCell";
    EditInfoDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditInfoDatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGRect textFieldViewFrame = CGRectMake(contentLabX, contentLabY, contentLabW, contentLabH);
    TSTextFieldView *textfieldView = [[TSTextFieldView alloc] initWithFrame:textFieldViewFrame imageName:@"" placeholder:@"" textfieldType:TSTextFieldTypeDatePicker];
    textfieldView.backgroundColor = TSHEXCOLOR(0x27395d);
    textfieldView.layer.borderWidth = 0;
    textfieldView.textField.x = 0;
    textfieldView.textField.textColor = TSHEXCOLOR(0xffffff);
    textfieldView.tintColor = [UIColor clearColor];
//    __weak typeof(textfieldView) weakTextfield = textfieldView;
//    textfieldView.textFieldShouldReturnBlock = ^{
//        self.infoCellModel.content = weakTextfield.textField.text;
//    };
    [self.bgView addSubview:textfieldView];
    self.textfieldView = textfieldView;
    
    // add bottom line
    CGFloat bottomLineX = textfieldView.x;
    CGFloat bottomLineW = textfieldView.width + W(10);
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

- (void)setTextfieldInputView:(TextfieldInputView)textfieldInputView {
    _textfieldInputView = textfieldInputView;
    
    if (textfieldInputView == TextfieldInputViewDatePicker) {
        self.textfieldView.textField.inputView = self.datePicker;
        self.textfieldView.textField.inputAccessoryView = self.toolBar;
//        [self p_dateFormatter]; 
    } else {
        self.textfieldView.textField.inputView = nil;
    }
}

#pragma mark - datePicker的监听事件
- (void)p_dateChange:(UIDatePicker *)datePicker {
//    // 用于上传到服务器的时间格式
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"YYYY-MM-dd";
//    self.infoCellModel.content = [fmt stringFromDate:datePicker.date];
//    
//    // 用于cell的展示的时间格式
//    //    fmt.dateFormat = @"YYYY年MM月dd日 (EEE) HH:mm";
//    [self p_dateFormatter];
}

#pragma mark - UIToolBar按钮的监听事件
- (void)p_cancelClick {
    [self.textfieldView.textField resignFirstResponder];
}

- (void)p_doneClick {
    [self.textfieldView.textField resignFirstResponder];
    // 用于上传到服务器的时间格式
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"YYYY-MM-dd";
//    self.infoCellModel.content = [fmt stringFromDate:self.datePicker.date];
    
    // 用于cell的展示的时间格式
    //    fmt.dateFormat = @"YYYY年MM月dd日 (EEE) HH:mm";
    [self p_dateFormatter];
}

- (void)p_dateFormatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //    fmt.dateFormat = @"YYYY年MM月dd日 HH:mm:ss"; // old
    fmt.dateFormat = @"YYYY-MM-dd";
    self.textfieldView.textField.text = [fmt stringFromDate:self.datePicker.date];
    self.infoCellModel.content = self.textfieldView.textField.text;
}

- (void)setInfoCellModel:(EditInfoCellModel *)infoCellModel {
    _infoCellModel = infoCellModel;
    
    self.titleLab.text = infoCellModel.title;
    self.textfieldView.textField.text = infoCellModel.content;
}
@end
