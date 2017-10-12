//
//  TSManagerViewController.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSManagerViewController.h"
#import "TSSegmentedView.h"
#import "TSManagerSectionViewController.h"
#import "TSManagerFullViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface TSManagerViewController ()
// children view controllers
@property (nonatomic, strong) TSManagerSectionViewController *managerSectionVC;
@property (nonatomic, strong) TSManagerFullViewController *managerFullVC;
@property(nonatomic,strong) UIViewController *currentVC;
@property (nonatomic, weak) TSSegmentedView *segView;
@end

@implementation TSManagerViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *gameTableDict = [self.tSDBManager getObjectById:GameId fromTable:GameTable];
    if (1 == [gameTableDict[GameStatus] intValue]) {
        self.fd_interactivePopDisabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TSHEXCOLOR(0x1b2a47);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self p_AddChildViewControllers];
    
    [self p_createBottomSegmentview];
}

- (void)p_createBottomSegmentview {
    TSWeakSelf;
    TSSegmentedView *segView = [[TSSegmentedView alloc] initWithSelectStyle:SelectStyleBorderColor defaultSelect:(DefaultSelect)self.selectPageType returnBlcok:^(NSUInteger index) {
        __strong __typeof(__weakSelf) strongSelf = __weakSelf;
        if (0 == index) {
            [strongSelf transitionVC:strongSelf.currentVC toVC:strongSelf.managerSectionVC];
        } else if (1 == index) {
            [strongSelf transitionVC:strongSelf.currentVC toVC:strongSelf.managerFullVC];
        } else if (2 == index) {
            NSDictionary *gameTableDict = [strongSelf.tSDBManager getObjectById:GameId fromTable:GameTable];
            if (1 == [gameTableDict[GameStatus] intValue]) {
                [SVProgressHUD showInfoWithStatus:GameOver];
            } else {
                
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [self.view addSubview:segView];
    self.segView = segView;
}

- (void)p_AddChildViewControllers {
    _managerSectionVC = [[TSManagerSectionViewController alloc] init];
    _managerSectionVC.tSDBManager = self.tSDBManager;
    _managerSectionVC.gameModel = self.gameModel;
    _managerSectionVC.currentSecond = self.currentSecond;
    
    _managerFullVC = [[TSManagerFullViewController alloc] init];
    _managerFullVC.tSDBManager = self.tSDBManager;
    
    if (self.selectPageType == SelectPageTypeSection) {
        [self addChildViewController:self.managerSectionVC];
        [self.view addSubview:self.managerSectionVC.view];
        _currentVC = self.managerSectionVC;
    } else if (self.selectPageType == SelectPageTypeFull) {
        [self addChildViewController:self.managerFullVC];
        [self.view addSubview:self.managerFullVC.view];
        _currentVC = self.managerFullVC;
    }
}

- (void)transitionVC:(UIViewController *)currentVC toVC:(UIViewController *)newVC {
    [self addChildViewController:newVC];
    
    [self transitionFromViewController:currentVC toViewController:newVC duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVC didMoveToParentViewController:self];
            [currentVC willMoveToParentViewController:nil];
            [currentVC removeFromParentViewController];
            self.currentVC = newVC;
        } else {
            self.currentVC = currentVC;
            [newVC willMoveToParentViewController:nil];
            [newVC removeFromParentViewController];
        }
    }];
}
@end
