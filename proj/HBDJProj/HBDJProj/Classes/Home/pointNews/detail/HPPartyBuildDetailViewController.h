//
//  HPPartyBuildDetailViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 焦点图，要闻列表 的详情控制器

#import "LGBaseViewController.h"
@class EDJHomeImageLoopModel,DJDataBaseModel,LGThreeRightButtonView,DJDataSyncer;

//typedef NS_ENUM(NSUInteger, LGCoreTextViewType) {
//    LGCoreTextViewTypeDefault,
//    LGCoreTextViewTypePoint,/// 焦点图的要闻详情
//};

/** 党建要闻的跳转来源，微党课，或者 党建要闻。微党课：有查看次数，无分享。党建要闻相反 */
typedef NS_ENUM(NSUInteger, DJPointNewsSource) {
    DJPointNewsSourceMicroLesson,
    DJPointNewsSourcePartyBuild,
    DJPointNewsSourceZhuxiNews
};

@interface HPPartyBuildDetailViewController : LGBaseViewController
///** 展示内容的类型，有音频详情，视频详情，图文详情，其中图文详情分为普通 和 焦点图的图文详情 */
//@property (assign,nonatomic) LGCoreTextViewType coreTextViewType;

@property (strong,nonatomic) LGThreeRightButtonView *pbdBottom;

@property (assign,nonatomic) DJDataPraisetype djDataType;
@property (strong,nonatomic) EDJHomeImageLoopModel *imageLoopModel;
@property (strong,nonatomic) DJDataBaseModel *contentModel;
@property (assign,nonatomic) NSInteger seqid;

+ (void)buildVcPushWith:(DJDataBaseModel *)model baseVc:(UIViewController *)baseVc dataSyncer:(DJDataSyncer *)dataSyncer;

/** 跳转来源,微党课或者党建要闻,0党课，1要闻，2主席要闻 */
@property (assign,nonatomic) DJPointNewsSource dj_jumpSource;

/** 从消息列表跳转来的，== YES */
@property (assign,nonatomic) BOOL isMsgTrans;

@property (strong,nonatomic) DJDataSyncer *dataSyncer;

@end
