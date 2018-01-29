//
//  ECRDownloadStateModel.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/10/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECRDownloadStateModel,ECRBookrackModel,ECRBookDownloadStateView;

typedef void(^ECRDownloadProgressBlock)(CGFloat progress);
typedef void(^ECRDownloadFailureBlock)(NSError *error);
typedef void(^ECRDownloadSuccessBlock)(NSString *path);

typedef NS_ENUM(NSUInteger, ECRDownloadStateModelState) {
    ECRDownloadStateModelStateNormal         ,// 未下载
    ECRDownloadStateModelStateDownloadBegin  ,// 下载开始
    ECRDownloadStateModelStateDownloading    ,// 下载中
    ECRDownloadStateModelStateDownloadPause  ,// 暂停
    ECRDownloadStateModelStateDownloaded     // 下载完成
};


@interface ECRDownloadStateModel : NSObject

- (void)cancelCurrentDownloadTask;

/** 本地书籍是否存在 */
- (void)localBookExist;

// 改变下载状态 - 1103
//- (void)changeDownloadStateWith:(ECRDownloadStateModelState)stateNow success:(ECRDownloadSuccessBlock)success progressBlock:(ECRDownloadProgressBlock)progressBlock failureBlock:(ECRDownloadFailureBlock)failureBlock;

- (void)changeDownloadStateWith:(ECRDownloadStateModelState)stateNow progressBlock:(ECRDownloadProgressBlock)progressBlock failureBlock:(ECRDownloadFailureBlock)failureBlock;


// 未下载
// 开始下载
// 下载中
// 下载完成
/** 下载状态 */
@property (assign,nonatomic) ECRDownloadStateModelState modelState;

/** 下载状态view显示的image */
@property (strong,nonatomic) UIImage *img;
/** 书籍模型 */
@property (strong,nonatomic) ECRBookrackModel *brModel;
/** 下载状态view */
@property (strong,nonatomic) ECRBookDownloadStateView *dsView;
/** 分组下载模型数组 */
@property (strong,nonatomic) NSMutableArray<ECRDownloadStateModel *> *groupDsModels;//

@end
