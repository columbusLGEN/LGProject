//
//  ECRDownloadManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

typedef void(^ECRDownloadManagerAbsuloteSuccess)(NSString *localURL);
typedef void(^ECRDownloadManagerAbsuloteFailure)(NSError *);
typedef void(^ECRDownloadManagerProgress) (CGFloat progress,CGFloat total,CGFloat current);

#import <Foundation/Foundation.h>

@interface ECRDownloadManager : NSObject

/**
 生成临时下载路径

 @param userId 登录用户id
 @param bookId 书籍id
 @param try 试读(NO为正式)
 @param format 书籍格式
 @return 临时下载路径
 */
+ (NSString *)tempLocalURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format;

/**
 判断路径是否存在
 
 @param path 路径
 @return 存在返回YES
 */
+ (BOOL)fileIsExist:(NSString *)path;
- (BOOL)fileIsExist:(NSString *)path;

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
+ (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(ECRDownloadManagerProgress)progress success:(ECRDownloadManagerAbsuloteSuccess)success failure:(ECRDownloadManagerAbsuloteFailure)failure;
- (void)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progress:(ECRDownloadManagerProgress)progress success:(ECRDownloadManagerAbsuloteSuccess)success failure:(ECRDownloadManagerAbsuloteFailure)failure;

/**
 返回超媒体文件压缩包 或者 解压后的路径
 
 @param userId 登录用户id
 @param bookId 书籍id
 @param try 是否试读
 @param isZip 1=压缩包,0=解压缩路径
 @return 目标路径
 */
+ (NSString *)hypermediaURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try isZip:(BOOL)isZip;

/**
 返回本地存储链接

 @param userId 登录用户id
 @param bookId 书籍id
 @param try 试读(NO为正式)
 @param format 书籍格式
 @return 目标路径
 */
+ (NSString *)localURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format;

/** 生成相对路径 */
+ (NSString *)localIdentifyWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format;

/** 初始化本地文件夹目录 */
+ (void)initLocalFilePath;

/** 返回单利对象 */
+ (instancetype)sharedInstance;

/** epub 文件夹路径 */
@property (copy,nonatomic) NSString *epubFile;//
/** epub 文件夹加密路径 */
@property (copy,nonatomic) NSString *epubFile_encode;//
/** pdf 文件夹路径 */
@property (copy,nonatomic) NSString *pdfFile;//
/** 超媒体 zip 路径 */
@property (copy,nonatomic) NSString *hyperZipFile;//
/** 超媒体 解压后目录 路径 */
@property (copy,nonatomic) NSString *hyperUnzipFile;//
/**  临时下载路径 */
@property (copy,nonatomic) NSString *temporaryFile;//

/** http请求下载可接受格式 */
@property (strong,nonatomic) NSSet *acceptTypes;
/** 返回AFURLSessionManager,方便管理 */
+ (AFURLSessionManager *)commenManager;

@end

