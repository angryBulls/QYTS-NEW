//
//  VoicePlayersView.m
//  QYTS
//
//  Created by lxd on 2017/8/8.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "VoicePlayersView.h"
#import "TSInstructionsView.h"
#import "CustomUIButton.h"
#import "ManualTSView.h"
#import "TSVoiceViewModel.h"
#import "LCActionSheet.h"


@interface VoicePlayersView ()
@property (nonatomic, weak) UILabel *hostPlayerLab;
@property (nonatomic, weak) UILabel *guestPlayerLab;
@property (nonatomic, weak) UIButton *instructionsLab;

@property (nonatomic, strong) NSMutableArray *hostNumbArray;
@property (nonatomic, strong) NSMutableArray *guestNumbArray;

@property (nonatomic ,strong) UIButton *homeAbstainedBtn;
@property (nonatomic ,strong) UIButton *awayAbstainedBtn;
@property (nonatomic ,strong) LCActionSheet *actionSheet;
@property (nonatomic ,strong) TSDBManager *tSDBManager;

@property (nonatomic, copy) AbstentionSuccessBlock abstentionSuccessBlock;


@end

@implementation VoicePlayersView

-(TSDBManager *)tSDBManager{
    if (_tSDBManager == nil) {
        _tSDBManager = [[TSDBManager alloc] init];
    }
    return _tSDBManager;
}

- (NSMutableArray *)hostNumbArray {
    if (!_hostNumbArray) {
        _hostNumbArray = [NSMutableArray array];
    }
    return _hostNumbArray;
}

- (NSMutableArray *)guestNumbArray {
    if (!_guestNumbArray) {
        _guestNumbArray = [NSMutableArray array];
    }
    return _guestNumbArray;
}

