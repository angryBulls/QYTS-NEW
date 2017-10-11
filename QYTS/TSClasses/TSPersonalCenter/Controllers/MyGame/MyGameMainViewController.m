//
//  MyGameMainViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MyGameMainViewController.h"
#import "MyGameSegmentView.h"
#import "MyGameOverViewController.h"
#import "MyGameUnCheckViewController.h"
#import "CustomUIScrollView.h"
#import "TSCreateGameHTViewController.h"

@interface MyGameMainViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) MyGameSegmentView *segmentView;
@property (nonatomic, strong) NSArray *VcNames;
@property (nonatomic, strong) CustomUIScrollView *containerScrollerView;
@end

@implementation MyGameMainViewController
- (NSArray *)VcNames {
    if (!_VcNames) {
        _VcNames = @[@"控制器一", @"控制器二"];
    }
    return _VcNames;
}

- (UIScrollView *)containerScrollerView {
    if (!_containerScrollerView) {
        _containerScrollerView = [[CustomUIScrollView alloc]init];
        _containerScrollerView.pagingEnabled = YES;
        _containerScrollerView.showsVerticalScrollIndicator = NO;
        _containerScrollerView.showsHorizontalScrollIndicator = NO;
        _containerScrollerView.contentSize = CGSizeMake(SCREEN_WIDTH*self.VcNames.count, SCREEN_HEIGHT);
//        _containerScrollerView.backgroundColor = [UIColor whiteColor];
        _containerScrollerView.delegate = self;
    }
    return _containerScrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"我的比赛" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_initScrollViewContainer];
    
    [self addChildControllers];
    
    [self p_initSegmentView];
    
    [self p_createGameButton];
}

- (void)p_initSegmentView {
    TSWeakSelf;
    MyGameSegmentView *segmentView = [[MyGameSegmentView alloc] initWithReturnBlcok:^(NSUInteger index) {
        __strong __typeof(__weakSelf) strongSelf = __weakSelf;
        [strongSelf.containerScrollerView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        UIViewController *viewController = strongSelf.childViewControllers[index];
        [strongSelf.containerScrollerView addSubview:viewController.view];
        viewController.view.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    if (MyGameMainDefaultVCUnCheck == self.defaultVC) {
        segmentView.selectIndex = 1;
    }
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
}

- (void)p_initScrollViewContainer {
    [self.view addSubview:self.containerScrollerView];
    self.containerScrollerView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT );
}

- (void)addChildControllers {
    MyGameOverViewController *gameOverVC = [[MyGameOverViewController alloc] init];
//    gameOverVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:gameOverVC];
    
    MyGameUnCheckViewController *gameUnCheckVC = [[MyGameUnCheckViewController alloc] init];
//    gameUnCheckVC.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:gameUnCheckVC];
    
    //默认展示第一个子控制器
    if (MyGameMainDefaultVCUnCheck == self.defaultVC) {
        self.containerScrollerView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
    [self scrollViewDidEndDecelerating:self.containerScrollerView];
}

//滑动减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //获取contentOffset
    CGPoint currentOffset = scrollView.contentOffset;
    NSInteger page = currentOffset.x / SCREEN_WIDTH;
    
    self.segmentView.selectIndex = page;
    //取出对应控制器
    UIViewController *viewController = self.childViewControllers[page];
    
    //添加到scrollView容器
    //    if (![viewController isViewLoaded]) {
    
    [self.containerScrollerView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(page*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //    }
    
}

- (void)p_createGameButton {
    CGFloat buttonX = W(21.5);
    CGFloat buttonW = self.view.width - 2*buttonX;
    CGFloat buttonH = H(43);
    CGFloat buttonY = self.view.height - buttonH - H(24.5);
    CGRect frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    UIButton *crateGameBtn = [self createButtonWithTile:@"创建比赛" frame:frame];
    [crateGameBtn addTarget:self action:@selector(p_crateGameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crateGameBtn];
}

- (void)p_crateGameBtnClick {
    TSCreateGameHTViewController *createGameVC = [[TSCreateGameHTViewController alloc] init];
    [self.navigationController pushViewController:createGameVC animated:YES];
}
@end
