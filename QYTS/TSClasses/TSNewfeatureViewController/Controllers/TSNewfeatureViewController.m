//
//  TSNewfeatureViewController.m
//  QYTS
//
//  Created by lxd on 2017/8/2.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSNewfeatureViewController.h"
#import "UIImage+Extension.h"
#import "CustomUIButtonArrow.h"

#define NewfeatureCount 3

@interface TSNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@end

@implementation TSNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat scrollViewW = scrollView.width;
    CGFloat scrollViewH = scrollView.height;
    for (int i = 0; i < NewfeatureCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.x = scrollViewW * i;
        imageView.width = scrollViewW;
        imageView.height = scrollViewH;
        NSString *imageName = [NSString  stringWithFormat:@"new_feature_%d",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        
        if (i == NewfeatureCount - 1) {
            // add Experience button
//            [self p_addExperienceButtonWithImageView:imageView];
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollViewW * NewfeatureCount, 0);
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = NewfeatureCount;
    pageControl.width = 100;
    pageControl.centerX = scrollViewW * 0.5;
    pageControl.y = self.view.height - pageControl.height - H(35);
    pageControl.currentPageIndicatorTintColor = TSCOLOR(253, 119, 21);
    pageControl.pageIndicatorTintColor = TSCOLOR(246, 246, 246);
    pageControl.hidden = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    [self p_createBottomButtons];
}

- (void)p_addExperienceButtonWithImageView:(UIImageView *)imageView {
    imageView.userInteractionEnabled = YES;
    
    CGFloat experienceBtnX = W(60);
    CGFloat experienceBtnW = self.view.width - 2*experienceBtnX;
    CGFloat experienceBtnH = H(55);
    CGFloat experienceBtnY = self.view.height - experienceBtnH - H(35);
    UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    experienceBtn.frame = CGRectMake(experienceBtnX, experienceBtnY, experienceBtnW, experienceBtnH);
    [experienceBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [experienceBtn setTitleColor:TSCOLOR(200, 0, 43) forState:UIControlStateNormal];
    experienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:W(22.0)];
    experienceBtn.backgroundColor = [UIColor whiteColor];
    experienceBtn.layer.masksToBounds = YES;
    experienceBtn.layer.cornerRadius = experienceBtnH*0.5;
    [experienceBtn addTarget:self action:@selector(p_experienceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:experienceBtn];
}

- (void)p_experienceBtnClick {
    [(AppDelegate *)[UIApplication sharedApplication].delegate switchWindowView];
}

- (void)p_createBottomButtons {
    CGFloat leftBtnW = W(80);
    CGFloat leftBtnH = H(30);
    CGFloat leftBtnX = W(30);
    CGFloat leftBtnY = self.view.height - leftBtnH - H(20);
    UIButton *leftBtn = [CustomUIButtonArrow buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(leftBtnX, leftBtnY, leftBtnW, leftBtnH);
    [leftBtn setTitle:@"跳过" forState:UIControlStateSelected];
    [leftBtn setImage:[UIImage imageNamed:@"new_feature_left_arrow"] forState:UIControlStateNormal];
    leftBtn.selected = YES;
    [leftBtn addTarget:self action:@selector(p_leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    self.leftBtn = leftBtn;
    
    CGFloat rightBtnW = leftBtnW;
    CGFloat rightBtnH = leftBtnH;
    CGFloat rightBtnX = self.view.width - rightBtnW - leftBtnX;
    CGFloat rightBtnY = leftBtnY;
    UIButton *rightBtn = [CustomUIButtonArrow buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(rightBtnX, rightBtnY, rightBtnW, rightBtnH);
    [rightBtn setTitle:@"点击开始" forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageNamed:@"new_feature_right_arrow"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(p_rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    self.rightBtn = rightBtn;
}

- (void)p_leftBtnClick:(UIButton *)leftBtn {
    if (leftBtn.selected) {
        [self p_experienceBtnClick];
    } else { // 往前一页
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake((self.pageControl.currentPage - 1)*SCREEN_WIDTH, 0);
        }];
    }
}

- (void)p_rightBtnClick:(UIButton *)rightBtn {
    if (rightBtn.selected) {
        [self p_experienceBtnClick];
    } else { // 往后一页
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake((self.pageControl.currentPage + 1)*SCREEN_WIDTH, 0);
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
    
    if (0 == self.pageControl.currentPage) {
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
    } else if (NewfeatureCount - 1 == self.pageControl.currentPage) {
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;
    } else {
        self.leftBtn.selected = NO;
        self.rightBtn.selected = NO;
    }
}

- (void)dealloc {
    DDLog(@"----- newfeature -----");
}
@end