- (instancetype)initWithFrame:(CGRect)frame abstentionSuccessBlock:(AbstentionSuccessBlock)abstentionSuccessBlock {
    if (self = [super initWithFrame:frame]) {
        _abstentionSuccessBlock = abstentionSuccessBlock;
        [self p_setupSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add host players、guest players、instructions label
    CGFloat labelY = H(9);
    CGFloat labelW = W(160/2);
    CGFloat labelH = H(13);
    
    UILabel *hostPlayerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, labelW, labelH)];
    
    hostPlayerLab.text = @"主队场上球员";
    hostPlayerLab.font = [UIFont systemFontOfSize:W(13.0)];
    hostPlayerLab.textColor = TSHEXCOLOR(0xb5d0ff);
    [self addSubview:hostPlayerLab];
    self.hostPlayerLab = hostPlayerLab;
    
    UILabel *guestPlayerLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width - labelW, labelY, labelW, labelH)];
    guestPlayerLab.text = @"客队场上球员";
    guestPlayerLab.font = [UIFont systemFontOfSize:W(13.0)];
    guestPlayerLab.textColor = TSHEXCOLOR(0xb5d0ff);
    guestPlayerLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:guestPlayerLab];
    self.guestPlayerLab = guestPlayerLab;
    
    UIButton *instructionBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-W(150/4), H(5.5), W(150/2), H(38/2))];
    
    instructionBtn.adjustsImageWhenHighlighted = NO;
    instructionBtn.layer.borderColor = TSHEXCOLOR(0xB5D0FF).CGColor;
    instructionBtn.layer.borderWidth = W(1);
    instructionBtn.layer.cornerRadius = W(5);
    instructionBtn.titleLabel.font = [UIFont systemFontOfSize:W(13.0)];
    [instructionBtn setTitleColor:TSHEXCOLOR(0xB5D0FF) forState:UIControlStateNormal];
    instructionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [instructionBtn setTitle:@"使用说明?" forState:UIControlStateNormal];
    [instructionBtn addTarget:self action:@selector(p_instructionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:instructionBtn];
    self.instructionsLab = instructionBtn;
    
    
    
    UIButton *homeAbstainedBtn = [self p_createButtonWithTitle:@"弃权"];
    homeAbstainedBtn.x = W(10) +labelW;
    homeAbstainedBtn.y = H(10/2);
    [homeAbstainedBtn addTarget:self action:@selector(p_homeAbstainedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:homeAbstainedBtn];
    self.homeAbstainedBtn = homeAbstainedBtn;
    
    UIButton *awayAbstainedBtn = [self p_createButtonWithTitle:@"弃权"];
    awayAbstainedBtn.x = self.width - labelW - W(10)-W(32);
    awayAbstainedBtn.y = homeAbstainedBtn.y;
    [awayAbstainedBtn addTarget:self action:@selector(p_awayAbstainedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:awayAbstainedBtn];
    self.awayAbstainedBtn = awayAbstainedBtn;
    
    
    // instructions button
//    UIImage *image = [UIImage imageNamed:@"question_mark_Icon"];
//    CGFloat questionBtnWH = W(30);
//    CGFloat questionBtnY = labelH - H(3);
//    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    questionBtn.frame = CGRectMake(0, questionBtnY, questionBtnWH, questionBtnWH);
//    questionBtn.centerX = self.width*0.5;
//    [questionBtn setBackgroundImage:image forState:UIControlStateNormal];
//    [questionBtn addTarget:self action:@selector(p_questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:questionBtn];
    
    // 获取主客队颜色
    TSCalculationTool *calculationTool = [[TSCalculationTool alloc] init];
    NSArray *hostGuestTeamColorarray = [calculationTool getHostTeamAndGuestTeamColor];
    
    // add host player number view
    int playersCount = 5;
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        playersCount = 3;
    }
    
    CGFloat hostNumbViewTotalW = (self.width - W(9))*0.5;
    CGFloat hostNumbViewTotalX = 0;
    CGFloat hostNumbViewTotalY = CGRectGetMaxY(self.hostPlayerLab.frame) + H(3.5);
    CGFloat hostNumbViewTotalH = self.height - hostNumbViewTotalY;
    UIView *hostNumbView = [[UIView alloc] initWithFrame:CGRectMake(hostNumbViewTotalX, hostNumbViewTotalY, hostNumbViewTotalW, hostNumbViewTotalH)];
    [self addSubview:hostNumbView];
    
    CGFloat numbBtnWH = W(32);
    CGFloat numbBtnY = (hostNumbView.height - numbBtnWH)*0.5;
    
    CGFloat MarginX = (hostNumbViewTotalW - playersCount*numbBtnWH)/4;
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        MarginX = W(20);
    }
    
    for (int i = 0; i < playersCount; i ++) {
        CGFloat numbLabX = (numbBtnWH + MarginX)*i;
        
        CustomUIButton *button = [CustomUIButton CustomUIButtonWithType:CustomButtonTypeCircle];
        button.frame = CGRectMake(numbLabX, numbBtnY, numbBtnWH, numbBtnWH);
        button.layer.borderColor = [hostGuestTeamColorarray[0] CGColor];
        [button setTitleColor:hostGuestTeamColorarray[0] forState:UIControlStateNormal];
        
        if (CGColorEqualToColor([hostGuestTeamColorarray[0] CGColor], [UIColor clearColor].CGColor)) {
            UIImage *image = [UIImage imageNamed:@"select_color_other_circle"];
            UIImageView *circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, numbBtnWH, numbBtnWH)];
            circleImageView.image = image;
            circleImageView.backgroundColor = [UIColor clearColor];
            
            [button setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
            [button addSubview:circleImageView];
        }
        
        [button addTarget:self action:@selector(p_hostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [hostNumbView addSubview:button];
        
        [self.hostNumbArray addObject:button];
    }
    
    // add guest player number view
    CGFloat guestNumbViewTotalW = hostNumbViewTotalW;
    CGFloat guestNumbViewTotalH = hostNumbViewTotalH;
    CGFloat guestNumbViewTotalX = self.width - guestNumbViewTotalW;
    CGFloat guestNumbViewTotalY = hostNumbViewTotalY;
    UIView *guestNumbView = [[UIView alloc] initWithFrame:CGRectMake(guestNumbViewTotalX, guestNumbViewTotalY, guestNumbViewTotalW, guestNumbViewTotalH)];
    [self addSubview:guestNumbView];
    
    for (int i = 0; i < playersCount; i ++) {
        CGFloat numbLabX = guestNumbView.width - (numbBtnWH + MarginX)*i - numbBtnWH;
        
        CustomUIButton *button = [CustomUIButton CustomUIButtonWithType:CustomButtonTypeCircle];
        button.frame = CGRectMake(numbLabX, numbBtnY, numbBtnWH, numbBtnWH);
        button.layer.borderColor = [hostGuestTeamColorarray[1] CGColor];
        [button setTitleColor:hostGuestTeamColorarray[1] forState:UIControlStateNormal];
        
        if (hostGuestTeamColorarray[1] == [UIColor clearColor]) {
            UIImage *image = [UIImage imageNamed:@"select_color_other_circle"];
            UIImageView *circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, numbBtnWH, numbBtnWH)];
            circleImageView.image = image;
            circleImageView.backgroundColor = [UIColor clearColor];
            
            [button setTitleColor:TSHEXCOLOR(0xffffff) forState:UIControlStateNormal];
            [button addSubview:circleImageView];
        }
        
        [button addTarget:self action:@selector(p_guestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [guestNumbView addSubview:button];
        
        [self.guestNumbArray addObject:button];
    }
    
    // add divid line
    CAShapeLayer *dividLine = [[CAShapeLayer alloc] init];
    dividLine.frame = CGRectMake(CGRectGetMaxX(hostNumbView.frame) + W(4.5), hostNumbView.y, 0.5, hostNumbView.height - H(3));
    dividLine.backgroundColor = TSHEXCOLOR(0x2B3F67).CGColor;
    [self.layer addSublayer:dividLine];
    
    [self updatePlayersStatus];
}


- (UIButton *)p_createButtonWithTitle:(NSString *)title {
    CGFloat buttonW = W(64/2);
    CGFloat buttonH = H(38/2);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonW, buttonH);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = W(5);
    [button setTitleColor:TSHEXCOLOR(0xFF4769) forState:UIControlStateNormal];
    button.layer.borderWidth = W(1);
    button.layer.borderColor = TSHEXCOLOR(0xFF4769).CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:W(13.0)];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
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


