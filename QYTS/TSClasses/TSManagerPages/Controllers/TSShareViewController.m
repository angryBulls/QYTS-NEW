//
//  TSShareViewController.m
//  QYTS
//
//  Created by lxd on 2017/8/14.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSShareViewController.h"
#import "CustomShareButton.h"
#import "TSShareManagerTools.h"
#import "TSShareHeaderView.h"
#import "TSShareGameInfoView.h"
#import "ShareScoreView.h"
#import "NSString+SizeFont.h"
#import "PersonalViewModel.h"
#import "ShareMatchInfoModel.h"

@interface TSShareViewController ()
@property (nonatomic, weak) TSShareHeaderView *headerView;
@property (nonatomic, weak) TSShareGameInfoView *gameInfoView;
@property (nonatomic, strong) ShareScoreView *shareScoreView;
@property (nonatomic, weak) UILabel *recorderLab;
@property (nonatomic, weak) UILabel *signTitleLab;
@property (nonatomic, weak) UILabel *signLab;
@property (nonatomic, weak) UILabel *tipsLab;
@end

@implementation TSShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
//    self.view.alpha = 0.8;
    
    [self setCustomNavBarTitle:@"" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self p_createTopViews];
    
    [self p_createGameInfoViews];
    
    [self p_createStageScroreView];
    
    [self p_createRecorderLabel];
    
    [self p_createTipsLabel];
    
    [self p_createBottmShareButton];
    
    [self p_getShareMatchInfo];
}

- (void)p_getShareMatchInfo {
    [self.indicatorView showWithView:self.view];
    
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    paramsDict[@"matchId"] = self.matchInfoId;
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
//        DDLog(@"shareMatchInfo returnValue is:%@", returnValue);
        ShareMatchInfoModel *infoModel = returnValue;
        self.headerView.highScorePlayer = infoModel.highScorePlayer;
        if (infoModel.playerPhoto.length) {
            self.headerView.playerPhoto = infoModel.playerPhoto;
        }
        
        self.gameInfoView.matchInfoModel = infoModel;
        
        self.shareScoreView.matchInfoModel = infoModel;
        
        if (infoModel.nickName.length) {
            self.recorderLab.text = [NSString stringWithFormat:@"技术统计：%@", infoModel.nickName];
        }
        
        if (infoModel.sign.length) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = H(3);
            NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:infoModel.sign];
            [attribString addAttribute:NSFontAttributeName value:self.signLab.font range:NSMakeRange(0, attribString.length)];
            [attribString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attribString.length)];
            CGSize labelSize = [infoModel.sign sizeWithFont:self.signLab.font andLineSpacing:paragraphStyle.lineSpacing maxSize:CGSizeMake(self.signLab.width, MAXFLOAT)];
            self.signLab.height = labelSize.height;
            self.signLab.attributedText = attribString;
            
            self.tipsLab.y = CGRectGetMaxY(self.signLab.frame);
        }
        
        [self.indicatorView dismiss];
    } WithErrorBlock:^(id errorCode) {
        [self.indicatorView dismiss];
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [self.indicatorView dismiss];
    }];
    [personalViewModel shareMatchInfo];
}

- (void)p_createTopViews {
    CGFloat topViewY = 0;
    CGFloat topViewW = W(330);
    CGFloat topViewH = H(339);
    CGFloat topViewX = (self.view.width - topViewW)*0.5;
    TSShareHeaderView *headerView = [[TSShareHeaderView alloc] initWithFrame:CGRectMake(topViewX, topViewY, topViewW, topViewH)];
    [self.view addSubview:headerView];
    self.headerView = headerView;
}

- (void)p_createGameInfoViews {
    CGFloat gameInfoViewX = 0;
    CGFloat gameInfoViewY = CGRectGetMaxY(self.headerView.frame) - H(90);
    CGFloat gameInfoViewW = self.view.width;
    CGFloat gameInfoViewH = H(90);
    TSShareGameInfoView *gameInfoView = [[TSShareGameInfoView alloc] initWithFrame:CGRectMake(gameInfoViewX, gameInfoViewY, gameInfoViewW, gameInfoViewH)];
    [self.view addSubview:gameInfoView];
    self.gameInfoView = gameInfoView;
}

- (void)p_createStageScroreView {
    CGFloat stageScoreViewX = W(17.5);
    CGFloat stageScoreViewW = self.view.width - 2*stageScoreViewX;
    CGFloat stageScoreViewY = CGRectGetMaxY(self.gameInfoView.frame) + H(12);
    CGFloat stageScoreViewH = H(83);
    ShareScoreView *shareScoreView = [[ShareScoreView alloc] initWithFrame:CGRectMake(stageScoreViewX, stageScoreViewY, stageScoreViewW, stageScoreViewH)];
    [self.view addSubview:shareScoreView];
    self.shareScoreView = shareScoreView;
}

