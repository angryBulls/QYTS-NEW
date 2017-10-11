//
//  TSPlayerSectionView.h
//  QYTS
//
//  Created by lxd on 2017/7/20.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSPlayerSectionView;
@protocol TSPlayerSectionViewDelegate <NSObject>
@optional
- (void)changeBtnClick:(TSPlayerSectionView *)sectionView;
@end

@interface TSPlayerSectionView : UIView
@property (nonatomic, copy) NSString *teamType;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, weak) UIButton *changeBtn;

@property (nonatomic, weak) id<TSPlayerSectionViewDelegate> delegate;
@end