- (void)p_instructionBtnClick {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    RuleType ruleType = RuleType5V5;
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        ruleType = RuleType3V3;
    }
    TSInstructionsView *instView = [[TSInstructionsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ruleType:ruleType];
    [instView show];
}

- (void)p_questionBtnClick {
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSDictionary *gameTableDict = [tSDBManager getObjectById:GameId fromTable:GameTable];
    RuleType ruleType = RuleType5V5;
    if (2 == [gameTableDict[@"ruleType"] intValue]) { // 3V3
        ruleType = RuleType3V3;
    }
    TSInstructionsView *instView = [[TSInstructionsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ruleType:ruleType];
    [instView show];
}

- (void)updatePlayersStatus {
    // 取出主客队所有球员检录信息
    TSDBManager *tSDBManager = [[TSDBManager alloc] init];
    NSArray *playerCheckArrayH = [tSDBManager getObjectById:TeamCheckID_H fromTable:TSCheckTable];
    // 设置主队在场球员的号码
    NSMutableArray *hostPlayingNumArray = [NSMutableArray array];
    [playerCheckArrayH enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (1 == [subDict[@"playingStatus"] intValue]) {
            [hostPlayingNumArray addObject:[NSString stringWithFormat:@"%@", subDict[@"gameNum"]]];
        }
    }];
    
    [self.hostNumbArray enumerateObjectsUsingBlock:^(CustomUIButton *numbBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (hostPlayingNumArray.count >= (idx + 1)) {
            [numbBtn setTitle:hostPlayingNumArray[idx] forState:UIControlStateNormal];
            numbBtn.hidden = NO;
        } else {
            [numbBtn setTitle:@"" forState:UIControlStateNormal];
            numbBtn.hidden = YES;
        }
    }];
    
    // 设置客队在场球员的号码
    NSArray *playerCheckArrayG = [tSDBManager getObjectById:TeamCheckID_G fromTable:TSCheckTable];
    NSMutableArray *guestPlayingNumArray = [NSMutableArray array];
    [playerCheckArrayG enumerateObjectsUsingBlock:^(NSDictionary *subDict, NSUInteger idx, BOOL * _Nonnull stop) {
        if (1 == [subDict[@"playingStatus"] intValue]) {
            [guestPlayingNumArray addObject:[NSString stringWithFormat:@"%@", subDict[@"gameNum"]]];
        }
    }];
    
    [self.guestNumbArray enumerateObjectsUsingBlock:^(CustomUIButton *numbBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (guestPlayingNumArray.count >= (idx + 1)) {
            [numbBtn setTitle:guestPlayingNumArray[idx] forState:UIControlStateNormal];
            numbBtn.hidden = NO;
        } else {
            [numbBtn setTitle:@"" forState:UIControlStateNormal];
            numbBtn.hidden = YES;
        }
    }];
}

