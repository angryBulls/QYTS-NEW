//
//  TSSpeechRecognizer.h
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSSpeechRecognizerDelegate <NSObject>
@optional
- (void)onResultsString:(NSString *)resultsString insertDBDict:(NSDictionary *)insertDBDict recognizerResult:(BOOL)result;

- (void)backPcmModelDic:(NSDictionary *)dic;

- (void)onVolumeChanged:(int)volume;
- (void)onEndOfSpeech;
@end

@interface TSSpeechRecognizer : NSObject
@property (nonatomic, weak) id<TSSpeechRecognizerDelegate> delegate;

+ (instancetype)defaultInstance;

-(void)refreshFMDB;
- (void)startListening;
- (void)stopListening;
- (void)cancel;
@end
