//
//  MyGameGameDetailsViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "MyGameGameDetailsViewController.h"
#import "TSTeamInfoView.h"
#import "TSRecorderInfoView.h"
#import "PersonalViewModel.h"
#import "MatchDetailScoreView.h"
#import "ShareMatchInfoModel.h"

@interface MyGameGameDetailsViewController ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) TSTeamInfoView *teamInfoView;
@property (nonatomic, strong) MatchDetailScoreView *detailScoreView;
@property (nonatomic, weak) TSRecorderInfoView *recorderInfoView;
@end

@implementation MyGameGameDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"赛事详情" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_createBgView];
    
    [self p_createTeamInfoView];
    
    [self p_createStageScroreView];
    
    [self p_createTSInfoView];
    
    [self p_getUserHistoryMatchDetail];
}

- (void)p_createBgView {
    CGFloat bgViewX = W(7.5);
    CGFloat bgViewY = 64 + H(7);
    CGFloat bgViewW = self.view.width - 2*bgViewX;
    CGFloat bgViewH = H(380);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = W(5);
    [self.view addSubview:bgView];
    self.bgView = bgView;
}

- (void)p_createTeamInfoView {
    TSTeamInfoView *teamInfoView = [[TSTeamInfoView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, H(130))];
    [self.bgView addSubview:teamInfoView];
    self.teamInfoView = teamInfoView;
}

- (void)p_createStageScroreView {
    CGFloat stageScoreViewX = 0;
    CGFloat stageScoreViewW = self.bgView.width;
    CGFloat stageScoreViewY = CGRectGetMaxY(self.teamInfoView.frame);
    CGFloat stageScoreViewH = H(100);
    MatchDetailScoreView *detailScoreView = [[MatchDetailScoreView alloc] initWithFrame:CGRectMake(stageScoreViewX, stageScoreViewY, stageScoreViewW, stageScoreViewH)];
    [self.bgView addSubview:detailScoreView];
    self.detailScoreView = detailScoreView;
    
    // add top line
    CGFloat topLayerX = W(3.5);
    CGFloat topLayerY = 0;
    CGFloat topLayerW = self.bgView.width - 2*topLayerX;
    CAShapeLayer *topLayer = [[CAShapeLayer alloc] init];
    topLayer.frame = CGRectMake(topLayerX, topLayerY, topLayerW, 1);
    topLayer.backgroundColor = TSHEXCOLOR(0x1B2A47).CGColor;
    [self.detailScoreView.layer addSublayer:topLayer];
    
    // add bottom line
    CGFloat bottomLayerX = topLayerX;
    CGFloat bottomLayerY = self.detailScoreView.height - 1;
    CGFloat bottomLayerW = topLayerW;
    CAShapeLayer *bottomLayer = [[CAShapeLayer alloc] init];
    bottomLayer.frame = CGRectMake(bottomLayerX, bottomLayerY, bottomLayerW, 1);
    bottomLayer.backgroundColor = TSHEXCOLOR(0x1B2A47).CGColor;
    [self.detailScoreView.layer addSublayer:bottomLayer];
}

- (void)p_createTSInfoView {
    // create left recorder info view
    TSRecorderInfoView *recorderInfoView = [[TSRecorderInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.detailScoreView.frame) + H(10), self.bgView.width*0.5, H(119))];
    [self.bgView addSubview:recorderInfoView];
    self.recorderInfoView = recorderInfoView;
}

- (void)p_getUserHistoryMatchDetail {
    [self.indicatorView showWithView:self.view];
    
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    paramsDict[@"matchId"] = self.matchId;
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"getUserHistoryMatchDetail returnValue is:%@", returnValue);
        ShareMatchInfoModel *infoModel = returnValue;
        
        self.teamInfoView.matchInfoModel = infoModel;
        
        self.detailScoreView.matchInfoModel = infoModel;
        
        [self p_setupRecorderInfoWithModel:infoModel];
        
        [self.indicatorView dismiss];
    } WithErrorBlock:^(id errorCode) {
        [self.indicatorView dismiss];
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [self.indicatorView dismiss];
    }];
    [personalViewModel getUserHistoryMatchDetail];
}

- (void)p_setupRecorderInfoWithModel:(ShareMatchInfoModel *)infoModel {
    if (1 == infoModel.ruleType.intValue) { // 5V5
        self.bgView.height = H(530);
        self.recorderInfoView.height = H(270);
        self.recorderInfoView.titleArray = @[@"主裁判：", @"第一副裁：", @"第二副裁：", @"技术代表：", @"技术统计："];
        NSMutableArray *contentArray = [NSMutableArray array];
        if (infoModel.mainReferee.length) {
            [contentArray addObject:infoModel.mainReferee];
        } else {
            [contentArray addObject:@""];
        }
        
        if (infoModel.firstReferee.length) {
            [contentArray addObject:infoModel.firstReferee];
        } else {
            [contentArray addObject:@""];
        }
        
        if (infoModel.secondReferee.length) {
            [contentArray addObject:infoModel.secondReferee];
        } else {
            [contentArray addObject:@""];
        }
        
        if (infoModel.td.length) {
            [contentArray addObject:infoModel.td];
        } else {
            [contentArray addObject:@""];
        }
        
        if (infoModel.recorder.length) {
            [contentArray addObject:infoModel.recorder];
        } else if (infoModel.nickName.length) {
            [contentArray addObject:infoModel.nickName];
        } else {
            [contentArray addObject:@""];
        }
        
        self.recorderInfoView.contentArray = contentArray;
    } else if (2 == infoModel.ruleType.intValue) { // 3X3
        self.recorderInfoView.titleArray = @[@"主裁判：", @"技术代表：", @"记录员："];
        NSMutableArray *contentArray = [NSMutableArray array];
        if (infoModel.mainReferee.length) {
            [contentArray addObject:infoModel.mainReferee];
        } else {
            [contentArray addObject:@""];
        }
        
        if (infoModel.td.length) {
            [contentArray addObject:infoModel.td];
        } else {
            [contentArray addObject:@""];
        }
        
        if (infoModel.recorder.length) {
            [contentArray addObject:infoModel.recorder];
        } else if (infoModel.nickName.length) {
            [contentArray addObject:infoModel.nickName];
        } else {
            [contentArray addObject:@""];
        }
        
        self.recorderInfoView.contentArray = contentArray;
    }
}
@end
