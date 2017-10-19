//
//  VoicePlayersView.h
//  QYTS
//
//  Created by lxd on 2017/8/8.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AbstentionSuccessBlock)();

@interface VoicePlayersView : UIView
- (instancetype)initWithFrame:(CGRect)frame abstentionSuccessBlock:(AbstentionSuccessBlock)abstentionSuccessBlock;

- (void)updatePlayersStatus;
@end
