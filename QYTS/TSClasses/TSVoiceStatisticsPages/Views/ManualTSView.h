//
//  ManualTSView.h
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^InsertDBSuccessBlock)();

@interface ManualTSView : UIView
@property (nonatomic, strong) NSDictionary *playerInfoDict;

- (instancetype)initWithFrame:(CGRect)frame insertDBSuccessBlock:(InsertDBSuccessBlock)insertDBSuccessBlock;

- (void)show;
@end
