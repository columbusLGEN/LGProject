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

NSString * const LGSocialShareParamKeyWebPageUrl = @"LGSocialShareParamKeyWebPageUrl";
NSString * const LGSocialShareParamKeyTitle = @"LGSocialShareParamKeyTitle";
NSString * const LGSocialShareParamKeyDesc  = @"LGSocialShareParamKeyDesc";
NSString * const LGSocialShareParamKeyThumbUrl   = @"LGSocialShareParamKeyThumbUrl";
NSString * const LGSocialShareParamKeyVc = @"LGSocialShareParamKeyVc";

@implementation LGSocialShareManager

- (void)showShareMenuWithParam:(NSDictionary *)param shareType:(DJShareType)shareType{
    /// MARK: 配置UI面板选项
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType param:param shareType:shareType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType param:(NSDictionary *)param shareType:(DJShareType)shareType{
    
    NSString *webPageUrl = param[LGSocialShareParamKeyWebPageUrl];
    NSString *thumbUrl = param[LGSocialShareParamKeyThumbUrl];
    NSString *title = param[LGSocialShareParamKeyTitle];
    NSString *desc = param[LGSocialShareParamKeyDesc];
    UIViewController *vc = param[LGSocialShareParamKeyVc];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    /// 设置title, 描述 , 缩略图
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumbUrl];
    
    // 设置网页地址
    shareObject.webpageUrl = webPageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    /// 分享成功，根据 sharetype 增加用户积分
    DJUserAddScoreType type = DJUserAddScoreTypeQAShare;
    switch (shareType) {
        case DJShareTypeLesson:
            break;
        case DJShareTypeQA:
            type = DJUserAddScoreTypeQAShare;
            break;
        case DJShareTypeNews:
            /// TODO: 接口没有 要闻分享？？ 同时，实际需求中并没有 微党课分享
            //                    type = DJUserAddScoreTypeLessonShare;
            break;
            
    }
    [DJUserNetworkManager.sharedInstance frontIntegralGrade_addWithIntegralid:type completenum:1 success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
    
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
