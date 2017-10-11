//
//  TSGameModel.h
//  QYTS
//
//  Created by lxd on 2017/7/25.
//  Copyright © 2017年 longcai. All rights reserved.
//  比赛数据统计模型

#import <Foundation/Foundation.h>

@interface TSGameModel : NSObject
@property (nonatomic, copy) NSString *scoreTotalH; // 主队本场得分
@property (nonatomic, copy) NSString *scoreTotalG; // 客队本场得分

@property (nonatomic, copy) NSString *scoreStageOneH; // 主队第一节得分
@property (nonatomic, copy) NSString *scoreStageTwoH; // 主队第二节得分
@property (nonatomic, copy) NSString *scoreStageThreeH; // 主队第三节得分
@property (nonatomic, copy) NSString *scoreStageFourH; // 主队第四节得分
@property (nonatomic, copy) NSString *scoreOvertime1H; // 主队加时赛1得分
@property (nonatomic, copy) NSString *scoreOvertime2H; // 主队加时赛2得分
@property (nonatomic, copy) NSString *scoreOvertime3H; // 主队加时赛3得分

@property (nonatomic, copy) NSString *scoreStageOneG; // 客队第一节得分
@property (nonatomic, copy) NSString *scoreStageTwoG; // 客队第二节得分
@property (nonatomic, copy) NSString *scoreStageThreeG; // 客队第三节得分
@property (nonatomic, copy) NSString *scoreStageFourG; // 客队第四节得分
@property (nonatomic, copy) NSString *scoreOvertime1G; // 客队加时赛1得分
@property (nonatomic, copy) NSString *scoreOvertime2G; // 客队加时赛2得分
@property (nonatomic, copy) NSString *scoreOvertime3G; // 客队加时赛3得分

@property (nonatomic, copy) NSString *foulsStageOneH; // 主队第一节犯规
@property (nonatomic, copy) NSString *foulsStageTwoH; // 主队第二节犯规
@property (nonatomic, copy) NSString *foulsStageThreeH; // 主队第三节犯规
@property (nonatomic, copy) NSString *foulsStageFourH; // 主队第四节犯规
@property (nonatomic, copy) NSString *foulsOvertime1H; // 主队加时赛1犯规
@property (nonatomic, copy) NSString *foulsOvertime2H; // 主队加时赛2犯规
@property (nonatomic, copy) NSString *foulsOvertime3H; // 主队加时赛3犯规

@property (nonatomic, copy) NSString *foulsStageOneG; // 客队第一节犯规
@property (nonatomic, copy) NSString *foulsStageTwoG; // 客队第二节犯规
@property (nonatomic, copy) NSString *foulsStageThreeG; // 客队第三节犯规
@property (nonatomic, copy) NSString *foulsStageFourG; // 客队第四节犯规
@property (nonatomic, copy) NSString *foulsOvertime1G; // 客队加时赛1犯规
@property (nonatomic, copy) NSString *foulsOvertime2G; // 客队加时赛2犯规
@property (nonatomic, copy) NSString *foulsOvertime3G; // 客队加时赛3犯规

@property (nonatomic, copy) NSString *scoreStageH; // 主队本节得分
@property (nonatomic, copy) NSString *scoreStageG; // 客队本节得分
@property (nonatomic, copy) NSString *foulsStageH; // 主队本节犯规
@property (nonatomic, copy) NSString *foulsStageG; // 客队本节犯规

@property (nonatomic, copy) NSString *timeOutTotalH; // 主队本场暂停
@property (nonatomic, copy) NSString *timeOutTotalG; // 客队本场暂停

@property (nonatomic, copy) NSString *timeOutStageOneH; // 主队第一节暂停
@property (nonatomic, copy) NSString *timeOutStageTwoH; // 主队第二节暂停
@property (nonatomic, copy) NSString *timeOutStageThreeH; // 主队第三节暂停
@property (nonatomic, copy) NSString *timeOutStageFourH; // 主队第四节暂停
@property (nonatomic, copy) NSString *timeOutOvertime1H; // 主队加时赛1暂停
@property (nonatomic, copy) NSString *timeOutOvertime2H; // 主队加时赛2暂停
@property (nonatomic, copy) NSString *timeOutOvertime3H; // 主队加时赛3暂停

@property (nonatomic, copy) NSString *timeOutStageOneG; // 客队第一节暂停
@property (nonatomic, copy) NSString *timeOutStageTwoG; // 客队第二节暂停
@property (nonatomic, copy) NSString *timeOutStageThreeG; // 客队第三节暂停
@property (nonatomic, copy) NSString *timeOutStageFourG; // 客队第四节暂停
@property (nonatomic, copy) NSString *timeOutOvertime1G; // 客队加时赛1暂停
@property (nonatomic, copy) NSString *timeOutOvertime2G; // 客队加时赛2暂停
@property (nonatomic, copy) NSString *timeOutOvertime3G; // 客队加时赛3暂停

@property (nonatomic, copy) NSString *timeOutStageH; // 主队本节暂停
@property (nonatomic, copy) NSString *timeOutStageG; // 客队本节暂停
@end
