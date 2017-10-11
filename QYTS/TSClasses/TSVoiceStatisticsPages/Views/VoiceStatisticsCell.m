//
//  VoiceStatisticsCell.m
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "VoiceStatisticsCell.h"

@interface VoiceStatisticsCell ()
@property (nonatomic, weak) UILabel *titleLab;
@end

@implementation VoiceStatisticsCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"VoiceStatisticsCell";
    VoiceStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VoiceStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH - 2*W(10);
        self.height = H(38);
        self.backgroundColor = TSHEXCOLOR(0x2b3f67);
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add result label
    CGFloat titleLabX = W(27);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, 0, self.width - titleLabX, self.height)];
    titleLab.font = [UIFont systemFontOfSize:W(19.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    
    self.titleLab.text = titleName;
}
@end
