//
//  LoginBaseViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/11.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "LoginBaseViewController.h"

@interface LoginBaseViewController ()

@end

@implementation LoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addContactUSContentView];
}

- (void)addContactUSContentView {
    CGFloat contactLabH = H(45);
    UILabel *contactLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - contactLabH - 22, self.view.width, contactLabH)];
    contactLab.text = ContactUSContent;
    contactLab.font = [UIFont systemFontOfSize:W(12.0)];
    contactLab.textColor = TSHEXCOLOR(0x83a3e4);
    contactLab.textAlignment = NSTextAlignmentCenter;
    contactLab.numberOfLines = 0;
    [self.view addSubview:contactLab];
}
@end
