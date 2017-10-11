//
//  MyGameSegmentView.h
//  QYTS
//
//  Created by lxd on 2017/9/5.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(NSUInteger index);

@interface MyGameSegmentView : UIView
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithReturnBlcok:(ReturnBlock)returnBlock;
@end
