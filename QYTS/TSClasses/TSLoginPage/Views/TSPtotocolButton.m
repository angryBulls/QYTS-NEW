//
//  TSPtotocolButton.m
//  QYTS
//
//  Created by lxd on 2017/7/10.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPtotocolButton.h"
#import "UIImage+Extension.h"

@interface TSPtotocolButton ()
@property (nonatomic, weak) UIButton *protocolBtn;
@end

@implementation TSPtotocolButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    TSPtotocolButton *button = [super buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:W(12.0)];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [button setImage:[UIImage imageNamed:@"login_protocol_Icon"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(12, 12)] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeCenter;
    button.imageView.layer.borderWidth = 1.0;
    button.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [button setTitle:@"我已详细阅读并同意" forState:UIControlStateNormal];
//    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 9)];
//    [attString addAttribute:NSForegroundColorAttributeName value:TSHEXCOLOR(0x8ab3ff) range:NSMakeRange(9, attString.length - 9)];
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, self.height*0.2*0.5, self.height*0.8, self.height*0.8);
    self.titleLabel.frame = CGRectMake(self.imageView.width + 3, 0, self.width - self.imageView.width - 3, self.height);
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.height*0.8*0.5;
}
@end
