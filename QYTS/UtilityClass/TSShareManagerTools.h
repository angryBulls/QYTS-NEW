//
//  TSShareManagerTools.h
//  QYTS
//
//  Created by lxd on 2017/8/9.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface TSShareManagerTools : NSObject
@property (nonatomic, copy) NSString *matchInfoId;

- (instancetype)initWithPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController;

- (void)shareWebPage;
@end
