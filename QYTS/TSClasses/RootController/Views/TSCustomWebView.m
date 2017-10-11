//
//  TSCustomWebView.m
//  QYTS
//
//  Created by lxd on 2017/9/26.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSCustomWebView.h"
#import "LCActionSheet.h"

@interface TSCustomWebView () <UIGestureRecognizerDelegate, LCActionSheetDelegate, NSURLSessionDelegate>
@property (nonatomic, weak) LCActionSheet *actionSheet;
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation TSCustomWebView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_createLongPressGesture];
    }
    return self;
}

- (void)p_createLongPressGesture {
    // 添加长按手势
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self addGestureRecognizer:longPressed];
}

- (void)longPressed:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    DDLog(@"urlToSave is:%@", urlToSave);
    self.imageUrl = urlToSave;
    
    [self p_showActionSheet];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)p_showActionSheet {
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"是否保存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    [actionSheet show];
    self.actionSheet = actionSheet;
}

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self p_saveImageToDiskWithUrl:self.imageUrl];
    }
}

- (void)p_saveImageToDiskWithUrl:(NSString *)imageUrl {
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showInfoWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"保存成功"];
    }
}
@end
