//
//  ECRBookReaderManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *LGCloseReaderNotification = @"closeReaderNotification";
static NSString *LGCloseReaderProgressKey = @"LGCloseReaderProgressKey";

/// 鉴于党建项目 只有epub资源文件，所以本次重构，只考虑epub部分，忽略超媒体和pdf
typedef void(^ECRBookReadFailure)(id info);

@interface LGBookReaderManager : NSObject

/// 根据类型打开资源文件。参数：模型。内部：模型的资源类型，模型的本地资源链接
+ (void)openBookWithLocalUrl:(NSString *)localUrl bookId:(NSString *)bookId vc:(UIViewController *)vc;

+ (instancetype)sharedInstance;

@end
