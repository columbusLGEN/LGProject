//
//  TCMyBookrackModel.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackModel.h"

@interface TCMyBookrackModel ()
/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;
/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/// -----------------通用下载需要的属性
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
/** 下载管理者 */
@property (nonatomic, strong) AFURLSessionManager *manager;
/** 下载进度回调 */
@property (copy,nonatomic) TCDownloadProgress progress;
/** 下载失败回调 */
@property (copy,nonatomic) TCDownloadFailure failure;
/** 下载成功回调 */
@property (copy,nonatomic) TCDownloadSuccess success;

@end

@implementation TCMyBookrackModel





@end
