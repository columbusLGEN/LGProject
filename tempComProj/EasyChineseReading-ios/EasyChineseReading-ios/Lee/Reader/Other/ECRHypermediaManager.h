//
//  ECRHypermediaManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器1
@class ReaderViewController;

#else
// MARK: 真机1
@class DBPlayer,ReaderViewController;

#endif

@interface ECRHypermediaManager : NSObject

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器1

#else
// MARK: 真机1
/**
 打开超媒体文件
 
 @param hyperURL 文件路径
 @param vc 控制器
 */
+ (void)openHypermidiaWithURL:(NSString *)hyperURL vc:(UIViewController *)vc book:(BookModel *)book;

/** 超媒体阅读器 */
@property (strong,nonatomic) DBPlayer *dbPlayer;

#endif

/**
 返回pdf 阅读器

 @param URLString 本地pdf路径
 @param book 书籍模型
 @return pdf 阅读器
 */
+ (ReaderViewController *)openPDFWithURL:(NSString *)URLString book:(BookModel *)book;

// MARK: 上传阅读进度
+ (void)uploadReadProgressWithBookId:(NSInteger)bookId progress:(NSNumber *)progress readTime:(NSString *)readTime totalWorld:(NSNumber *)totalWorld;

/** 创建超媒体记录进度文件 */
+ (void)lg_initLocalFile;

@end
