//
//  TSAbstainedView.m
//  QYTS
//
//  Created by lxd on 2017/9/7.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSAbstainedView.h"
#import "LCActionSheet.h"
#import "TSVoiceViewModel.h"

@interface TSAbstainedView () <LCActionSheetDelegate>
@property (nonatomic, weak) UIButton *homeAbstainedBtn;
@property (nonatomic, weak) UIButton *awayAbstainedBtn;
@property (nonatomic, weak) LCActionSheet *actionSheet;
@property (nonatomic, copy) AbstentionSuccessBlock abstentionSuccessBlock;
@end

@implementation TSAbstainedView
- (instancetype)initWithFrame:(CGRect)frame abstentionSuccessBlock:(AbstentionSuccessBlock)abstentionSuccessBlock {
    if (self = [super initWithFrame:frame]) {
        _abstentionSuccessBlock = abstentionSuccessBlock;
        [self p_AddSubViews];
    }
    
    return self;
}

- (void)p_AddSubViews {
    UIButton *homeAbstainedBtn = [self p_createButtonWithTitle:@"主队弃权"];
    homeAbstainedBtn.x = W(9);
    homeAbstainedBtn.y = (self.height - homeAbstainedBtn.height)*0.5;
    [homeAbstainedBtn addTarget:self action:@selector(p_homeAbstainedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:homeAbstainedBtn];
    self.homeAbstainedBtn = homeAbstainedBtn;
    
    UIButton *awayAbstainedBtn = [self p_createButtonWithTitle:@"客队弃权"];
    awayAbstainedBtn.x = self.width - awayAbstainedBtn.width - W(9);
    awayAbstainedBtn.y = homeAbstainedBtn.y;
    [awayAbstainedBtn addTarget:self action:@selector(p_awayAbstainedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:awayAbstainedBtn];
    self.awayAbstainedBtn = awayAbstainedBtn;
    
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if (gameTableDict[@"abstention"]) {
        if (1 == [gameTableDict[@"abstention"] intValue] || 2 == [gameTableDict[@"abstention"] intValue]) {
            self.homeAbstainedBtn.enabled = NO;
            self.homeAbstainedBtn.backgroundColor = [UIColor grayColor];
            self.awayAbstainedBtn.enabled = NO;
            self.awayAbstainedBtn.backgroundColor = [UIColor grayColor];
        }
    }
}

- (void)p_homeAbstainedBtnClick {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"主队弃权", nil];
    actionSheet.tag = 0;
    [actionSheet show];
    self.actionSheet = actionSheet;
}

- (void)p_awayAbstainedBtnClick {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"客队弃权", nil];
    actionSheet.tag = 1;
    [actionSheet show];
    self.actionSheet = actionSheet;
}

- (UIButton *)p_createButtonWithTitle:(NSString *)title {
    CGFloat buttonW = W(66);
    CGFloat buttonH = H(20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonW, buttonH);
    button.backgroundColor = TSHEXCOLOR(0x2B91CF);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = W(5);
    [button setTitleColor:TSHEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:W(13.0)];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.actionSheet) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.actionSheet name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        self.actionSheet = nil;
    }
    
    if (1 == buttonIndex) {
        TSDBManager *tSDBManager = [[TSDBManager alloc] init];
        NSMutableDictionary *gameTableDict = [[tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
        DDLog(@"gameTableDict is:%@", gameTableDict);
        
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        paramsDict[@"matchId"] = gameTableDict[@"matchInfoId"];
        if (0 == actionSheet.tag) { // 主队弃权
            paramsDict[@"teamType"] = @1;
        } else { // 客队弃权
            paramsDict[@"teamType"] = @2;
        }
        
        TSVoiceViewModel *voiceViewModel = [[TSVoiceViewModel alloc] initWithPramasDict:paramsDict];
        [voiceViewModel setBlockWithReturnBlock:^(id returnValue) {
            DDLog(@"abstention returnValue is:%@", returnValue);
            if (0 == actionSheet.tag) { // 主队弃权成功
                gameTableDict[@"abstention"] = @"1";
            } else { // 客队弃权成功
                gameTableDict[@"abstention"] = @"2";
            }
            gameTableDict[GameStatus] = @"1";
            [tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
            self.homeAbstainedBtn.enabled = NO;
            self.homeAbstainedBtn.backgroundColor = [UIColor grayColor];
            self.awayAbstainedBtn.enabled = NO;
            self.awayAbstainedBtn.backgroundColor = [UIColor grayColor];
            DDLog(@"abstentioned gameTableDict is:%@", [tSDBManager getObjectById:GameId fromTable:GameTable]);
            if (0 == actionSheet.tag) {
                [SVProgressHUD showInfoWithStatus:@"主队弃权成功"];
            } else {
                [SVProgressHUD showInfoWithStatus:@"客队弃权成功"];
            }
            self.abstentionSuccessBlock ? self.abstentionSuccessBlock() : nil;
        } WithErrorBlock:^(id errorCode) {
            [SVProgressHUD showInfoWithStatus:errorCode];
        } WithFailureBlock:^{
            [SVProgressHUD dismiss];
        }];
        
        if (LoginUserTypeNormal == CurrentUserType) {
            [voiceViewModel abstentionNormal];
        } else if (LoginUserTypeBCBC == CurrentUserType) {
            [voiceViewModel abstentionBCBC];
        } else if (LoginUserTypeCBO == CurrentUserType) {
            [voiceViewModel abstentionCBO];
        }
    }
}
@end
