//
//  LGLocalPathManager.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGLocalPathManager : NSObject

/** 返回: ~library/fileName */
- (NSString *)fileOfLibrary:(NSString *)fileName;
/** 返回 library */
- (NSString *)libraryDirectory;

@end

NS_ASSUME_NONNULL_END
