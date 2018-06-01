//
//  ECRLocalFileManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGLocalFileManager : NSObject

/**
 绝对路径
 
 @param userId 登录用户id
 @param bookId 书籍id
 @param try 试读(NO为正式)
 @param format 书籍格式
 @return 目标路径
 */
+ (NSString *)localURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format;
/** 相对路径 */
+ (NSString *)localIdentifyWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format;

/**
 将bundle 下的资源文件 拷贝到 制定目录,最好是documents/

 @param bundlePath 资源在bundle中的路径
 @param path 要拷贝到的目录
 @param fileName 文件命名
 */
+ (void)copyFileInBundleWithBundlePath:(NSString *)bundlePath toPath:(NSString *)path fileName:(NSString *)fileName;
/**
 解压
 
 @param path 压缩包路径
 @param toPath 目标文件夹
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)unzipFileWithPath:(NSString *)path toPath:(NSString *) toPath uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure;
/**
 移动
 
 @param oriPath 原路径
 @param toPath 目标路径
 @param completion 结果
 */
+ (void)moveFileAtPath:(NSString *)oriPath toPath:(NSString *)toPath competion:(void(^)(BOOL done,NSString *destination))completion;

/**
 删除
 @param path 路径
 */
+ (void)deleteLocalFileWithPath:(NSString *)path;

/**
 判断路径是否存在
 
 @param path 路径
 @return 存在返回YES
 */
+ (BOOL)fileIsExist:(NSString *)path;

/** 初始化本地文件夹目录 */
+ (void)initLocalFilePath;

/** 清除所有本地资源文件 */
+ (void)clearLocalFiles;

/**
 计算文件大小
 
 @param path 文件路径
 @return 文件大小
 */
+ (long long)localFileSizeWithPath:(NSString *)path;

/** 单利 */
+ (instancetype)sharedLocalFileManager;

/** 保存所有的下载文件 的 路径 */
@property (strong,nonatomic) NSString *filePath;//

@end
