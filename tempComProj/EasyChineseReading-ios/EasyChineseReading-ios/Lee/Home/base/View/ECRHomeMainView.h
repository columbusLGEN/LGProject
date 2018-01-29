//
//  ECRHomeMainView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"
@class
ECRHomeMainModel,
ECRHomeMainView,
SDCycleScrollView,
ECRSeriesAera,
ECRThemeAera,
ECRBookClasses,
ECRBoomRecomment,
ECRReadMonster,
ECRHomeMainModel,
ECRAdvModel;

@protocol ECRHomeMainViewDelegate;

@interface ECRHomeMainView : ECRBaseView
@property (strong,nonatomic) ECRHomeMainModel *model;
/** 主体滚动视图 */
@property (strong,nonatomic) UIScrollView *scrollView;
/** 轮播器 */
@property (strong,nonatomic) SDCycleScrollView *cycleView;
/** 汉语读物,文化读物,互动教材,更多 */
@property (strong,nonatomic) ECRBookClasses *bookClasses;
/** 重磅推荐 */
@property (strong,nonatomic) ECRBoomRecomment *boomRecomment;
/** 系列专区 */
@property (strong,nonatomic) ECRSeriesAera *seriesAera;
/** 主题专区 */
@property (strong,nonatomic) ECRThemeAera *themeAera;
/** 阅读达人 */
@property (strong,nonatomic) ECRReadMonster *readMonster;
@property (weak,nonatomic) id<ECRHomeMainViewDelegate> delegate;

@end

@protocol ECRHomeMainViewDelegate <NSObject>

/** 点击轮播 */
- (void)hmClickAdView:(ECRHomeMainView *)view model:(ECRAdvModel *)model;

@optional


@end
