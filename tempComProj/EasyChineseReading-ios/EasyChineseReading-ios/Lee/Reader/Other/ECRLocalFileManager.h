//
//  ECRLocalFileManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRLocalFileManager : NSObject

/**
 移动文件
 
 @param oriPath 原路径
 @param toPath 目标路径
 @param completion 结果
 */
+ (void)moveFileAtPath:(NSString *)oriPath toPath:(NSString *)toPath competion:(void(^)(BOOL done,NSString *destination))completion;

/** 清除本地资源文件 */
+ (void)clearLocalFiles;

/**
 计算文件大小

 @param path 文件路径
 @return 文件大小
 */
+ (long long)localFileSizeWithPath:(NSString *)path;

/**
 根据路径删除文件
 @param path 路径
 */
+ (void)deleteLocalFileWithPath:(NSString *)path;

/**
 将bundle 下的资源文件 拷贝到 制定目录,最好是documents/

 @param bundlePath 资源在bundle中的路径
 @param path 要拷贝到的目录
 @param fileName 文件命名
 */
- (void)copyFileInBundleWithBundlePath:(NSString *)bundlePath toPath:(NSString *)path fileName:(NSString *)fileName;


/**
 将path路径下的fileName 解压缩到 toPath 下,名为toFileName

 @param path 压缩文件目录
 @param fileName 解压后的文件名
 @param toPath 解压缩文件目录
 @param toFileName 解压缩文件名称
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)unzipFileWithPath:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *) toPath toFileName:(NSString *)toFileName uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure;
- (void)unzipFileWithPath:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *)toPath toFileName:(NSString *)toFileName uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure;


/** 单利 */
+ (instancetype)sharedLocalFileManager;

@end
