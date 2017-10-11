//
//  TSPlayerModel.h
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSPlayerModel : NSObject
@property (nonatomic, copy) NSString *ID; // 球员id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *playerNumber; // 注册号码
@property (nonatomic, copy) NSString *userId;

// loacal new add property
@property (nonatomic, copy) NSString *gameNum; // 本场号码
@property (nonatomic, copy) NSString *isStartPlayer; // 是否首发球员

@property (nonatomic, strong) NSString *allSelectedNumb; // 所有球友的已选号码
@property (nonatomic, copy) NSString *isRepeatNumb; // 是否有重复号码

@property (nonatomic, copy) NSString *playingStatus; // 上场状态（0:场下   1:场上）
@property (nonatomic, copy) NSString *playingTimes; // 球员上场时间
@end
