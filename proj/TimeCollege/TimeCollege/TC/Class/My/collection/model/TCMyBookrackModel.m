//
//  TCMyBookrackModel.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackModel.h"
#import "LGLocalPathManager.h"
#import "LGFileManager.h"

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

/** 删除本地资源 */
- (void)rm_localFile;{
    [LGFileManager removeFile:self.localFilePath];
}
/** 取消下载 */
- (void)cancelDownload;{
    if (_downloadTask.state == NSURLSessionTaskStateRunning) {
        [_downloadTask cancel];
    }
}

/**
 * downloadTask的懒加载
 */
/**
 需要的"参数"
 1.URL --> 模型自带
 2.本地存储路径 --> 模型自己生成
 3.进度回调block
 */
- (NSURLSessionDataTask *)downloadTask {
    if (!_downloadTask) {
        /// 下载链接
        NSURL *url = [NSURL URLWithString:self.downloadURL];
        
        // 2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof(self) weakSelf = self;
        _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            //            NSLog(@"dataTaskWithRequest");
            if (error != nil) {
                // TODO: 下载失败,删除不完整文件
                NSLog(@"下载失败_error -- %@",error);
                
                weakSelf.ds = TCMyBookDownloadStateNot;
                
                weakSelf.downloadTask = nil;
                if (self.failure) {
                    self.failure(error);
                }
            }
            
            // 清空长度
            weakSelf.currentLength = 0;
            weakSelf.fileLength = 0;
            
            // 关闭fileHandle
            [weakSelf.fileHandle closeFile];
            weakSelf.fileHandle = nil;
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
            weakSelf.fileLength = response.expectedContentLength + self.currentLength;
            
            // MARK: 将下载的文件存储到本地
            // 创建一个空的文件到沙盒中
            NSFileManager *manager = [NSFileManager defaultManager];
            // 直接覆盖本地文件，省去删除
            
            // MARK: 保存资源
            [manager createFileAtPath:weakSelf.localFilePath contents:nil attributes:nil];
            
            // 创建文件句柄
            weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:weakSelf.localFilePath];
            
            // 允许处理服务器的响应，才会继续接收服务器返回的数据
            return NSURLSessionResponseAllow;
        }];
        
        [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            // 指定数据的写入位置 -- 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            
            // 向沙盒写入数据
            [weakSelf.fileHandle writeData:data];
            
            // 拼接文件总长度
            weakSelf.currentLength += data.length;
            
            // 获取主线程，不然无法正确显示进度。
            NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                // MARK: 回调下载进度
                if (weakSelf.fileLength == 0) {
                    if (weakSelf.progress) {
                        weakSelf.progress(0.0);
                    }
                } else {
                    CGFloat progress = 100.0 * weakSelf.currentLength / weakSelf.fileLength;
                    if (weakSelf.progress) {
                        weakSelf.progress(progress);
                    }
                }
                
            }];
        }];
        
    }
    return _downloadTask;
}

/** 改变下载状态 */
- (void)changeDownloadStateWithCurrentState:(TCMyBookDownloadState)currentState progress:(TCDownloadProgress)progress failure:(TCDownloadFailure)failure{
    self.progress = progress;
    self.failure  = failure;
    
    if (currentState == TCMyBookDownloadStateNot) {
        /// to 开始
        self.ds = TCMyBookDownloadStateIng;
        
    }else if (currentState == TCMyBookDownloadStateIng) {
        /// to 暂停
        self.ds = TCMyBookDownloadStatePause;
        
    }else if (currentState == TCMyBookDownloadStatePause) {
        /// to 继续
        self.ds = TCMyBookDownloadStateIng;
    }
    
    
}

- (void)setDs:(TCMyBookDownloadState)ds{
    _ds = ds;

    [self download_goon];
}

/** 开始下载 || 暂停 继续 */
- (void)download_goon{
    switch (_ds) {
        case TCMyBookDownloadStateNot:{
        }
            break;
        case TCMyBookDownloadStateIng:{
            [self.downloadTask resume];
        }
            break;
        case TCMyBookDownloadStatePause:{
            [self.downloadTask suspend];
        }
            break;
        case TCMyBookDownloadStateEd:{
        }
            break;
    }
}

- (NSString *)localFilePath{
    if (!_localFilePath) {
        /// ~library/book/epub_userid_bookid.epub
        /// ~library/book/pdf_userid_bookid.pdf
        
        /// TODO: userId, bookId
        NSString *suffix = [self nameSuffix];
        NSString *filePath = [LGLocalPathManager.new fileOfLibrary:@"/SDBook"];
        _localFilePath = [filePath stringByAppendingFormat:@"/%@_%@_%@.%@",
                          suffix,
                          @"userid",
                          @"bookid",
                          suffix];
    }
    return _localFilePath;
}

- (NSString *)downloadURL{
    if (!_downloadURL) {
        /// TODO: 下载链接
        _downloadURL = @"http://dldir1.qq.com/weixin/mac/WeChat_2.3.24.17_1553586184.dmg";
    }
    return _downloadURL;
}

- (NSString *)nameSuffix{
    switch (self.bookType) {
        case TCMyBookTypePDF:
            return @"pdf";
            break;
        case TCMyBookTypeEpub:
            return @"epub";
            break;
    }
}

- (UIImage *)downloadIcon{
    NSString *imgName = @"img_download_start";
    switch (self.ds) {
        case TCMyBookDownloadStateNot:
            break;
        case TCMyBookDownloadStateIng:{
            imgName = @"img_download_progress";
        }
            break;
        case TCMyBookDownloadStatePause:{
            imgName = @"img_download_pause";
        }
            break;
        case TCMyBookDownloadStateEd:{
            imgName = @"img_download_done";
        }
            break;

    }
    return [UIImage imageNamed:imgName];
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [self commenManager];
    }
    return _manager;
}

- (AFURLSessionManager *)commenManager{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 设置请求可接受类型 application/x-gzip
    //        AFJSONResponseSerializer *ser = [AFJSONResponseSerializer serializer];
    //        ser.acceptableContentTypes = self.acceptTypes;
    //        _manager.responseSerializer = ser;
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    return mgr;
}



@end
