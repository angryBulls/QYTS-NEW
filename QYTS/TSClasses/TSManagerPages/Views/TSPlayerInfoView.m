//
//  TSPlayerInfoView.m
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSPlayerInfoView.h"
#import "TSManagerPlayerModel.h"
#import "UIImageView+WebCache.h"

@interface TSPlayerInfoView ()
@property (nonatomic, weak) UIImageView *headImageView;
@property (nonatomic, weak) UILabel *numbNameLab;
@end

@implementation TSPlayerInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add player head image
    CGFloat headImageViewW = W(50);
    CGFloat headImageViewH = W(55);
    CGFloat headImageViewY = H(10);
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headImageViewY, headImageViewW, headImageViewH)];
    headImageView.centerX = self.width*0.5;
    headImageView.backgroundColor = TSHEXCOLOR(0x1b2a47);
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    
    // add number and player name label
    CGFloat numbNameLabW = W(59);
    CGFloat numbNameLabH = H(20);
    CGFloat numbNameLabY = self.height - numbNameLabH - H(3.5);
    UILabel *numbNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, numbNameLabY, numbNameLabW, numbNameLabH)];
    numbNameLab.centerX = self.width*0.5;
    numbNameLab.font = [UIFont boldSystemFontOfSize:W(11.0)];
    numbNameLab.layer.borderWidth = 0.5;
    numbNameLab.layer.borderColor = TSHEXCOLOR(0xffffff).CGColor;
    numbNameLab.textColor = TSHEXCOLOR(0xfffefe);
    numbNameLab.text = @"  ";
    numbNameLab.layer.masksToBounds = YES;
    numbNameLab.layer.cornerRadius = W(5);
    numbNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numbNameLab];
    self.numbNameLab = numbNameLab;
}

#pragma mark - update views with player model
- (void)setPlayerModel:(TSManagerPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    self.numbNameLab.text = [NSString stringWithFormat:@"%@ %@", playerModel.playerNumber, playerModel.playerName];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:playerModel.photo] placeholderImage:[UIImage imageNamed:@"player_defaultHead_Image"]];
}
@end
