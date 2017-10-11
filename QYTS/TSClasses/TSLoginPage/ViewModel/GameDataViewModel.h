//
//  GameDataViewModel.h
//  QYTS
//
//  Created by lxd on 2017/8/23.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface GameDataViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict;
- (void)getUserHistoryMatchList;
- (void)getMatchAndTeamInfoNormal;
@end
