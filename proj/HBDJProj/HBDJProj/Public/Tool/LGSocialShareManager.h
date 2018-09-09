//
//  LGSocialShareManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LGSocialShareParamKeyWebPageUrl;
extern NSString * const LGSocialShareParamKeyTitle;
extern NSString * const LGSocialShareParamKeyDesc;
extern NSString * const LGSocialShareParamKeyThumbUrl;
extern NSString * const LGSocialShareParamKeyVc;

typedef NS_ENUM(NSUInteger, DJShareType) {
    /** 微党课 */
    DJShareTypeLesson,
    /** 学习问答 */
    DJShareTypeQA,
    /** 要闻 */
    DJShareTypeNews
};

@interface LGSocialShareManager : NSObject


/**
 分享

 @param param 参数字典
 
 LGSocialShareParamKeyWebPageUrl
 LGSocialShareParamKeyThumbUrl
 LGSocialShareParamKeyTitle
 LGSocialShareParamKeyDesc
 LGSocialShareParamKeyVc
 
 */
- (void)showShareMenuWithParam:(NSDictionary *)param shareType:(DJShareType)shareType;

@end
