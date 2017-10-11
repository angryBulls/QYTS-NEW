//
//  PersonalViewModel.h
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface PersonalViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict;

- (void)getSsoUserDetail;
- (void)getUserMatchCount;

- (void)getTeamInfoList;
- (void)getUserHistoryMatchDetail;

- (void)updateSsoUser;

- (void)changePhone;
- (void)changePassword;
- (void)findPassword;

- (void)matchBlankOut;
- (void)shareMatchInfo;
- (void)shareLogSave;
@end
