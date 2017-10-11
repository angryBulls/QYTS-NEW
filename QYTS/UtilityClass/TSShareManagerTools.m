//
//  TSShareManagerTools.m
//  QYTS
//
//  Created by lxd on 2017/8/9.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "TSShareManagerTools.h"
#import "PersonalViewModel.h"

static NSString *WebPageUrl = @"http://test2.qiuyouzone.com/statis_share/videoshare.html?matchId=%@";
static NSString *ThumbURL = @"";
static NSString *kLinkTitle = @"语音技统";
static NSString *kLinkDescription = @"#战在BCBC#灯光与球场，汗水与信念，今天我是球场王者！";

@interface TSShareManagerTools ()
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic) UMSocialPlatformType platformType;
@end

@implementation TSShareManagerTools
- (instancetype)initWithPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)currentViewController {
    if (self = [super init]) {
        _platformType = platformType;
        _currentViewController = currentViewController;
    }
    return self;
}

- (void)shareWebPage {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UIImage *thumbImage = [UIImage imageNamed:@"ts_logo_icon"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:kLinkDescription descr:kLinkDescription thumImage:thumbImage];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:WebPageUrl, self.matchInfoId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:self.platformType messageObject:messageObject currentViewController:self.currentViewController completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//            message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            message = @"分享失败";
        } else {
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                message = [NSString stringWithFormat:@"分享成功"];
            } else {
//                UMSocialLogInfo(@"response data is %@",data);
                message = [NSString stringWithFormat:@"分享成功"];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享结果" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
            [alert show];
            
            NSMutableDictionary *paramsDict = @{}.mutableCopy;
            paramsDict[@"matchId"] = self.matchInfoId;
            if (UMSocialPlatformType_WechatTimeLine == self.platformType) {
                paramsDict[@"platType"] = @1;
            } else {
                paramsDict[@"platType"] = @2;
            }
            int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
            if (currentUserType == LoginUserTypeNormal) {
                paramsDict[@"type"] = @1;
            } else if (currentUserType == LoginUserTypeBCBC) {
                paramsDict[@"type"] = @2;
            } else if (currentUserType == LoginUserTypeCBO) {
                paramsDict[@"type"] = @3;
            }
            paramsDict[@"url"] = @"http://test2.qiuyouzone.com/statis_share/videoshare.html";
            PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
            [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
                DDLog(@"shareLogSave returnValue is:%@", returnValue);
            } WithErrorBlock:^(id errorCode) {
                [SVProgressHUD showInfoWithStatus:errorCode];
            } WithFailureBlock:^{
            }];
            [personalViewModel shareLogSave];
        }
    }];
}
@end
