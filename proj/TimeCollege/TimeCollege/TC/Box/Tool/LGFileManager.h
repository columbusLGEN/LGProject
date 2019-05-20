//
//  LGFileManager.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/20.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGFileManager : NSFileManager
/** 删除本地文件 */
+ (void)removeFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
