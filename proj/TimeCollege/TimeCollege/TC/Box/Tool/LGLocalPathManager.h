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

/** ~library/fileName */
- (NSString *)fileOfLibrary:(NSString *)fileName;
- (NSString *)libraryDirectory;

@end

NS_ASSUME_NONNULL_END
