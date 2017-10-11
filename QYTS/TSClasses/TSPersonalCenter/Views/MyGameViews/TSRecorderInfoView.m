//
//  TSRecorderInfoView.m
//  QYTS
//
//  Created by lxd on 2017/9/13.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSRecorderInfoView.h"

@interface TSRecorderInfoView ()
@property (nonatomic, strong) NSMutableArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *contentLabelArray;
@end

@implementation TSRecorderInfoView
- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (NSMutableArray *)contentLabelArray {
    if (!_contentLabelArray) {
        _contentLabelArray = [NSMutableArray array];
    }
    return _contentLabelArray;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    NSInteger MaxRow = titleArray.count;
    CGFloat labelX = 0;
    CGFloat labelW = self.width*0.5;
    CGFloat labelH = self.height / MaxRow;
    for (int i = 0; i < MaxRow; i ++) {
        CGFloat labelY = i*labelH;
        // add title label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        titleLabel.font = [UIFont systemFontOfSize:W(14.0)];
        titleLabel.textColor = TSHEXCOLOR(0xffffff);
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = @"主教练：";
        [self addSubview:titleLabel];
        
        [self.titleLabelArray addObject:titleLabel];
        
        // add content label
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.width, labelY, labelW, labelH)];
        contentLabel.font = [UIFont systemFontOfSize:W(14.0)];
        contentLabel.textColor = TSHEXCOLOR(0xffffff);
        contentLabel.text = @"未填";
        [self addSubview:contentLabel];
        
        [self.contentLabelArray addObject:contentLabel];
    }
    
    [self.titleLabelArray enumerateObjectsUsingBlock:^(UILabel *subLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        subLabel.text = titleArray[idx];
    }];
}

- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
    
    [self.contentLabelArray enumerateObjectsUsingBlock:^(UILabel *subLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([contentArray[idx] length]) {
            subLabel.text = contentArray[idx];
        }
    }];
}
@end
