//
//  TSAbstainedView.h
//  QYTS
//
//  Created by lxd on 2017/9/7.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AbstentionSuccessBlock)();

@interface TSAbstainedView : UIView
- (instancetype)initWithFrame:(CGRect)frame abstentionSuccessBlock:(AbstentionSuccessBlock)abstentionSuccessBlock;
@end
