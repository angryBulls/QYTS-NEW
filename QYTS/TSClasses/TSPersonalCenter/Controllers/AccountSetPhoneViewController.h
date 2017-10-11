//
//  AccountSetPhoneViewController.h
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSBaseViewController.h"

typedef void (^ChangePhoneSuccessBlock)();

@interface AccountSetPhoneViewController : TSBaseViewController
- (instancetype)initWithBlock:(ChangePhoneSuccessBlock)changePhoneSuccessBlock;
@end
