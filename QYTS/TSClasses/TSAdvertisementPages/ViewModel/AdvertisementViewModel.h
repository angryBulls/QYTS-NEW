//
//  AdvertisementViewModel.h
//  QYTS
//
//  Created by lxd on 2017/9/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface AdvertisementViewModel : ViewModelClass
- (instancetype)initWithPramasDict:(NSMutableDictionary *)paramasDict;

- (void)getGuide;
@end
