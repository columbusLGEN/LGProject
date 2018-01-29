//
//  ECRDownloadStateModel.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/10/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRDownloadStateModel.h"
#import "AFNetworking.h"
#import "ECRDownloadManager.h"
#import "ECRBookrackModel.h"
#import "ECRLocalFileManager.h"
#import "ECRBookDownloadStateView.h"
#import "LGCryptor.h"
//img_download_progress
//img_download_done  - 已完成
//img_download_start - 未下载

@interface ECRDownloadStateModel ()

/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
/* AFURLSessionManager */
@property (nonatomic, strong) AFURLSessionManager *manager;

@property (copy,nonatomic) ECRDownloadProgressBlock progressBlock;//
@property (copy,nonatomic) ECRDownloadFailureBlock failureBlock;//
@property (copy,nonatomic) ECRDownloadSuccessBlock successBlock;//

@end

@implementation ECRDownloadStateModel
// TODO: 检查网络状态,如果不是wifi,要提示用户

// 取消当前下载任务
- (void)cancelCurrentDownloadTask{
    [_downloadTask cancel];
    self.dsView.progress = 0;
    
//    NSLog(@"_downloadTask.state -- %ld",_downloadTask.state);
}

// 改变下载状态 - 1103
//- (void)changeDownloadStateWith:(ECRDownloadStateModelState)stateNow success:(ECRDownloadSuccessBlock)success progressBlock:(ECRDownloadProgressBlock)progressBlock failureBlock:(ECRDownloadFailureBlock)failureBlock{
//    self.successBlock = success;
//    [self changeDownloadStateWith:stateNow progressBlock:progressBlock failureBlock:failureBlock];
//}

// 改变下载状态
- (void)changeDownloadStateWith:(ECRDownloadStateModelState)stateNow progressBlock:(ECRDownloadProgressBlock)progressBlock failureBlock:(ECRDownloadFailureBlock)failureBlock{
    self.progressBlock = progressBlock;
    self.failureBlock  = failureBlock;
    /**
     点击时，模型可能有3种状态：
     1. 未下载
     2. 下载中
     3. 暂停
     如果 状态为1   --> to beging
     如果 状态为2   --> to pause
     如果 状态为3   --> to downloading
     */
    if (stateNow == ECRDownloadStateModelStateNormal) {
        self.modelState = ECRDownloadStateModelStateDownloadBegin;
    }
    if (stateNow == ECRDownloadStateModelStateDownloading) {
        self.modelState = ECRDownloadStateModelStateDownloadPause;
    }
    if (stateNow == ECRDownloadStateModelStateDownloadPause) {
        self.modelState = ECRDownloadStateModelStateDownloading;
    }
    
}

- (void)setModelState:(ECRDownloadStateModelState)modelState{
    _modelState = modelState;
    if (modelState == ECRDownloadStateModelStateDownloadBegin) {
        /// 从0开始下载，并切换模型状态为 downloading
        [self beginDownload:self.progressBlock];
    }
    if (modelState == ECRDownloadStateModelStateDownloading || modelState == ECRDownloadStateModelStateDownloadPause) {
        /// 继续/暂停下载
        [self pauseOrGoonDownload];
    }

}
// MARK: 判断本地文件是否存在
- (void)localBookExist{
    BOOL bookExist;
    if (self.brModel.eBookFormat == BookModelBookFormatEPUB) {
        bookExist = [[NSFileManager defaultManager] fileExistsAtPath:self.brModel.localEpubEncodePath];
    }else{
        bookExist = [[NSFileManager defaultManager] fileExistsAtPath:self.bookLocalURL];
    }
    if (bookExist) {
        self.modelState = ECRDownloadStateModelStateDownloaded;
    }else{
        self.modelState = ECRDownloadStateModelStateNormal;
    }
}

/**
 * manager的懒加载
 */
