//
//  ECRLeHeaders.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#ifndef ECRLeHeaders_h
#define ECRLeHeaders_h

#import "ECRMultiObject.h"
#import "LGPChangeLanguage.h"
#import "UIViewController+ECRExtension.h"

#define LGPlaceHolderImg [UIImage imageNamed:@"img_book_placeholder"]
#define LGPAvatarPlaceHolder [UIImage imageNamed:@"img_avatar_placeholder"]
#define LGPAdvertisePlaceHolder [UIImage imageNamed:@"icon_home_ad_placeholder"]

/** 刷新书架的通知 */
static NSString * const kNotificationBookrackLoadNewData = @"kNotificationBookrackLoadNewData";

/**
 书架当前页面
 - ECRBookrackCurrentPlaceAll: 全部图书
 - ECRBookrackCurrentPlaceAlreadyBuy: 已购买
 */
typedef NS_ENUM(NSUInteger, ECRBookrackCurrentPlace) {
    ECRBookrackCurrentPlaceAll = 1,
    ECRBookrackCurrentPlaceAlreadyBuy,
};

#import "LGSkinSwitchManager.h"

#endif /* ECRLeHeaders_h */
