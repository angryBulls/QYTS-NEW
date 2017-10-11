//
//  TSGameDataCell.m
//  QYTS
//
//  Created by lxd on 2017/8/23.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSGameDataCell.h"

@interface TSGameDataCell ()
@property (nonatomic, weak) UILabel *titleLab;
@end

@implementation TSGameDataCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TSGameDataCell";
    TSGameDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TSGameDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = SCREEN_WIDTH;
        self.height = H(50);
        self.backgroundColor = TSHEXCOLOR(0x1b2a47);
        [self p_setupSubViews];
    }
    
    return self;
}

- (void)p_setupSubViews {
    // add bg view
    CGFloat bgViewX = W(7.5);
    CGFloat bgViewY = 10;
    CGFloat bgViewW = self.width - 2*bgViewX;
    CGFloat bgViewH = self.height - 20;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = TSHEXCOLOR(0x27395d);
    [self.contentView addSubview:bgView];
    
    // add left label
    CGFloat leftLabX = 0;
    CGFloat leftLabY = 0;
    CGFloat leftLabW = bgView.width;
    CGFloat leftLabH = bgView.height;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, leftLabY, leftLabW, leftLabH)];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [UIFont systemFontOfSize:W(15.0)];
    titleLab.textColor = TSHEXCOLOR(0xffffff);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    self.titleLab = titleLab;
}

- (void)setTestTitle:(NSString *)testTitle {
    _testTitle = testTitle;
    
    self.titleLab.text = testTitle;
}
@end
