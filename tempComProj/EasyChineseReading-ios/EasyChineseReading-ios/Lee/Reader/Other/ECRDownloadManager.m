//
//  ECRDownloadManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

/// epub, hypermedia, pdf

#import "ECRDownloadManager.h"
#import "ECRLocalFileManager.h"

@interface ECRDownloadManager ()

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

@implementation ECRDownloadManager

+ (BOOL)fileIsExist:(NSString *)path{
    return [[self sharedInstance] fileIsExist:path];
}
- (BOOL)fileIsExist:(NSString *)path{
    return [self.fileMgr fileExistsAtPath:path];
}

// MARK: 取消正在进行的下载操作
+ (void)lg_cancelDownloadTask{
    [[self sharedInstance] lg_cancelDownloadTask];
}
- (void)lg_cancelDownloadTask{
    [_dataTask cancel];
    
    // 删除下载到一半的文件
    [ECRLocalFileManager deleteLocalFileWithPath:self.fileName];// 删除本地不完整文件
}

#pragma mark - 下载操作
+ (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(ECRDownloadManagerProgress)progress success:(ECRDownloadManagerAbsuloteSuccess)success failure:(ECRDownloadManagerAbsuloteFailure)failure{
    [[self sharedInstance] downloadWithURLString:URLString fileName:fileName progress:progress success:success failure:failure];
}

- (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(ECRDownloadManagerProgress)progress success:(ECRDownloadManagerAbsuloteSuccess)success failure:(ECRDownloadManagerAbsuloteFailure)failure{
    self.fileName = fileName;
    NSURL *url = [NSURL URLWithString:URLString];
    
    // 2.创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    __weak typeof(self) weakSelf = self;
    
    _dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"下载完毕response -- %@",response);
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
                [ECRLocalFileManager deleteLocalFileWithPath:fileName];// 删除本地不完整文件
                failure(error);
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
        //            NSLog(@"NSURLSessionResponseDisposition");
//        NSLog(@"%@ -- %ld",dataTask,dataTask.state);
//        NSLog(@"__%@ -- %ld",weakSelf.dataTask,weakSelf.dataTask.state);
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        weakSelf.fileLength = response.expectedContentLength + self.currentLength;
        
        //            NSLog(@"File downloaded to: %@",path);
        
        // MARK: 将下载的文件存储到本地
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        // 直接覆盖本地文件，省去删除
        [manager createFileAtPath:fileName contents:nil attributes:nil];
        
        //                // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
        //            if (![manager fileExistsAtPath:weakSelf.localURL]) {
        //                [manager createFileAtPath:weakSelf.localURL contents:nil attributes:nil];
        //            }
        
        // 创建文件句柄
        weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
    
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
                    if (progress) {
                        progress(0.0,0,0);
                    }
                } else {
                    //                    weakSelf.progressView.progress =  1.0 * weakSelf.currentLength / weakSelf.fileLength;
                    //                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * weakSelf.currentLength / weakSelf.fileLength];
                    CGFloat progressNum = 100.0 * weakSelf.currentLength / weakSelf.fileLength;
                    if (progress) {
                        progress(progressNum,weakSelf.fileLength,weakSelf.currentLength);
                    }
                }
                
            }];
        }
        
    }];
    
    [_dataTask resume];
    
}

+ (NSString *)hypermediaURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try isZip:(BOOL)isZip{
    return [[self sharedInstance] hypermediaURLWithUserId:userId bookId:bookId try:try isZip:isZip];
}
//+ (NSString *)hypermediaURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try{
//    return [[self sharedInstance] hypermediaURLWithUserId:userId bookId:bookId try:try];
//}
- (NSString *)hypermediaURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try isZip:(BOOL)isZip{
    NSString *floderPath;
    if (isZip) {
        floderPath = self.hyperZipFile;
    }else{
        floderPath = self.hyperUnzipFile;
    }
    
    NSString *uidString = [NSString stringWithFormat:@"%ld",userId];
    NSString *bidString = [NSString stringWithFormat:@"%ld",bookId];
    NSString *endStr = stringWithTry(try);
    
    NSString *formatStr = @"hypermedia";
    NSString *hypermediaPath = [NSString stringWithFormat:@"%@/%@_%@_%@_%@",
                               floderPath,
                               uidString,
                               bidString,
                               endStr,
                               formatStr];
    return hypermediaPath;
}

/// 临时路径
+ (NSString *)tempLocalURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    return [[self sharedInstance] tempLocalURLWithUserId:userId bookId:bookId try:try format:format];
}
- (NSString *)tempLocalURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    NSString *floderPath = self.temporaryFile;
    NSString *uidString = [NSString stringWithFormat:@"%ld",userId];
    NSString *bidString = [NSString stringWithFormat:@"%ld",bookId];
    NSString *endStr = stringWithTry(try);
    NSString *formatStr = stringWithFormat(format);
    
    NSString *tempLocalFilePath = [NSString stringWithFormat:@"%@/%@_%@_%@_%@.%@",
                               floderPath,
                               uidString,
                               bidString,
                               endStr,
                               formatStr,
                               formatStr];
    return tempLocalFilePath;
}

