//
//  CBOViewModel.h
//  QYTS
//
//  Created by lxd on 2017/9/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface CBOViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict;

- (void)cboFindMatchAndTeamInfo;
@end
