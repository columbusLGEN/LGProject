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
typedef void(^TCDownloadFailure)(NSError *error);
typedef void(^TCDownloadSuccess)(NSString *path);

typedef NS_ENUM(NSUInteger, TCMyBookDownloadState) {
    TCMyBookDownloadStateNot,/// 未下载
    TCMyBookDownloadStateIng,/// 下载中
    TCMyBookDownloadStatePause,/// 暂停
    TCMyBookDownloadStateEd,/// 已下载
};

@class TCBookDownloadModel;

@interface TCMyBookrackModel : LGBaseModel

@property (strong,nonatomic) TCBookDownloadModel *download;

@end

NS_ASSUME_NONNULL_END
