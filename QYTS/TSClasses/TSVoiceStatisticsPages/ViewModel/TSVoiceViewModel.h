//
//  TSVoiceViewModel.h
//  QYTS
//
//  Created by lxd on 2017/7/27.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "ViewModelClass.h"

@interface TSVoiceViewModel : ViewModelClass
@property (nonatomic, strong) NSString *oldStage;

- (instancetype)initWithPramasDict:(NSMutableDictionary *)pramasDict;

- (void)sendCurrentStageData;

- (void)abstentionNormal;
- (void)abstentionBCBC;
- (void)abstentionCBO;
@end
