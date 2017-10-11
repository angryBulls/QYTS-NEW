//
//  TSCreateGameModel.h
//  QYTS
//
//  Created by lxd on 2017/8/3.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCreateGameModel : NSObject
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *matchDate;

@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *phone;

// 赛制数组
@property (nonatomic, strong) NSArray *dpBtnArray;
@property (nonatomic, copy) NSString *selectValue;

@property (nonatomic, copy) NSString *customName; // 用户自定义“赛事名称”
@end
