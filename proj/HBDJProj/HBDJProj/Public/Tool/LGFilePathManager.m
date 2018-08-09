//
//  LGFilePathManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGFilePathManager.h"

@interface LGFilePathManager ()


@end

@implementation LGFilePathManager

- (NSString *)dj_testFileNamePathWithTestid:(NSInteger)testid{
    NSString *fileName = [self dj_testRecordFileNameWithTestid:testid];
    return [self createFilePathWithRootPath:LGFilePathRootPathLibrary directryName:@"testRecord" fileName:fileName];
}
- (NSString *)dj_testRecordFileNameWithTestid:(NSInteger)testid{
    return [NSString stringWithFormat:@"userid_%@_testid_%ld_cs.plist",DJUser.sharedInstance.userid,testid];
}

- (NSString *)createFilePathWithRootPath:(LGFilePathRootPath)rootPath directryName:(NSString *)directryName fileName:(NSString *)fileName{
    
    NSFileManager *defultMgr = [NSFileManager defaultManager];
    
    NSString *root = [self rootPath:rootPath];
    
    NSString *fileDirectory = [root stringByAppendingFormat:@"/%@",directryName];
    
    /// 如果 目录不存在，则创建目录
    BOOL isDirectory;
    if (![defultMgr fileExistsAtPath:fileDirectory isDirectory:&isDirectory]) {
        BOOL createDirectory = [defultMgr createDirectoryAtPath:fileDirectory withIntermediateDirectories:nil attributes:nil error:nil];
//        NSLog(@"createDirectory: %d",createDirectory);
    }
    
    NSString *fileAbsuPath = [root stringByAppendingFormat:@"/%@/%@",directryName,fileName];
    
    /// 如果 fileAbsuPath 不存在，则创建
    if (![defultMgr fileExistsAtPath:fileAbsuPath]) {
        BOOL createFile = [defultMgr createFileAtPath:fileAbsuPath contents:nil attributes:nil];
//        NSLog(@"createfile: %d",createFile);
    }
    return fileAbsuPath;
}

- (NSString *)rootPath:(LGFilePathRootPath)root{
    /// 默认存到library
    NSSearchPathDirectory pathDirectory = NSLibraryDirectory;
    switch (root) {
        case LGFilePathRootPathLibrary:
            break;
        case LGFilePathRootPathDocument:
            pathDirectory = NSDocumentDirectory;
            break;
    }
    return [NSSearchPathForDirectoriesInDomains(pathDirectory, NSUserDomainMask, YES) lastObject];
    
}



+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
