//
//  AccountViewModel.h
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface AccountViewModel : ViewModelClass
- (instancetype)initWithUserInfoDict:(NSMutableDictionary *)userInfoDict;

- (void)getCurrentVersion;
- (void)loginBCBC;
- (void)loginCBO;
- (void)loginNormal;
- (void)loginNormalByVCode;
- (void)loginOut;
- (void)fetchAuthCode;
- (void)registerUser;
@end
