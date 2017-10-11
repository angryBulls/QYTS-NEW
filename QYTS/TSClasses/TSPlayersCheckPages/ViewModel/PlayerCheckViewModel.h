//
//  PlayerCheckViewModel.h
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface PlayerCheckViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)pramasDict;

- (void)getPlaysDataByTeamBCBC;
- (void)getPlaysDataByTeamNormal;
- (void)getPlaysDataByTeamCBO;
@end
