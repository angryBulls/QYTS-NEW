//
//  EditPersonalViewController.h
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSBaseTableViewController.h"

@class PersonalInfoModel;

typedef void (^SavePersonalInfoSuccessBlock)();

@interface EditPersonalViewController : TSBaseTableViewController
@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;

- (instancetype)initWithSaveSuccessBlock:(SavePersonalInfoSuccessBlock)savePersonalInfoSuccessBlock;
@end
