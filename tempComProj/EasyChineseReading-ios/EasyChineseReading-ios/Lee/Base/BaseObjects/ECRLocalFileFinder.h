//
//  ECRLocalFileFinder.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECRBookrackModel;

typedef void(^LocalFileFinderDone)(NSArray<ECRBookrackModel *> *);

@interface ECRLocalFileFinder : NSObject

/** 查找documents下用户导入的书 */
+ (void)findLocalEpubAndPdfInDocuments:(LocalFileFinderDone)lffDone;
+ (instancetype)sharedInstance;
@end
