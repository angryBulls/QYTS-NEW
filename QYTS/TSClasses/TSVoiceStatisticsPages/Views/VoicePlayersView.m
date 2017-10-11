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

@interface VoicePlayersView ()
@property (nonatomic, weak) UILabel *hostPlayerLab;
@property (nonatomic, weak) UILabel *guestPlayerLab;
@property (nonatomic, weak) UILabel *instructionsLab;

@property (nonatomic, strong) NSMutableArray *hostNumbArray;
@property (nonatomic, strong) NSMutableArray *guestNumbArray;
@end

@implementation VoicePlayersView
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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add host players、guest players、instructions label
    CGFloat labelY = H(11.5);
    CGFloat labelW = self.width/3;
    CGFloat labelH = H(13);
    
    UILabel *hostPlayerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, labelW, labelH)];
    hostPlayerLab.text = @"主队场上球员";
    hostPlayerLab.font = [UIFont systemFontOfSize:W(13.0)];
    hostPlayerLab.textColor = TSHEXCOLOR(0xb5d0ff);
    [self addSubview:hostPlayerLab];
    self.hostPlayerLab = hostPlayerLab;
    
    UILabel *guestPlayerLab = [[UILabel alloc] initWithFrame:CGRectMake(2*labelW, labelY, labelW, labelH)];
    guestPlayerLab.text = @"客队场上球员";
    guestPlayerLab.font = [UIFont systemFontOfSize:W(13.0)];
    guestPlayerLab.textColor = TSHEXCOLOR(0xb5d0ff);
    guestPlayerLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:guestPlayerLab];
    self.guestPlayerLab = guestPlayerLab;
    
//    UILabel *instructionsLab = [[UILabel alloc] initWithFrame:CGRectMake(hostPlayerLab.width, 0, labelW, labelH)];
//    instructionsLab.text = @"使用说明";
//    instructionsLab.font = [UIFont systemFontOfSize:W(13.0)];
//    instructionsLab.textColor = TSHEXCOLOR(0xb5d0ff);
//    instructionsLab.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:instructionsLab];
//    self.instructionsLab = instructionsLab;
    
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
        
        if (hostGuestTeamColorarray[0] == [UIColor clearColor]) {
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
@end
