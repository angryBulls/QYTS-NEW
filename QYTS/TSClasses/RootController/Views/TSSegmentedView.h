//
//  TSSegmentedView.h
//  QYTS
//
//  Created by lxd on 2017/7/19.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectStyle) {
    SelectStyleNone,
    SelectStyleBorderColor
};

typedef void (^ReturnBlock)(NSUInteger index);

typedef NS_ENUM(NSInteger, DefaultSelect) {
    DefaultSelectSection,
    DefaultSelectFull
};

@interface TSSegmentedView : UIView
@property (nonatomic, assign) DefaultSelect defaultSelect;

- (instancetype)initWithSelectStyle:(SelectStyle)selectStyle defaultSelect:(DefaultSelect)defaultSelect returnBlcok:(ReturnBlock)returnBlock;
@end
