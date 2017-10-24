//
//  PcmModel.h
//  QYTS
//
//  Created by lxd on 2017/10/23.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface PcmModel : ViewModelClass
@property (nonatomic,assign) BOOL saveIn;
@property (nonatomic,copy) NSString *pcmPath;
@property (nonatomic,assign) BOOL areadlyPlay;
@end