+ (NSString *)localURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
//    NSLog(@"trytrytrytry -- %d",try);
    if (format == BookModelBookFormatHYPER) {
        return [self hypermediaURLWithUserId:userId bookId:bookId try:try isZip:YES];
    }else{
        return [[self sharedInstance] localURLWithUserId:userId bookId:bookId try:try format:format];
    }
}
- (NSString *)localURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    NSString *floderPath = [self floderPathWithFormat:format];
    NSString *uidString = [NSString stringWithFormat:@"%ld",userId];
    NSString *bidString = [NSString stringWithFormat:@"%ld",bookId];
    NSString *endStr = stringWithTry(try);
    NSString *formatStr = stringWithFormat(format);
    
    NSString *localFilePath = [NSString stringWithFormat:@"%@/%@_%@_%@_%@.%@",
                               floderPath,
                               uidString,
                               bidString,
                               endStr,
                               formatStr,
                               formatStr];
    return localFilePath;
}
// 生成相对路径
+ (NSString *)localIdentifyWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    return [[self sharedInstance] localIdentifyWithUserId:userId bookId:bookId try:try format:format];
}
- (NSString *)localIdentifyWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    
    NSString *uidString = [NSString stringWithFormat:@"%ld",userId];
    NSString *bidString = [NSString stringWithFormat:@"%ld",bookId];
    NSString *formatStr = stringWithFormat(format);
    NSString *endStr = stringWithTry(try);
    
    NSString *localIdentify = [NSString stringWithFormat:@"%@_%@_%@_%@.%@",
                               uidString,
                               bidString,
                               endStr,
                               formatStr,
                               formatStr];
    return localIdentify;
}

// MARK: epub路径
- (NSString *)epubFile{
    if (_epubFile == nil) {
        _epubFile = [self absulotePathWithOppositePath:@"epubFile"];
    }
    return _epubFile;
}
- (NSString *)epubFile_encode{
    if (_epubFile_encode == nil) {
        _epubFile_encode = [self absulotePathWithOppositePath:@"epubFile_encode"];
    }
    return _epubFile_encode;
}
// MARK: pdf路径
- (NSString *)pdfFile{
    if (_pdfFile == nil) {
        _pdfFile = [self absulotePathWithOppositePath:@"pdfFile"];
    }
    return _pdfFile;
}
// MARK: 超媒体 zip 路径
- (NSString *)hyperZipFile{
    if (_hyperZipFile == nil) {
        _hyperZipFile = [self absulotePathWithOppositePath:@"hyperZipFile"];
    }
    return _hyperZipFile;
}
// MARK: 超媒体文件 解压后的路径
- (NSString *)hyperUnzipFile{
    if (_hyperUnzipFile == nil) {
        _hyperUnzipFile = [self absulotePathWithOppositePath:@"hyperUnzipFile"];
    }
    return _hyperUnzipFile;
}
- (NSString *)temporaryFile{
    if (_temporaryFile == nil) {
        _temporaryFile = [self absulotePathWithOppositePath:@"temporaryFile"];
    }
    return _temporaryFile;
}

// MARK: 初始化
// 初始化文件夹路径
+ (void)initLocalFilePath{
    [[self sharedInstance] initLocalFilePath];
}
- (void)initLocalFilePath{
    /// 初始化epub路径
    [self commenInitPathWithPath:self.epubFile];
    /// 初始化epub 加密文件路径
    [self commenInitPathWithPath:self.epubFile_encode];
    /// 初始化pdf路径
    [self commenInitPathWithPath:self.pdfFile];
    /// 初始化超媒体 压缩包路径
    [self commenInitPathWithPath:self.hyperZipFile];
    /// 初始化超媒体 解压缩路径
    [self commenInitPathWithPath:self.hyperUnzipFile];
    /// 初始化临时下载路径
    [self commenInitPathWithPath:self.temporaryFile];

}
- (instancetype)init{
    if (self = [super init]) {
        self.fileMgr = [NSFileManager defaultManager];
    }
    return self;
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

// MARK: 私有通用方法
- (void)commenInitPathWithPath:(NSString *)path{
    BOOL isExist = [self.fileMgr fileExistsAtPath:path];
    if (isExist) {
    }else{
        NSError *error;
        BOOL createPath = [self.fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (createPath) {
            NSLog(@"创建路径成功 -- %@",path);
        }else{
            NSLog(@"创建路径失败 -- %@",error);
        }
    }
}
- (NSString *)absulotePathWithOppositePath:(NSString *)oppsitePath{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:oppsitePath];
}

- (NSString *)floderPathWithFormat:(NSInteger)format{
    switch (format) {
        case BookModelBookFormatPDF:{
            return self.pdfFile;
        }
            break;
        case BookModelBookFormatEPUB:{
            return self.epubFile;
        }
            break;
        case BookModelBookFormatHYPER:{
            return self.hyperZipFile;
        }
            break;
        default:
            return self.epubFile_encode;
            break;
    }
}

NSString *stringWithTry(BOOL try){
    if (try) {
        return @"test";
    }else{
        return @"offi";/// official
    }
}
NSString *stringWithFormat(NSInteger format){
    switch (format) {
        case BookModelBookFormatPDF:{
            return @"pdf";
        }
            break;
        case BookModelBookFormatEPUB:{
            return @"epub";
        }
            break;
        case BookModelBookFormatHYPER:{
            return @"zip";
        }
            break;
        default:
            return @"epub";
            break;
    }
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


@end

