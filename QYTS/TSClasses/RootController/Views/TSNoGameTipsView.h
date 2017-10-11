//
//  TSNoGameTipsView.h
//  QYTS
//
//  Created by lxd on 2017/9/12.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DataType) {
    DataTypeGame,
    DataTypeCheck
};

@interface TSNoGameTipsView : UIView
@property (nonatomic) DataType dataType;
@end
