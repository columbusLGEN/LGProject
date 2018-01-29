//
//  ECRHomeMainModel.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseModel.h"
@class ECRClassSortModel,ECRHomeBook,ECRSeriesModel,ECRThematicModel,ECRAdvModel,ECRRankUser;

@interface ECRHomeMainModel : ECRBaseModel
/** 轮播广告 */
@property (strong,nonatomic) NSArray<ECRAdvModel *> *Advertisement;
/** 分类数组 汉语读物,文化读物,互动教材 */
@property (strong,nonatomic) NSMutableArray<ECRClassSortModel *> *SeriesClassif;
/** 重磅推荐 */
@property (strong,nonatomic) NSArray<ECRHomeBook *> *reco;
/** 系列 */
@property (strong,nonatomic) NSArray<ECRSeriesModel *> *Series;
/** 主题 */
@property (strong,nonatomic) NSArray<ECRThematicModel *> *thematic;
/** 阅读达人榜 */
@property (strong,nonatomic) NSArray<ECRRankUser *> *Rank;

@end
