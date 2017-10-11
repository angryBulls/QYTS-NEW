//
//  UIViewController+Swizzling.m
//  qiuyouquan
//
//  Created by Dosport on 16/9/9.
//  Copyright © 2016年 QYQ-Hawk. All rights reserved.
//  该分类用于打印所有viewController以及其子类控制器的类名

#import <UIKit/UIKit.h>

//修改的方法有返回值就用IMP，无返回值就用VIMP
typedef id   (*_IMP)  (id, SEL, ...);
typedef void (*_VIMP) (id, SEL, ...);

@interface UIViewController (Swizzling)

@end

@implementation UIViewController (Swizzling)
+ (void)load {
    [self useIMPExchangeMthod];
//    [self useSwizzlingExchangeMthod];
}

+ (void)useSwizzlingExchangeMthod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method viewDidLoaded = class_getInstanceMethod(self, @selector(viewDidLoaded));
        
        method_exchangeImplementations(viewDidLoad, viewDidLoaded);
    });
}

- (void)viewDidLoaded {
    [self viewDidLoaded];
//    DDLog(@"current ViewController Name is :\"%@\"",NSStringFromClass([self class]));
}

+ (void)useIMPExchangeMthod {
    //保证交换方法只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        _VIMP viewDidLoad_IMP = (_VIMP)method_getImplementation(viewDidLoad);
        method_setImplementation(viewDidLoad,imp_implementationWithBlock(^(id target,SEL action){
            viewDidLoad_IMP(target,@selector(viewDidLoad));
            DDLog(@"current ViewController Name is : %@",target);
        }));
    });
}
@end
