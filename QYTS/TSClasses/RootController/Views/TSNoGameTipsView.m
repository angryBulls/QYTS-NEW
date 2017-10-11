//
//  TSNoGameTipsView.m
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSNoGameTipsView.h"

@interface TSNoGameTipsView ()
@property (nonatomic, weak) UILabel *titleLab;
@end

@implementation TSNoGameTipsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self p_addSubViews];
    }
    return self;
}

- (void)p_addSubViews {
    CGFloat imageViewW = W(132.5);
    CGFloat imageViewH = H(108);
    CGFloat imageViewX = (self.width - imageViewW)*0.5;
    UIImage *image = [UIImage imageNamed:@"no_game_tips_image"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, imageViewW, imageViewH)];
    imageView.image = image;
    [self addSubview:imageView];
    
    // add tips content label
    CGFloat titleLabH = H(16);
    CGFloat titleLabY = self.height - titleLabH;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabY, self.width, titleLabH)];
    titleLab.text = @"";
    titleLab.font = [UIFont systemFontOfSize:W(13.0)];
    titleLab.textColor = TSHEXCOLOR(0x618ABC);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    self.titleLab = titleLab;
}

- (void)setDataType:(DataType)dataType {
    _dataType = dataType;
    
    if (DataTypeGame == dataType) {
        self.titleLab.text = @"您的比赛记录为空，快去创建比赛吧！";
    } else if (DataTypeCheck == dataType) {
        self.titleLab.text = @"您的未检录数据为空，快去创建比赛吧！";
    }
}
@end
