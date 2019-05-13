//
//  LGLocalPathManager.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/13.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGLocalPathManager.h"

@interface LGLocalPathManager ()
@property (strong,nonatomic) NSFileManager *fileMgr;

@end

@implementation LGLocalPathManager

- (NSString *)fileOfLibrary:(NSString *)fileName{
    NSString *filePath = [self.libraryDirectory stringByAppendingPathComponent:fileName];
    [self fileInitWithPath:filePath];
    return filePath;
}

- (NSString *)libraryDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)fileInitWithPath:(NSString *)path{
    BOOL isExist = [self.fileMgr fileExistsAtPath:path];
    if (isExist) {
    }else{
        NSError *error;
        BOOL createPath = [self.fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        [self.fileMgr fileSystemRepresentationWithPath:path];
        if (createPath) {
            NSLog(@"创建路径成功 -- %@",path);
        }else{
            NSLog(@"创建路径失败 -- %@",error);
        }
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.fileMgr = NSFileManager.defaultManager;
    }
    return self;
}

@end
