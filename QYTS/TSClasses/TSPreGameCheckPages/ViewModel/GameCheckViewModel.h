//
//  GameCheckViewModel.h
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface GameCheckViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)pramasDict;

// 群众用户获取服务器数据
- (void)getMatchAndTeamInfoNormal;

- (void)getTeamFinalsData;
- (void)getTeamAreaData;
- (void)getTeamProvinceData;

- (void)getBCBCMatchId;
@end
