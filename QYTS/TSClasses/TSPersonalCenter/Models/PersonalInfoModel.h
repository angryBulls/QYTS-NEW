//
//  PersonalInfoModel.h
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *qiuyouno;
@property (nonatomic, copy) NSString *isattestation;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;

// getUserMatchCount 接口获取到的数据
@property (nonatomic, copy) NSString *finishCount;
@property (nonatomic, copy) NSString *newcount;
@end
