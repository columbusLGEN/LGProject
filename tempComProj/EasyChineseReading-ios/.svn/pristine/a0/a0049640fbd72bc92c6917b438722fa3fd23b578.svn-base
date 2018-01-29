//
//  ECRBookInfoModel.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "BookModel.h"
@class ECRBiCommentModel,ECRClassfyBookModel,ECRRecoBook,ECRScoreUserModel,ECRDownloadStateModel;
//typedef NS_ENUM(NSUInteger, ECRBookInfoType) {
//    ECRBookInfoTypePublish,// 出版信息
//    ECRBookInfoTypeIntro,// 简介
//    ECRBookInfoTypeCatalog,// 目录
//    ECRBookInfoTypeReco// 推荐
//};

@interface ECRBookInfoModel : BookModel
@property (strong,nonatomic) NSArray<ECRClassfyBookModel *> *classifyBook;// ??
@property (strong,nonatomic) NSArray<ECRRecoBook *> *recommend;// 推荐书籍
@property (strong,nonatomic) NSArray<ECRScoreUserModel *> *scores;// 评价列表

@property (assign,nonatomic) BOOL nrFold;/// 内容简介 0 = 默认,1 = 展开
@property (assign,nonatomic) BOOL caFold;/// 目录

@property (strong,nonatomic) ECRDownloadStateModel *dsModel;//

@end
