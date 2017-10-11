//
//  CreateGameTextfieldView.h
//  QYTS
//
//  Created by lxd on 2017/8/10.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSCreateGameModel;

@protocol CreateGameTextfieldViewDelegate <NSObject>
@optional
- (void)gameNameTextfieldBeginEditing;
- (void)gameNameTextfieldEndEdited;
@end

@interface CreateGameTextfieldView : UIView
@property (nonatomic, strong) TSCreateGameModel *createGameModel;
@property (nonatomic, weak) id<CreateGameTextfieldViewDelegate> delegate;
@end
