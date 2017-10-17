//
//  TS_URL_Header.h
//  QYTS
//
//  Created by lxd on 2017/7/6.
//  Copyright © 2017年 longcai. All rights reserved.
//

#ifndef TS_URL_Header_h
#define TS_URL_Header_h

static NSString * const My_UMeng_Appkey = @"598a7966c89576489d000cb8";
static NSString * const MicrophoneURLStr = @"App-Prefs:root=Privacy&path=MICROPHONE";

// 讯飞
static NSString * const IFLY_APPID_VALUE = @"599f8c84";

// 微信支付appId
static NSString * const WXAppId_Pay = @"wx3ce22732707ec63d";
// 微信支付商户号
static NSString * const WXPartnerId_Pay = @"1487563712";

// contact way
static NSString * const ContactUSContent = @"赛事组织及赛事技术统计合作请致电：15201513972\n\n客服电话：400-631-3677";

// database set
static NSString * const TSDBName = @"TSDB.db";
static NSString * const PlayerTable = @"player_table"; // 球员技术统计数据表
static NSString * const GameTable = @"game_table"; // 比赛数据表（包括：单节得分、犯规、暂停等）
static NSString * const PlayerIdTable = @"playerId_table"; // 用于管理语音统计结果记录到哪个球员身上
static NSString * const TSCheckTable = @"ts_check_table"; // 检录表（包括赛前检录、主队球员和客队球员信息

static NSString * const GameCheckID = @"game_check_id"; // 赛前检录数据id
static NSString * const TeamCheckID_H = @"team_check_id_h"; // 主队球员检录数据id
static NSString * const TeamCheckID_G = @"team_check_id_g"; // 客队球员检录数据id

static NSString * const GameIsFinished = @"isFinish";
static NSString * const GameIsSubmitAll = @"isSubmit";

// 用于查询比赛相关的所有数据（包括：全队犯规、暂停等）
static NSString * const GameId = @"gameId";

static NSString * const PlayerId = @"playerId";

static NSString * const GameStatus = @"gameStatus"; // 比赛是否结束
static NSString * const CurrentStage = @"currentStage";
static NSString * const CurrentStageDataSubmitted = @"currentStageDataSubmitted";
static NSString * const GameQuaretArr = @"gameQuaretArr";


static NSString * const BnfTeameType = @"<teamName>";
static NSString * const BnfTenNumberType = @"<tenNumber>";
static NSString * const BnfBitsNumberType = @"<bitsNumber>";
static NSString * const BnfBehaviorType = @"<behavior>";
static NSString * const BnfResultType = @"<result>";

static NSString * const NumbResultStr = @"NumbResultStr";

static NSString * const BehaviorNumb = @"behaviorNumb"; // 用于标记行为

// 各个技术统计项目对应的标记号（标记好对应的数据为该项目的统计数量）
static NSString * const Timeout = @"0"; // 暂停
static NSString * const FreeThrow = @"behaviorNumb1"; // 罚篮
static NSString * const OnePoints = @"behaviorNumb31"; // 一分
static NSString * const TwoPoints = @"behaviorNumb2"; // 两分
static NSString * const ThreePoints = @"behaviorNumb3"; // 三分
static NSString * const OffensiveRebound = @"behaviorNumb4"; // 进攻篮板
static NSString * const DefensiveRebound = @"behaviorNumb5"; // 防守篮板
static NSString * const Steals = @"behaviorNumb6"; // 抢断
static NSString * const Turnover = @"behaviorNumb7"; // 失误
static NSString * const BlockShots = @"behaviorNumb8"; // 盖帽
static NSString * const Assists = @"behaviorNumb9"; // 助攻
static NSString * const Fouls = @"behaviorNumb10"; // 犯规

#define PlayerStatisticsArray @[Timeout, FreeThrow, OnePoints, TwoPoints, ThreePoints, OffensiveRebound, DefensiveRebound, Steals, Turnover, BlockShots, Assists, Fouls]

static NSString * const FreeThrowHit = @"FreeThrowHit"; // 罚篮命中数
static NSString * const OnePointsHit = @"OnePointsHit"; // 一分命中数
static NSString * const TwoPointsHit = @"TwoPointsHit"; // 2分命中数
static NSString * const ThreePointsHit = @"ThreePointsHit"; // 3分命中数

// 第一节、第二节、第三节、第四节标记字符串
static NSString * const StageOne = @"StageOne";
static NSString * const StageTwo = @"StageTwo";
static NSString * const StageThree = @"StageThree";
static NSString * const StageFour = @"StageFour";
static NSString * const OverTime1 = @"OverTime1";
static NSString * const OverTime2 = @"OverTime2";
static NSString * const OverTime3 = @"OverTime3";

#define StageFourArray @[StageOne, StageTwo, StageThree, StageFour]
#define StageAllArray @[StageOne, StageTwo, StageThree, StageFour, OverTime1, OverTime2, OverTime3]

// 测试数据

// 测试服务器地址
#define TS_SERVER_URL_TEST @"http://180.76.166.143:8094/statistics/request"
#endif /* TS_URL_Header_h */
