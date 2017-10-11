//
//  CreateGameViewModel.h
//  QYTS
//
//  Created by lxd on 2017/8/4.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface CreateGameViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict;

- (void)saveAmateurMatchInfo;
@end
