//
//  ECRDownloadFirstReadSecond.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRDownloadFirstReadSecond : NSObject

/** 删除进度条 */
+ (void)removeDlProgressHUD;

/**
 下载并阅读书籍

 @param vc 控制器
 @param book 书籍模型
 @param success 成功回调
 @param failure 错误回调
 该方法没有成功回调,成功后直接阅读书籍
 */
+ (void)downloadFirstReadSecondWithvc:(UIViewController *)vc book:(BookModel *)book success:(void (^)())success failure:(void(^)(NSError *error))failure;

@end
