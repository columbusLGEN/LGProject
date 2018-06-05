//
//  LGDownloadManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^LGDownloadManagerAbsuloteSuccess)(NSString *localURL);
typedef void(^LGDownloadManagerAbsuloteFailure)(NSError *);
typedef void(^LGDownloadManagerProgress) (CGFloat progress,CGFloat total,CGFloat current);

@interface LGDownloadManager : NSObject

/** 取消正在进行的下载操作 */
+ (void)lg_cancelDownloadTask;

/**
 下载文件

 @param URLString 下载链接
 @param fileName 本地文件绝对路径
 @param progress 下载进度
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(LGDownloadManagerProgress)progress success:(LGDownloadManagerAbsuloteSuccess)success failure:(LGDownloadManagerAbsuloteFailure)failure;

/** 返回单利对象 */
+ (instancetype)sharedInstance;

/** http请求下载可接受格式 */
@property (strong,nonatomic) NSSet *acceptTypes;
/** 返回AFURLSessionManager,方便管理 */
//+ (AFURLSessionManager *)commenManager;

@end

