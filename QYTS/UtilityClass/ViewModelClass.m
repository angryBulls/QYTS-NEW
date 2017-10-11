//
//  ViewModelClass.m
//  qiuyouquan
//
//  Created by MacBook on 16/12/7.
//  Copyright © 2016年 QYQ-Hawk. All rights reserved.
//

#import "ViewModelClass.h"

@implementation ViewModelClass
#pragma 接收传过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}
@end
