//
//  EditInfoSignatureCell.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "EditInfoSignatureCell.h"
#import "LXDTextView.h"
#import "EditInfoCellModel.h"
#import "UIView+Extension.h"

#define SignatureLength 35

@interface EditInfoSignatureCell () <UITextViewDelegate>
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) LXDTextView *textView;
@end

@implementation EditInfoSignatureCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"EditInfoSignatureCell";
    EditInfoSignatureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditInfoSignatureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(150);
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
    CGFloat titleLabY = H(15);
    CGFloat titleLabW = W(200);
    CGFloat titleLabH = H(15);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    titleLab.text = @"个性签名：";
    [self.bgView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // add input signature textView
    CGFloat textViewX = self.titleLab.x;
    CGFloat textViewY = CGRectGetMaxY(self.titleLab.frame) + H(10);
    CGFloat textViewW = self.bgView.width - textViewX - W(11.5);
    CGFloat textViewH = H(100);
    LXDTextView *textView = [[LXDTextView alloc] init];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    textView.layer.cornerRadius = W(5);
    textView.alwaysBounceVertical = NO;
    textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    textView.font = [UIFont systemFontOfSize:W(15.0)];
    textView.placeholder = @"最低5个字，最高35个字。";
    textView.delegate = self;
    textView.backgroundColor = TSHEXCOLOR(0x27395d);
    textView.placeholderColor = [UIColor whiteColor];
    textView.textColor = [UIColor whiteColor];
    [self.bgView addSubview:textView];
    self.textView = textView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assessTextViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setRectCornerStyle:(UIRectCorner)rectCornerStyle {
    _rectCornerStyle = rectCornerStyle;
    
    if (rectCornerStyle == UIRectCornerAllCorners) {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(0)];
    } else {
        [self.bgView setRectCornerWithStyle:rectCornerStyle cornerRadii:W(5)];
    }
}

#pragma mark - UITextViewDelegate Method ********************************************************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        textView.text = @"间距";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:W(15.0)],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    if ([textView.text isEqualToString:@"间距"]) {
        textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    }
    textView.textColor = [UIColor whiteColor];
    
    // add toolBar on the keybord
    //    [self addToolBar];
    
    return YES;
}

#pragma mark - Notification Method ********************************************************************************
-(void)assessTextViewEditChanged:(NSNotification *)obj {
    UITextView *textView = (UITextView *)obj.object;
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > SignatureLength) {
                textView.text = [toBeString substringToIndex:SignatureLength];
            }
        } else {
            
        }
    } else {
        if (toBeString.length > SignatureLength) {
            textView.text = [toBeString substringToIndex:SignatureLength];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]) {
        return NO;
    }
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.infoCellModel.content = textView.text;
}

- (void)setInfoCellModel:(EditInfoCellModel *)infoCellModel {
    _infoCellModel = infoCellModel;
    
    self.titleLab.text = infoCellModel.title;
    self.textView.text = infoCellModel.content;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
