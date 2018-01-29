//
//  ECREpubReader.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyBook,YMEpubReaderManager,UIViewController;
@interface ECREpubReader : NSObject


/**
 阅读epub书(单本)

 @param path 本地epub文件路径
 @param vc 父控制器
 @param bookModel 书籍模型
 @param ymeBook 阅读器书籍模型
 */
+ (void)readBookWithPath:(NSString *)path fromController:(UIViewController *)vc bookModel:(BookModel *)bookModel ymeBook:(MyBook *)ymeBook;

+ (instancetype)sharedEpubReader;

@end
