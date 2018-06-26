//
//  HPPartyBuildDetailViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 焦点图，要闻列表 的详情控制器

#import "LGBaseViewController.h"
@class EDJHomeImageLoopModel,EDJMicroBuildModel;

typedef NS_ENUM(NSUInteger, LGCoreTextViewType) {
    LGCoreTextViewTypeDefault,
    LGCoreTextViewTypePoint,/// 焦点图的要闻详情
};

@interface HPPartyBuildDetailViewController : LGBaseViewController
/** 展示内容的类型，有音频详情，视频详情，图文详情，其中图文详情分为普通 和 焦点图的图文详情 */
@property (assign,nonatomic) LGCoreTextViewType coreTextViewType;

@property (assign,nonatomic) DJDataPraisetype djDataType;
@property (strong,nonatomic) EDJHomeImageLoopModel *imageLoopModel;
@property (strong,nonatomic) EDJMicroBuildModel *contentModel;

+ (void)buildVcPushWith:(id)model baseVc:(UIViewController *)baseVc;

@end