- (void)p_createRecorderLabel {
    CGFloat recorderLabX = W(35.5);
    CGFloat recorderLabY = CGRectGetMaxY(self.shareScoreView.frame) + H(10);
    CGFloat recorderLabW = self.view.width - 2*recorderLabX;
    CGFloat recorderLabH = H(16);
    UILabel *recorderLab = [[UILabel alloc] initWithFrame:CGRectMake(recorderLabX, recorderLabY, recorderLabW, recorderLabH)];
    recorderLab.font = [UIFont systemFontOfSize:W(13.0)];
    recorderLab.textColor = TSHEXCOLOR(0xfefefe);
    recorderLab.text = @"技术统计：";
    [self.view addSubview:recorderLab];
    self.recorderLab = recorderLab;
    
    CGFloat signTitleLabX = recorderLabX;
    CGFloat signTitleLabY = CGRectGetMaxY(self.recorderLab.frame) + H(3);
    CGFloat signTitleLabW = W(68);
    CGFloat signTitleLabH = recorderLabH;
    UILabel *signTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(signTitleLabX, signTitleLabY, signTitleLabW, signTitleLabH)];
    signTitleLab.font = [UIFont systemFontOfSize:W(13.0)];
    signTitleLab.textColor = TSHEXCOLOR(0xfefefe);
    signTitleLab.text = @"个性签名：";
    [self.view addSubview:signTitleLab];
    self.signTitleLab = signTitleLab;
    
    CGFloat signLabX = CGRectGetMaxX(signTitleLab.frame) - W(4);
    CGFloat signLabY = signTitleLabY;
    CGFloat signLabW = self.view.width - signLabX - signTitleLabX;
    CGFloat signLabH = signTitleLabH;
    UILabel *signLab = [[UILabel alloc] initWithFrame:CGRectMake(signLabX, signLabY, signLabW, signLabH)];
    signLab.font = [UIFont systemFontOfSize:W(13.0)];
    signLab.textColor = TSHEXCOLOR(0xfefefe);
    signLab.text = @"暂无个性签名";
    signLab.numberOfLines = 0;
    [self.view addSubview:signLab];
    self.signLab = signLab;
}

- (void)p_createTipsLabel {
    CGFloat tipsLabX = W(35.5);
    CGFloat tipsLabY = CGRectGetMaxY(self.signLab.frame);
    CGFloat tipsLabW = self.view.width - 2*tipsLabX;
    CGFloat tipsLabH = H(48);
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(tipsLabX, tipsLabY, tipsLabW, tipsLabH)];
    tipsLab.font = [UIFont systemFontOfSize:W(13.0)];
    tipsLab.textColor = TSHEXCOLOR(0xfefefe);
    tipsLab.text = @"更多球员技术统计数据已同步到篮球圈-球友圈，\n请前往应用市场下载查看";
    tipsLab.numberOfLines = 0;
    [self.view addSubview:tipsLab];
    self.tipsLab = tipsLab;
}

- (void)p_createBottmShareButton {
    CGFloat shareBtnW = W(57);
    CGFloat shareBtnH = H(80);
    CGFloat MarginX = W(86.5);
    
    CGFloat weiboBtnY = CGRectGetMaxY(self.shareScoreView.frame) + H(130);
    CustomShareButton *weiboBtn = [CustomShareButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(MarginX, weiboBtnY, shareBtnW, shareBtnH);
    [weiboBtn setTitle:@"微博" forState:UIControlStateNormal];
    [weiboBtn setImage:[UIImage imageNamed:@"share_weibo_Icon"] forState:UIControlStateNormal];
    weiboBtn.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
    [weiboBtn addTarget:self action:@selector(p_weiboBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    
    CGFloat weixinBtnX = self.view.width - MarginX - shareBtnW;
    CustomShareButton *weixinBtn = [CustomShareButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(weixinBtnX, weiboBtnY, shareBtnW, shareBtnH);
    [weixinBtn setTitle:@"朋友圈 " forState:UIControlStateNormal];
    [weixinBtn setImage:[UIImage imageNamed:@"share_weixin_Icon"] forState:UIControlStateNormal];
    weixinBtn.titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
    [weixinBtn addTarget:self action:@selector(p_weixinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
}

- (void)p_weiboBtnClick { // 分享到微博
    TSShareManagerTools *shareManager = [[TSShareManagerTools alloc] initWithPlatformType:UMSocialPlatformType_Sina currentViewController:self];
    shareManager.matchInfoId = self.matchInfoId;
    [shareManager shareWebPage];
}

- (void)p_weixinBtnClick { // 分享到微信朋友圈
    TSShareManagerTools *shareManager = [[TSShareManagerTools alloc] initWithPlatformType:UMSocialPlatformType_WechatTimeLine currentViewController:self];
    shareManager.matchInfoId = self.matchInfoId;
    [shareManager shareWebPage];
}
@end
