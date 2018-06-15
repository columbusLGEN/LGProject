//
//  LGDownloadManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

/// epub, hypermedia, pdf

#import "LGDownloadManager.h"
#import "LGLocalFileManager.h"
#import "AFNetworking.h"

@interface LGDownloadManager ()

@property (strong,nonatomic) NSFileManager *fileMgr;//

@property (strong,nonatomic) NSURLSessionDownloadTask *downloadTask;//

@property (strong,nonatomic) NSURLSessionDataTask *dataTask;//

@property (copy,nonatomic) void (^rg_progress)(NSProgress * _Nonnull downloadProgress);//

@property (strong,nonatomic) AFURLSessionManager *manager;//
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (copy,nonatomic) NSString *fileName;/// 下载到本地的路径

@end

@implementation LGDownloadManager

// MARK: 取消正在进行的下载操作
- (void)lg_cancelDownloadTask{
    [_dataTask cancel];
    // 删除下载到一半的文件
    [LGLocalFileManager deleteLocalFileWithPath:self.fileName];// 删除本地不完整文件
}

#pragma mark - 下载操作
- (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(LGDownloadManagerProgress)progress success:(LGDownloadManagerAbsuloteSuccess)success failure:(LGDownloadManagerAbsuloteFailure)failure{
    self.fileName = fileName;
    NSURL *url = [NSURL URLWithString:URLString];
    
    // 2.创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    __weak typeof(self) weakSelf = self;
    
    _dataTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            NSLog(@"downloadProgress: %f",downloadProgress.fractionCompleted);
            if (progress) {
                progress(downloadProgress.fractionCompleted,0,0);
            }
        }];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"下载完毕response -- %@",response);
        //            NSLog(@"dataTaskWithRequest");
        //        NSLog(@"error -- %@",error);
        if (error == nil) {
            // MARK: 下载成功
            if (success) {
                success(fileName);
            }
        }else{
            // MARK: 下载失败
            if (failure) {
                [LGLocalFileManager deleteLocalFileWithPath:fileName];// 删除本地不完整文件
                failure(error);
            }
        }
        
        // 清空长度
        weakSelf.currentLength = 0;
        weakSelf.fileLength = 0;
        
        // 关闭fileHandle
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
//        NSLog(@"weakSelf.fileHandle == nil: ");
    }];
    
    [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        //            NSLog(@"NSURLSessionResponseDisposition");
//        NSLog(@"setDataTaskDidReceiveResponseBlock__%@ -- %ld",dataTask,dataTask.state);
//        NSLog(@"setDataTaskDidReceiveResponseBlock__%@ -- %ld",weakSelf.dataTask,weakSelf.dataTask.state);
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        weakSelf.fileLength = response.expectedContentLength + self.currentLength;
        
        //            NSLog(@"File downloaded to: %@",path);
        
        // MARK: 将下载的文件存储到本地
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        // 直接覆盖本地文件，省去删除
        BOOL create = [manager createFileAtPath:fileName contents:nil attributes:nil];
//        NSLog(@"create: %d",create);
        // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
//        if (!create) {
//            BOOL create1 = [manager createFileAtPath:fileName contents:nil attributes:nil];
//            NSLog(@"create_1: %d",create1);
//        }
        
        // 创建文件句柄
        weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
//        NSLog(@"weakSelf.fileHandle: %@",weakSelf.fileHandle);
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
//        NSLog(@"setDataTaskDidReceiveDataBlock: ");
//        NSLog(@"weakSelf.fileHandle: %@",weakSelf.fileHandle);
        if (!(weakSelf.fileHandle == nil)) {
            // 指定数据的写入位置 -- 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            
            // 向沙盒写入数据
            [weakSelf.fileHandle writeData:data];
            
            // 拼接文件总长度
            weakSelf.currentLength += data.length;
            
            // 获取主线程，不然无法正确显示进度。
            NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                if (weakSelf.fileLength == 0) {
                    //                    weakSelf.progressView.progress = 0.0;
                    //                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:00.00%%"];
//                    if (progress) {
//                        progress(0.0,0,0);
//                    }
                } else {
                    //                    weakSelf.progressView.progress =  1.0 * weakSelf.currentLength / weakSelf.fileLength;
                    //                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * weakSelf.currentLength / weakSelf.fileLength];
//                    CGFloat progressNum = 100.0 * weakSelf.currentLength / weakSelf.fileLength;
//                    if (progress) {
//                        progress(progressNum,weakSelf.fileLength,weakSelf.currentLength);
//                    }
                }
                
            }];
        }
        
    }];
    [_dataTask resume];
    
}


- (instancetype)init{
    if (self = [super init]) {
        self.fileMgr = [NSFileManager defaultManager];
    }
    return self;
}


- (NSSet *)acceptTypes{
    if (_acceptTypes == nil) {
        _acceptTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"charset=utf-8",@"application/x-gzip",@"application/epub+zip",@"application/octet-stream",@"application/zip",@"application/pdf",nil];
    }
    return _acceptTypes;
}

- (AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [self commenManager];
    }
    return _manager;
}

+ (AFURLSessionManager *)commenManager{
    return [[self sharedInstance] commenManager];
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

+ (void)lg_cancelDownloadTask{
    [[self sharedInstance] lg_cancelDownloadTask];
}
+ (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(LGDownloadManagerProgress)progress success:(LGDownloadManagerAbsuloteSuccess)success failure:(LGDownloadManagerAbsuloteFailure)failure{
    [[self sharedInstance] downloadWithURLString:URLString fileName:fileName progress:progress success:success failure:failure];
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
@end

