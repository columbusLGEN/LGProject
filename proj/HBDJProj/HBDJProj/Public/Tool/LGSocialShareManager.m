//
//  LGSocialShareManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSocialShareManager.h"
#import <UShareUI/UShareUI.h>
#import <UMShare/UMShare.h>

@implementation LGSocialShareManager

+ (void)showShareMenuWithThumbUrl:(NSString *)thumbUrl content:(NSString *)content webpageUrl:(NSString *)webpageUrl vc:(UIViewController *)vc{
    [[LGSocialShareManager sharedInstance] showShareMenuWithThumbUrl:thumbUrl content:content webpageUrl:webpageUrl vc:vc];
    
}
- (void)showShareMenuWithThumbUrl:(NSString *)thumbUrl content:(NSString *)content webpageUrl:(NSString *)webpageUrl vc:(UIViewController *)vc{
    
    /// MARK: UI面板选项
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType thumbUrl:thumbUrl content:content webpageUrl:webpageUrl vc:vc];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType thumbUrl:(NSString *)thumbUrl content:(NSString *)content webpageUrl:(NSString *)webpageUrl vc:(UIViewController *)vc{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    /// TODO:1.图标URL thumbUrl
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    /// TODO:2. content
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    // 设置网页地址
    /// TODO:3.内容地址 webpageUrl
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
@end