- (void)p_hostBtnClick:(CustomUIButton *)btn {
    NSDictionary *playerInfoDict = @{NumbResultStr : btn.currentTitle,
                                     BnfTeameType : @"0"};
    [self p_showManualTSViewWithPlayerInfoDict:playerInfoDict];
}

- (void)p_guestBtnClick:(CustomUIButton *)btn {
    NSDictionary *playerInfoDict = @{NumbResultStr : btn.currentTitle,
                                     BnfTeameType : @"1"};
    [self p_showManualTSViewWithPlayerInfoDict:playerInfoDict];
}

- (void)p_showManualTSViewWithPlayerInfoDict:(NSDictionary *)playerInfoDict {
    ManualTSView *manualTSView = [[ManualTSView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) insertDBSuccessBlock:^{
        
    }];
    manualTSView.playerInfoDict = playerInfoDict;
    [manualTSView show];
}
#pragma mark  actionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.actionSheet) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.actionSheet name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        self.actionSheet = nil;
    }
    
    if (1 == buttonIndex) {
        
        //判断是否有节次未提交
        NSMutableDictionary *gameTableDict = [[self.tSDBManager getObjectById:GameId fromTable:GameTable] mutableCopy];
        
        NSMutableDictionary *paramsDict1 = [NSMutableDictionary dictionary];
        TSVoiceViewModel *voiceViewModel = [[TSVoiceViewModel alloc] initWithPramasDict:paramsDict1];
        
        [voiceViewModel setBlockWithReturnBlock:^(id returnValue) {
            DDLog(@"up load data returnValue is:%@", returnValue);
            //提交比赛成功后，后台获得matchinfoid，用于以后提交数据使用（除第一节比赛不需要matchinfoId，其他场次提交的时候均需要matchinfoId）

                [self.tSDBManager putObject:gameTableDict withId:GameId intoTable:GameTable];
                
                TSDBManager *tSDBManager = [[TSDBManager alloc] init];
                NSMutableDictionary *gameTableDict = [[tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable] mutableCopy];
                //        DDLog(@"gameTableDict is:%@", gameTableDict);
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                paramsDict[@"matchId"] = gameTableDict[@"matchId"];
                
                
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
            
            
        } WithErrorBlock:^(id errorCode) {
            [SVProgressHUD showInfoWithStatus:errorCode];
        } WithFailureBlock:^{
            
            TSDBManager *tSDBManager = [[TSDBManager alloc] init];
            NSMutableDictionary *gameTableDict = [[tSDBManager getObjectById:GameCheckID fromTable:TSCheckTable] mutableCopy];
            //        DDLog(@"gameTableDict is:%@", gameTableDict);
            NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            paramsDict[@"matchId"] = gameTableDict[@"matchId"];
            
            
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

            [SVProgressHUD dismiss];
            
        }];
        [voiceViewModel sendCurrentStageData];

    }
}



@end
