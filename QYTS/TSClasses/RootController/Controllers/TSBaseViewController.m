//
//  QZBaseViewController.m
//  QiZhiMath
//
//  Created by lxd on 2017/5/5.
//  Copyright © 2017年 MacBook. All rights reserved.
//

#import "TSBaseViewController.h"
#import "QZNavBarTitleLabel.h"
#import "UIImage+Extension.h"

@interface TSBaseViewController ()
@property (nonatomic, strong) UIView *navBarBgView;
@property (nonatomic, strong) QZNavBarTitleLabel *titleLab;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation TSBaseViewController
#pragma mark - lazy method
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TSHEXCOLOR(0x1b2a47);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self p_CustomNavigationBar];
}

- (void)p_CustomNavigationBar {
    UIView *navBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navBarBgView.backgroundColor = TSHEXCOLOR(0x4da300);
    [self.view addSubview:navBarBgView];
    self.navBarBgView = navBarBgView;
    
    // add title view
    CGFloat titleLabWidth = navBarBgView.width * 0.6;
    CGFloat titleLabX = (navBarBgView.width - titleLabWidth)*0.5;
    _titleLab = [[QZNavBarTitleLabel alloc] initWithFrame:CGRectMake(titleLabX, 8, titleLabWidth, navBarBgView.height) txtColor:[UIColor whiteColor] borderColor:TSHEXCOLOR(0xffffff) borderWidth:2.0];
    [navBarBgView addSubview:self.titleLab];
    
    // add back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(W(3), 24, 29, 32);
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backButton_white"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:self action:@selector(p_BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarBgView addSubview:backBtn];
    self.backBtn = backBtn;
}

- (void)p_BackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCustomNavBarTitle:(NSString *)title backBtnHidden:(BOOL)backBtnHidden backBtnIconName:(NSString *)iconName navigationBarColor:(UIColor *)navigationBarColor titleColor:(UIColor *)titleColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.titleLab.text = title;
    self.backBtn.hidden = backBtnHidden;
    if (iconName) {
        [self.backBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    }
    
    if (navigationBarColor) {
        self.navBarBgView.backgroundColor = navigationBarColor;
    }
    
    if (titleColor) {
        self.titleLab.textColor = titleColor;
    }
    
    if (borderWidth >= 0) {
        self.titleLab.borderWidth = borderWidth;
    }
}

- (void)createRightBarButtonWithImageName:(NSString *)imageName {
    CGFloat rightBarBtnWH = 40;
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(self.navBarBgView.width - rightBarBtnWH - W(10), self.navBarBgView.height - rightBarBtnWH - 6, rightBarBtnWH, rightBarBtnWH);
    rightBarBtn.imageView.contentMode = UIViewContentModeCenter;
    [rightBarBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarBgView addSubview:rightBarBtn];
}

- (void)rightBarBtnClick {
    
}

- (void)showNavgationBarBottomLine {
    CAShapeLayer *bottomLine = [[CAShapeLayer alloc] init];
    bottomLine.frame = CGRectMake(0, self.navBarBgView.height - 1, self.view.width, 1);
    bottomLine.backgroundColor = TSHEXCOLOR(0x355185).CGColor;
    [self.navBarBgView.layer addSublayer:bottomLine];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIButton *)createButtonWithTile:(NSString *)submitTitle frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:submitTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [button setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(frame.size.width, frame.size.height)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(frame.size.width, frame.size.height)] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = frame.size.height*0.5;
    button.layer.masksToBounds = YES;
    
    return button;
}
@end
