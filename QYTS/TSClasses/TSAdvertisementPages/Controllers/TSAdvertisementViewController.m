//
//  TSAdvertisementViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/26.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSAdvertisementViewController.h"
#import "AdvertisementViewModel.h"
#import "UIImageView+WebCache.h"
#import "TSCustomWebView.h"
#import "UIImage+Extension.h"

#define adShowTime 5

@interface TSAdvertisementViewController () <UIWebViewDelegate>
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, weak) UIImageView *adBgimageView;
@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation TSAdvertisementViewController
{
    NSDictionary *adInfoDict;
    TSCustomWebView *webView;
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"内容" backBtnHidden:YES backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_createCancelAdButton];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"advertisement_bg_image"];
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    [self p_createAdBgImageView];
    
    [self p_addTimeLabel];
    
    [self p_addCancelAdButton];
    
    [self getDataFromSever];
}

- (void)p_createAdBgImageView {
    CGFloat adBgimageViewH = self.view.height - H(120);
    UIImageView *adBgimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, adBgimageViewH)];
    adBgimageView.userInteractionEnabled = YES;
    adBgimageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:adBgimageView];
    self.adBgimageView = adBgimageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_showAdContent)];
    [self.adBgimageView addGestureRecognizer:tap];
}

- (void)p_showAdContent {
    if (adInfoDict[@"linkUrl"]) {
        [self p_stopGCDTimer];
        [self.timeLabel removeFromSuperview];
        webView = [[TSCustomWebView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65)];
        webView.delegate = self;
        [self.view addSubview:webView];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:adInfoDict[@"linkUrl"]]];
        [webView loadRequest:request];
    }
}

- (void)getDataFromSever {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    AdvertisementViewModel *advertisementViewModel = [[AdvertisementViewModel alloc] initWithPramasDict:paramsDict];
    [advertisementViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"getGuide returnValue is:%@", returnValue);
        if ([returnValue[@"entity"][@"guides"] count]) {
            adInfoDict = [returnValue[@"entity"][@"guides"] lastObject];
            if (adInfoDict[@"imageUrl"]) {
//                [self.adBgimageView sd_setImageWithURL:[NSURL URLWithString:adInfoDict[@"imageUrl"]]];
            }
        } else {
            [self p_stopGCDTimer];
            [self p_setGuidPageBeRootView];
        }
    } WithErrorBlock:^(id errorCode) {
        [self p_stopGCDTimer];
        [self p_setGuidPageBeRootView];
    } WithFailureBlock:^{
        [self p_stopGCDTimer];
        [self p_setGuidPageBeRootView];
    }];
    [advertisementViewModel getGuide];
}

- (void)p_createCancelAdButton {
    CGFloat cancelBtnW = W(80);
    CGFloat cancelBtnH = 40;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 20, cancelBtnW, cancelBtnH);
    [cancelBtn setTitle:@"关 闭" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [cancelBtn setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(p_cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void)p_cancelBtnClick {
    [self p_setGuidPageBeRootView];
}

- (void)p_addTimeLabel {
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    timeLabel.textColor = BASE_COLOR;
    timeLabel.font = [UIFont systemFontOfSize:W(16.0)];
    [self.view addSubview:timeLabel];
    self.timeLabel = timeLabel;
    __block int timeout = adShowTime;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //结束关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                timeLabel.text = @"";
                [self p_setGuidPageBeRootView];
            });
        } else {
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                timeLabel.text = [NSString stringWithFormat:@"%@秒",strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)p_addCancelAdButton {
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat cancelBtnW = 50;
    CGFloat cancelBtnH = 30;
    CGFloat cancelBtnX = SCREEN_WIDTH - cancelBtnW - 15;
    CGFloat cancelBtnY = SCREEN_HEIGHT - cancelBtnH - H(100);
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
    [cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] size:cancelBtn.frame.size] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"跳  过" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancelBtn addTarget:self action:@selector(p_addCancelAdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void)p_addCancelAdBtnClick {
    [self p_stopGCDTimer];
    [self p_setGuidPageBeRootView];
}

- (void)p_stopGCDTimer {
    if(_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)p_setGuidPageBeRootView {
    [(AppDelegate *)[UIApplication sharedApplication].delegate setGuidPageBeRootView];
}

#pragma mark - Delegate Method ********************************************************************************
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.bgImageView removeFromSuperview];
    [self.adBgimageView removeFromSuperview];
}

- (void)dealloc {
    DDLog(@"TSAdvertisementViewController ------ dealloc");
}
@end
