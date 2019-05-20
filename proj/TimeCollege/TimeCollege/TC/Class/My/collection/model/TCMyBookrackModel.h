//
//  TCMyBookrackModel.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TCDownloadProgress)(CGFloat progress);
typedef void(^TCDownloadSuccess)(NSString *path);
typedef void(^TCDownloadFailure)(NSError *error);

typedef NS_ENUM(NSUInteger, TCMyBookDownloadState) {
    /// 未下载
    TCMyBookDownloadStateNot,
    /// 下载中
    TCMyBookDownloadStateIng,
    /// 暂停
    TCMyBookDownloadStatePause,
    /// 已下载
    TCMyBookDownloadStateEd,
};

typedef NS_ENUM(NSUInteger, TCMyBookType) {
    /// epub
    TCMyBookTypeEpub,
    /// pdf
    TCMyBookTypePDF,
};

@interface TCMyBookrackModel : LGBaseModel

@property (assign,nonatomic) TCMyBookType bookType;
/** 下载状态: 3 已下载 */
@property (assign,nonatomic) TCMyBookDownloadState ds;
/** 编辑状态下是否选中 1:选中 */
@property (assign,nonatomic) BOOL editSelect;
/** 下载状态 图标 */
@property (strong,nonatomic) UIImage *downloadIcon;
/** 下载链接 */
@property (strong,nonatomic) NSString *downloadURL;
/** 资源本地路径 */
@property (strong,nonatomic) NSString *localFilePath;
/** 删除本地资源 */
- (void)rm_localFile;
/** 取消下载 */
- (void)cancelDownload;

/** 改变下载状态 */
- (void)changeDownloadStateWithCurrentState:(TCMyBookDownloadState)currentState progress:(TCDownloadProgress)progress failure:(TCDownloadFailure)failure;

@end

NS_ASSUME_NONNULL_END
