//
//  TSStatisticsBaseViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/18.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSStatisticsBaseViewController.h"
#import "UIImage+Extension.h"

@interface TSStatisticsBaseViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TSStatisticsBaseViewController
#pragma mark - Lazy Method ********************************************************************************
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = TSHEXCOLOR(0x2b3f67);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TSHEXCOLOR(0x1b2a47);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.frame = CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT - H(50));
    
//    [self p_addTopView];
}

- (void)addTopViewWithPageType:(PageType)pageType {
    VoiceStatisticsTopView *topView = [[VoiceStatisticsTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(208.5)) pageType:pageType];
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    int stageGameTimes = [calculationTool getCurrentStageTimes];
    topView.currentSecond = stageGameTimes;
    [self.view addSubview:topView];
    self.topView = topView;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark  - 滑到最底部
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s < 1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r < 1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title {
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = frame;
    [submitBtn setTitle:title forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [submitBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xff4769) size:CGSizeMake(submitBtn.width, submitBtn.height)] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:TSHEXCOLOR(0xD00235) size:CGSizeMake(submitBtn.width, submitBtn.height)] forState:UIControlStateHighlighted];
    submitBtn.layer.cornerRadius = submitBtn.height*0.5;
    submitBtn.layer.masksToBounds = YES;
    
    return submitBtn;
}
@end
