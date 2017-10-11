//
//  TSDBManager+RecognizerResultJudge.h
//  QYTS
//
//  Created by lxd on 2017/9/22.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSDBManager.h"

@interface TSDBManager (RecognizerResultJudge)
- (BOOL)recognizerSuccessWithDict:(NSMutableDictionary *)insertDBDict;
- (NSString *)appendResultStringWithDict:(NSDictionary *)insertDBDict;
@end
