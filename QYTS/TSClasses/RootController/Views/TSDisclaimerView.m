//
//  TSDisclaimerView.m
//  QYTS
//
//  Created by lxd on 2017/8/15.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSDisclaimerView.h"
#import "UIImage+Extension.h"
#import "NSString+SizeFont.h"

#define TitleLabelText @"语音技术统计系统免责声明"
#define ContentText @"系统提醒：\n      在使用本软件的所有功能之前，请您务必仔细阅读并透彻理解本声明。您可以选择不使用本软件，但如果您使用本软件，您的使用行为将视为对本声明全部内容的认可。\n\n免责声明：\n1. 本软件为一款通过语音命令输入实现记录篮球比赛双方球员的临场技术数据的统计工具，旨在为比赛双方的教练员、球员、赛事组织方提供临场技术统计数据的语音命令识别、记录等服务。\n2. 本软件通过技术统计人员输入比赛各方所有信息，包括但不限于赛事相关人员注册信息、比赛数据等内容。所记录的技术统计结果须通过“篮球圈-国人篮球APP”进行查询。在球队注册时，系统默认教练、球员、技术代表、裁判员等比赛相关人员通过手机号码自动注册成为“篮球圈-国人篮球APP”用户，且手机号码为用户名。因统计人员注册（球队注册、用户注册）输入号码错误，导致用户无法查看赛事数据结果的责任，与本软件、软件提供方、开发商无关。[提示：用户可通过以下两种方式修改用户名：（1）网站授权每支注册球队的队长以修改权限；（2）通过网站客服热线按步骤进行修改，热线电话： 400-631-3677 。]\n3. 通过本软件进行语音技术统计的篮球比赛，应以执行该场比赛任务的裁判员根据《篮球规则》确定比赛成绩。技术统计人员在使用本软件前应仔细阅读并了解软件特点、语音命令使用说明、需本软件提供技术统计服务的该场次篮球比赛采用的规则及软件所涉及的其他相关事项。因本软件采用人工语音播报的方式输入技术统计数据，本软件将在操作人员语音播报数据的基础上进行识别，并记录识别结果。该软件无法判定技术统计人员语音播报的内容是否与比赛过程相符合，故本软件及其开发商不对任何统计结果负责。在本软件正式记录比赛数据前，请反复测试所有相关指令，要求使用标准的汉语普通话进行语音输入。\n4. 在系统使用过程中，遇到特殊情况，如突然停电、外界干扰、设备摔落损坏等原因而导致人工录入比赛数据没有被采集或采集错误，后果自负；若技术统计人员未按照语音命令使用说明正确操作，导致软件或设备无法正常运行或运行不稳定，后果自负。"

@implementation TSDisclaimerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    // add cover
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    [self addSubview:cover];
    
    // add imageView
    CGFloat MarginX = W(25);
    UIImage *image = [UIImage imageNamed:@"statistics_disclaimer_image"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MarginX, H(60.5), self.width - 2*MarginX, self.height - H(102))];
    bgImageView.image = image;
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    // add title label
    CGFloat titleLabW = bgImageView.width;
    CGFloat titleLabH = H(58);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabW, titleLabH)];
    titleLab.text = TitleLabelText;
    titleLab.font = [UIFont boldSystemFontOfSize:W(17.0)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:titleLab];
    
    // add bg scroView
    CGFloat bgScrollViewX = W(20);
    CGFloat bgScrollViewY = titleLab.height;
    CGFloat bgScrollViewW = bgImageView.width - 2*bgScrollViewX + W(6);
    CGFloat bgScrollViewH = bgImageView.height - titleLab.height - H(85);
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bgScrollViewX, bgScrollViewY, bgScrollViewW, bgScrollViewH)];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [bgImageView addSubview:bgScrollView];
    
    // add instructions content label
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, H(25), bgScrollView.width, bgScrollView.height - H(30))];
    contentLab.font = [UIFont systemFontOfSize:W(17.0)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = H(5);// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:contentLab.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:ContentText attributes:attributes];
    NSRange range1 = [ContentText rangeOfString:@"系统提醒："];
    [attribString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:W(17.0)] range:range1];
    NSRange range2 = [ContentText rangeOfString:@"免责声明："];
    [attribString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:W(17.0)] range:range2];
    CGSize labelSize = [ContentText sizeWithFont:contentLab.font andLineSpacing:paragraphStyle.lineSpacing maxSize:CGSizeMake(contentLab.width, MAXFLOAT)];
    contentLab.height = labelSize.height;
    contentLab.attributedText = attribString;
    contentLab.textColor = [UIColor whiteColor];
    contentLab.numberOfLines = 0;
    [bgScrollView addSubview:contentLab];
    
    bgScrollView.contentSize = CGSizeMake(bgScrollView.width, contentLab.height + H(55));
    
    CGFloat okBtnX = W(60);
    CGFloat okBtnW = bgImageView.width - 2*okBtnX;
    CGFloat okBtnH = H(43);
    CGFloat okBtnY = bgImageView.height - okBtnH - H(19);
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(okBtnX, okBtnY, okBtnW, okBtnH);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:W(22.0)];
    [okBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(okBtn.width, okBtn.height)] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(okBtn.width, okBtn.height)] forState:UIControlStateHighlighted];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = okBtnH*0.5;
    [okBtn addTarget:self action:@selector(p_okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:okBtn];
}

- (void)p_okBtnClick {
    [self p_dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)p_dismiss {
    [self removeFromSuperview];
}
@end
