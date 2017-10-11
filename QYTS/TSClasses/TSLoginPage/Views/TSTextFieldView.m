//
//  TSTextFieldView.m
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSTextFieldView.h"
#import "NSString+Valid.h"

#define Symbol @"[ <>《》！*(^)$%~!@#$…&%￥¥—+=、。“”，-/;；''‘’:：·`.?？\"\"]+"
#define NameLength 15
#define PhoneLength 11
#define PassWordLength 6
#define AuthCodeLength 4
#define InviteCodeLength 4

@interface TSTextFieldView () <UITextFieldDelegate>
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) TSTextFieldType textfieldType;
@end

@implementation TSTextFieldView
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName placeholder:(NSString *)placeholder textfieldType:(TSTextFieldType)textfieldType {
    if (self = [super initWithFrame:frame]) {
        _imageName = imageName;
        _placeholder = placeholder;
        _textfieldType = textfieldType;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = W(5);
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = TSHEXCOLOR(0x8e8e8e).CGColor;
        
        [self p_AddSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditting:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:self.textField];
    }
    
    return self;
}

- (void)p_AddSubViews {
    // add imageView
    UIImage *leftImage = [UIImage imageNamed:self.imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:leftImage];
    imageView.centerY = self.height * 0.5;
    imageView.x = W(17);
    [self addSubview:imageView];
    
    // add textfield view
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + W(11), 0, self.width - CGRectGetMaxX(imageView.frame) - W(11), self.height)];
    textField.placeholder = self.placeholder;
    textField.textColor = TSHEXCOLOR(0x666666);
    textField.font = [UIFont systemFontOfSize:W(15.0)];
    textField.returnKeyType = UIReturnKeyDone;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = TSHEXCOLOR(0x666666);
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    [textField setAttributedPlaceholder:attribute];
//    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
//    [placeholder addAttribute:NSForegroundColorAttributeName
//                        value:TSHEXCOLOR(0x666666)
//                        range:NSMakeRange(0, self.placeholder.length)];
//    [placeholder addAttribute:NSFontAttributeName
//                        value:[UIFont systemFontOfSize:W(14.0)]
//                        range:NSMakeRange(0, self.placeholder.length)];
//    textField.attributedPlaceholder = placeholder;
//    textField.textColor = TSHEXCOLOR(0x666666);
    textField.delegate = self;
    if (TSTextFieldTypePhone == self.textfieldType || TSTextFieldTypeAuth == self.textfieldType) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (TSTextFieldTypePassword == self.textfieldType) {
        textField.secureTextEntry = YES;
    }
    
    [self addSubview:textField];
    self.textField = textField;
}

- (void)textFieldEditting:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.textfieldType == TSTextFieldTypeName && toBeString.length > NameLength) {
                textField.text = [toBeString substringToIndex:NameLength];
            } else if (self.textfieldType == TSTextFieldTypePhone && toBeString.length > PhoneLength) {
                textField.text = [toBeString substringToIndex:PhoneLength];
            } else if (self.textfieldType == TSTextFieldTypePassword && toBeString.length > PassWordLength) {
                textField.text = [toBeString substringToIndex:PassWordLength];
            } else if (self.textfieldType == TSTextFieldTypeAuth && toBeString.length > AuthCodeLength) {
                textField.text = [toBeString substringToIndex:AuthCodeLength];
            } else if (self.textfieldType == TSTextFieldTypeInviteCode && toBeString.length > InviteCodeLength) {
                textField.text = [toBeString substringToIndex:InviteCodeLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
    } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (self.textfieldType == TSTextFieldTypeName && toBeString.length > NameLength) {
            textField.text = [toBeString substringToIndex:NameLength];
        } else if (self.textfieldType == TSTextFieldTypePhone && toBeString.length > PhoneLength) {
            textField.text = [toBeString substringToIndex:PhoneLength];
        } else if (self.textfieldType == TSTextFieldTypePassword && toBeString.length > PassWordLength) {
            textField.text = [toBeString substringToIndex:PassWordLength];
        } else if (self.textfieldType == TSTextFieldTypeAuth && toBeString.length > AuthCodeLength) {
            textField.text = [toBeString substringToIndex:AuthCodeLength];
        } else if (self.textfieldType == TSTextFieldTypeInviteCode && toBeString.length > InviteCodeLength) {
            textField.text = [toBeString substringToIndex:InviteCodeLength];
        }
    }
}

#pragma mark - Delegate Method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    // if input punctuation,return NO
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Symbol];
    return ![pred evaluateWithObject: string];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textFieldBeginEditingBlock ? self.textFieldBeginEditingBlock() : nil;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.textFieldShouldReturnBlock ? self.textFieldShouldReturnBlock() : nil;
    
    if (self.textfieldType == TSTextFieldTypeDatePicker) {
        return;
    }
    
    if (self.textfieldType == TSTextFieldTypeName && textField.text.length) {
        // filter the emoji
        textField.text = [NSString disable_emoji:[textField text]];
        
        // filter the nickName punctuation
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:Symbol];
        textField.text = [[textField.text componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    self.textFieldShouldReturnBlock ? self.textFieldShouldReturnBlock() : nil;
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