- (AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [ECRDownloadManager commenManager];
    }
    return _manager;
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
        NSURL *url = [NSURL URLWithString:self.brModel.downloadURL];
        
        // 2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof(self) weakSelf = self;
        _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            //            NSLog(@"dataTaskWithRequest");
            if (error != nil) {
                // MARK: 下载失败,删除本地错误文件
                NSLog(@"下载失败_error -- %@",error);
                // TODO: -->临时路径
                [ECRLocalFileManager deleteLocalFileWithPath:self.bookTempLocalURL];
                _modelState = ECRDownloadStateModelStateNormal;
                _downloadTask = nil;
                if (self.failureBlock) {
                    self.failureBlock(error);
                }
            }
            if (error == nil) {
                // MARK: 成功之后执行 拷贝操作
                [ECRLocalFileManager moveFileAtPath:self.bookTempLocalURL toPath:self.bookLocalURL competion:^(BOOL done, NSString *destination) {
//                    NSLog(@"destination -- %@",destination);
                    if (self.brModel.eBookFormat == BookModelBookFormatEPUB) {// 对epub文件进行加密操作
                        [LGCryptor encryptWithOriPath:destination toPath:self.brModel.localEpubEncodePath success:^(NSString *path) {
                            NSLog(@"书架加密成功 -- %@",path);
                            
                        } failure:^(NSError *error) {
                            NSLog(@"加密失败 -- %@",error);
                        }];
                    }
                    
                }];
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
            // TODO: 临时路径
            [manager createFileAtPath:weakSelf.bookTempLocalURL contents:nil attributes:nil];
            
            // 创建文件句柄
            weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:weakSelf.bookTempLocalURL];
            
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
                    if (weakSelf.progressBlock) {
                        weakSelf.progressBlock(0.0);
                    }
                } else {
                    CGFloat progress = 100.0 * weakSelf.currentLength / weakSelf.fileLength;
                    if (weakSelf.progressBlock) {
                        weakSelf.progressBlock(progress);
                    }
                }
                
            }];
        }];
    }
    return _downloadTask;
}
/// 返回下载状态view 显示的图片
- (UIImage *)img{
    switch (self.modelState) {
        case ECRDownloadStateModelStateNormal:{
            return [UIImage imageNamed:@"img_download_start"];
        }
            break;
        case ECRDownloadStateModelStateDownloadBegin:{
            return [UIImage imageNamed:@"img_download_progress"];
        }
            break;
        case ECRDownloadStateModelStateDownloading:{
            return [UIImage imageNamed:@"img_download_progress"];
        }
            break;
        case ECRDownloadStateModelStateDownloadPause:{
            return [UIImage imageNamed:@"img_download_pause"];
        }
            break;
        case ECRDownloadStateModelStateDownloaded:{
            return [UIImage imageNamed:@"img_download_done"];
        }
            break;
        default:
            return [UIImage imageNamed:@"img_download_start"];
            break;
    }
}

- (void)beginDownload:(ECRDownloadProgressBlock)progressBlock{
    // 只要开始下载，状态就要 改为 downloading
    _modelState = ECRDownloadStateModelStateDownloading;
    // 沙盒文件路径
    [self.downloadTask resume];// 正式代码需 打开此行注释
}
/** 暂停/继续下载 */
- (void)pauseOrGoonDownload{
    if (self.modelState == ECRDownloadStateModelStateDownloading) { // [开始下载/继续下载]
        // 沙盒文件路径
        NSString *path = self.bookTempLocalURL;
        
        NSInteger currentLength = [self fileLengthForPath:path];
        if (currentLength > 0) {  // [继续下载]
            self.currentLength = currentLength;
        }
        [self.downloadTask resume];
        
    } else {// 暂停
        [self.downloadTask suspend];
        //        self.downloadTask = nil;
    }
}
/** 获取已下载的文件大小 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

- (NSMutableArray<ECRDownloadStateModel *> *)groupDsModels{
    if (_groupDsModels == nil) {
        _groupDsModels = [NSMutableArray new];
    }
    return _groupDsModels;
}

- (NSString *)bookTempLocalURL{
    return self.brModel.tempLocalURL;
}
- (NSString *)bookLocalURL{
    return self.brModel.localURL;
}

@end
