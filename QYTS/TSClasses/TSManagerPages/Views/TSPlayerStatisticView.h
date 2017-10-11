//
//  TSPlayerStatisticView.h
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSManagerPlayerModel;

typedef NS_ENUM(NSUInteger, DataType) {
    DataTypeScore,
    DataTypeOther
};

typedef void (^ChangeDataReturnBlock)(NSIndexPath *indexPath, NSString *dataType);

@interface TSPlayerStatisticView : UIView
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *resultArray;

@property (nonatomic, assign) NSInteger ruleType;
@property (nonatomic, strong) TSManagerPlayerModel *playerModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithFrame:(CGRect)frame dataType:(DataType)dataType changeDataReturnBlock:(ChangeDataReturnBlock)changeDataReturnBlock;
@end
