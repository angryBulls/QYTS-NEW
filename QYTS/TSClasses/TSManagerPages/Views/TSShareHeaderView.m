//
//  TSShareHeaderView.m
//  QYTS
//
//  Created by lxd on 2017/8/15.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSShareHeaderView.h"
#import "QZNavBarTitleLabel.h"
#import "TSManagerPlayerModel.h"
#import "UIImageView+WebCache.h"
#import "QZNavBarTitleLabel.h"

@interface TSShareHeaderView ()
@property (nonatomic, weak) QZNavBarTitleLabel *nameLabel;
@property (nonatomic, strong) TSManagerPlayerModel *scoringPlayerModel;
@property (nonatomic, weak) UIImageView *playerHeader;
@end

@implementation TSShareHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    return self;
}

- (void)p_setupSubViews {
    // add bg imageView
    UIImage *image = [UIImage imageNamed:@"share_header_bg_image"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    
    [self addSubview:bgImageView];
    
    // add header bg image
    UIImage *headerImage = [UIImage imageNamed:@"player_header_bg_image"];
    UIImageView *headerGgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, H(63), W(100), H(130))];
    headerGgImageView.image = headerImage;
    headerGgImageView.centerX = self.width*0.5;
    [self addSubview:headerGgImageView];
    
    // add player header imageView
    CGFloat playerHeaderWH = W(90);
    UIImageView *playerHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playerHeaderWH, playerHeaderWH)];
    playerHeader.centerX = headerGgImageView.width*0.5;
    playerHeader.centerY = headerGgImageView.height*0.5 + H(15);
    playerHeader.layer.borderWidth = W(4);
    playerHeader.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    playerHeader.layer.masksToBounds = YES;
    playerHeader.layer.cornerRadius = playerHeaderWH*0.5;
    [headerGgImageView addSubview:playerHeader];
    self.playerHeader = playerHeader;
    
    // add player name label
    CGFloat nameLabelW = self.width;
    CGFloat nameLabelH = H(16);
    CGFloat nameLabelX = 0;
    CGFloat nameLabelY = CGRectGetMaxY(headerGgImageView.frame) + H(12);
    QZNavBarTitleLabel *nameLabel = [[QZNavBarTitleLabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH) txtColor:[UIColor whiteColor] borderColor:TSHEXCOLOR(0xff4769) borderWidth:0.5];
    nameLabel.text = @" ";
    nameLabel.font = [UIFont systemFontOfSize:W(17.0)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
}

- (void)setHighScorePlayer:(NSString *)highScorePlayer {
    _highScorePlayer = highScorePlayer;
    
    [self.playerHeader sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"player_defaultHead_Image"]];
    if (highScorePlayer.length) {
        self.nameLabel.text = [NSString stringWithFormat:@"本场得分王：%@", highScorePlayer];
    }
}

- (void)setPlayerPhoto:(NSString *)playerPhoto {
    _playerPhoto = playerPhoto;
    
    [self.playerHeader sd_setImageWithURL:[NSURL URLWithString:playerPhoto] placeholderImage:[UIImage imageNamed:@"player_defaultHead_Image"]];
}

- (void)setHostPlayerDataArray:(NSArray *)hostPlayerDataArray {
    _hostPlayerDataArray = hostPlayerDataArray;
    
    self.scoringPlayerModel = hostPlayerDataArray[0];
    __block int scoringPlayerScore = self.scoringPlayerModel.FreeThrowHit.intValue + self.scoringPlayerModel.OnePointsHit.intValue + self.scoringPlayerModel.TwoPointsHit.intValue*2 + self.scoringPlayerModel.ThreePointsHit.intValue*3;
    [hostPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        int scoreTotal = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
        if (scoreTotal > scoringPlayerScore) { // 获取得分最高球员
            self.scoringPlayerModel = playerModel;
            scoringPlayerScore = scoreTotal;
        } else if (scoreTotal == scoringPlayerScore) { // 得分相同时，取playerId大的人
            BOOL result = [self.scoringPlayerModel.playerId compare:playerModel.playerId] == NSOrderedAscending;
            if (result) {
                self.scoringPlayerModel = playerModel;
                scoringPlayerScore = scoreTotal;
            }
        }
        
        DDLog(@"playerModel.playerId.intValue:%d", playerModel.playerId.intValue);
    }];
}

- (void)setGuestPlayerDataArray:(NSArray *)guestPlayerDataArray {
    _guestPlayerDataArray = guestPlayerDataArray;
    
    __block int scoringPlayerScore = self.scoringPlayerModel.FreeThrowHit.intValue + self.scoringPlayerModel.OnePointsHit.intValue + self.scoringPlayerModel.TwoPointsHit.intValue*2 + self.scoringPlayerModel.ThreePointsHit.intValue*3;
    [guestPlayerDataArray enumerateObjectsUsingBlock:^(TSManagerPlayerModel *playerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        int scoreTotal = playerModel.FreeThrowHit.intValue + playerModel.OnePointsHit.intValue + playerModel.TwoPointsHit.intValue*2 + playerModel.ThreePointsHit.intValue*3;
        if (scoreTotal > scoringPlayerScore) { // 获取得分最高球员
            self.scoringPlayerModel = playerModel;
            scoringPlayerScore = scoreTotal;
        } else if (scoreTotal == scoringPlayerScore) { // 得分相同时，取playerId大的人
            BOOL result = [self.scoringPlayerModel.playerId compare:playerModel.playerId] == NSOrderedAscending;
            if (result) {
                self.scoringPlayerModel = playerModel;
                scoringPlayerScore = scoreTotal;
            }
        }
        
        DDLog(@"playerModel.playerId.intValue:%d", playerModel.playerId.intValue);
    }];
    
    [self.playerHeader sd_setImageWithURL:[NSURL URLWithString:self.scoringPlayerModel.photo] placeholderImage:[UIImage imageNamed:@"player_defaultHead_Image"]];
    self.nameLabel.text = [NSString stringWithFormat:@"本场得分王：%@", self.scoringPlayerModel.playerName];
}
@end
