//
//  ECRBookReaderManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ECRBookReadFailure)(id info);

@interface ECRBookReaderManager : NSObject


/**
 根据类型打开书

 @param eBookFormat 书籍类型,1pdf,2epub,3超媒体
 @param localURL 本地连接
 @param vc 控制器
 @param bookModel 书籍模型
 @param ymeBook epubKit模型
 */
+ (void)readBookWithType:(BookModelBookFormat)eBookFormat localURL:(NSString *)localURL vc:(UIViewController *)vc bookModel:(BookModel *)bookModel ymeBook:(MyBook *)ymeBook readFailure:(ECRBookReadFailure)readFailure;

+ (instancetype)sharedInstance;

@end
