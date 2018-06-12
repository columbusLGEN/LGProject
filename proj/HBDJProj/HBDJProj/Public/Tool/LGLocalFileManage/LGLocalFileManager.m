//
//  ECRLocalFileManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "LGLocalFileManager.h"
//#import "ZipArchive.h"
#import "LGDownloadManager.h"

@interface LGLocalFileManager ()
/** 文件管理者类 */
@property (strong,nonatomic) NSFileManager *fileMgr;
/** 压缩包路径 */
@property (strong,nonatomic) NSString *zipPath;

@end

@implementation LGLocalFileManager

- (NSString *)localURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    return nil;
}
- (NSString *)localIdentifyWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    return nil;
}
// 将bundle 下的资源文件 拷贝到 指定目录,最好是documents/
- (void)copyFileInBundleWithBundlePath:(NSString *)bundlePath toPath:(NSString *)path fileName:(NSString *)fileName{
    // 先判断路径是否存在
    BOOL isDir;
    BOOL isDirExist = [_fileMgr fileExistsAtPath:path isDirectory:&isDir];
    if (isDirExist && isDir) {// 如果存在且是一个路径,在判断fileName文件是否存在
        NSString *absoPath = [NSString stringWithFormat:@"%@/%@",path,fileName];// 绝对路径(包含文件名)
        if ([_fileMgr fileExistsAtPath:absoPath] == YES) {// 如果path路径下fileName已经存在,不执行任何操作
            
        }else{
            // 执行拷贝操作
            [self copyItemAtPath:bundlePath toPath:path ofFileName:fileName];
        }
    }else{
        // 如果不存在, 则创建路径, 并将文件拷贝到path 命名为: fileName
        // 1.创建目录
        BOOL bCreateDir = [_fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (bCreateDir) {
            // 2.拷贝文件
            [self copyItemAtPath:bundlePath toPath:path ofFileName:fileName];
        }else{
            NSLog(@"create path failure");
        }
    }
}
- (void)unzipFileWithPath:(NSString *)path toPath:(NSString *) toPath uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure{
    NSString *fromPath = [NSString stringWithFormat:@"%@",path];
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [_fileMgr fileExistsAtPath:toPath isDirectory:&isDir];
    if (isDir && isDirExist) {// 路径存在
        // 判断解压缩路径是否存在,如果存在,直接返回路径
        BOOL unzipIsDir;
        BOOL unzipExist = [_fileMgr fileExistsAtPath:toPath isDirectory:&unzipIsDir];
        if (unzipIsDir && unzipExist) {
            if (success) {
                success(toPath);
            }
        }else{
            // 直接解压缩致 路径下
            [self unzipItemFromPath:fromPath toPath:toPath uzSuccess:success uzFailure:failure];
        }
    }else{
        // 路径不存在
        // 1.创建路径
        BOOL bCreateDir = [_fileMgr createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (bCreateDir) {
            // 创建路径成功,解压缩文件
            [self unzipItemFromPath:fromPath toPath:toPath uzSuccess:success uzFailure:failure];
            
        }else{
            if (failure) {
                failure(@"创建路径失败");
            }
        }
    }
}
- (void)moveFileAtPath:(NSString *)oriPath toPath:(NSString *)toPath competion:(void(^)(BOOL done,NSString *destination))completion{
    __block NSError *error;
    __block BOOL done;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        done = [self->_fileMgr moveItemAtPath:oriPath toPath:toPath error:&error];
        if (done) {
            if (completion) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completion(done,toPath);
                }];
            }
        }else{
            NSLog(@"拷贝失败");
        }
    });
}
- (void)deleteLocalFileWithPath:(NSString *)path{
    NSError *error;
    NSLog(@"删除文件, -- 路径 %@",path);
    BOOL exist = [_fileMgr fileExistsAtPath:path];
    if (exist) {
        BOOL remove = [_fileMgr removeItemAtPath:path error:&error];
        if (remove) {
            NSLog(@"删除本地文件成功 -- ");
        }else{
            NSLog(@"删除本地文件失败 -- %@",error);
        }
    }else{
        NSLog(@"删除本地文件不存在 -- ");
    }
}
- (void)clearLocalFiles{
    [self.fileMgr removeItemAtPath:[self sandBoxDocumentsPath] error:nil];
    [self initLocalFilePath];
}
- (BOOL)fileIsExist:(NSString *)path{
    return [self.fileMgr fileExistsAtPath:path];
}
- (void)initLocalFilePath{
    [self commenInitPathWithPath:self.filePath];
}
- (long long)localFileSizeWithPath:(NSString *)path{
    BOOL exist = [self fileIsExist:path];
    if (exist) {
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        long long fileSize = [dict fileSize];
        return fileSize;
    }else{
        return 0;
    }
}
- (instancetype)init{
    if (self = [super init]) {
        self.fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

#pragma - 私有方法
- (void)commenInitPathWithPath:(NSString *)path{
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
/** 返回沙盒 Documents 路径 */
- (NSString *)sandBoxDocumentsPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
- (NSString *)absulotePathWithOppositePath:(NSString *)oppsitePath{
    // 如果将文件放在 library 下，使用 NSLibraryDirectory
    // 如果将文件放在 documents 下，使用 NSDocumentDirectory
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    return [libDir stringByAppendingPathComponent:oppsitePath];
}
/**
 解压文件
 
 @param fromPath 压缩包路径
 @param toPath 目标路径
 @param success 成功回调
 @param failure 失败回调
 */
- (void)unzipItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure{
//    ZipArchive *rg_zip = [[ZipArchive alloc] init];
//    //    NSLog(@"解压包包包路径 -- %@",fromPath);
//    //    NSLog(@"解压后后后路径 -- %@",toPath);
//    BOOL unzipOpen = [rg_zip UnzipOpenFile:fromPath];
//    BOOL unzipTo = [rg_zip UnzipFileTo:toPath overWrite:YES];// YES: 不会创建新的目录
//    if (unzipOpen) {// 打开解压缩文件成功
//        if (unzipTo) {
//            // 解压成功,返回所需路径
//            NSString *st = [toPath stringByAppendingString:@"/document.st"];
//            NSString *dbx = [toPath stringByAppendingString:@"/document.dbx"];
//            NSString *dbplayer = [toPath stringByAppendingString:@"/document.dbplayer"];
//            NSString *versionTxt = [toPath stringByAppendingString:@"/Version.txt"];
//
//            if (![_fileMgr fileExistsAtPath:st] && ![_fileMgr fileExistsAtPath:dbx] && ![_fileMgr fileExistsAtPath:dbplayer] && ![_fileMgr fileExistsAtPath:versionTxt]) {
//                if (failure) {
//                    [rg_zip UnzipCloseFile];
//                    failure(@"多媒体文件错误");
//                }
//            }else{
//                // 解压成功,删除压缩包 & 返回路径
//                if (success) {
//                    [rg_zip UnzipCloseFile];
//                    // 删除压缩包
//                    // 回调解压缩文件路径
//                    success(toPath);
//                }
//            }
//
//        }else{
//            if (failure) {
//                [rg_zip UnzipCloseFile];
//                failure(@"解压失败");
//            }
//        }
//    }else{
//        if (failure) {
//            failure(@"解压包不存在");
//        }
//    }
}
/**
 拷贝文件致目标路径
 
 @param bundlePath bundle路径
 @param path 原路径
 @param fileName 目标路径
 */
- (void)copyItemAtPath:(NSString *)bundlePath toPath:(NSString *)path ofFileName:(NSString *)fileName{
    _zipPath = path;// 压缩包目录
    __block NSError *error;
    NSString *absoPath = [NSString stringWithFormat:@"%@/%@",path,fileName];// 绝对路径(包含文件名)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self->_fileMgr copyItemAtPath:bundlePath toPath:absoPath error:&error];
    });
    if (error) {NSLog(@"--error--:%@",error.description);}
}

/// MARK: getter
- (NSString *)filePath{
    if (!_filePath) {
        /// MARK: 党建项目资源文件存放路径
        _filePath = [self absulotePathWithOppositePath:@"file_hbdj_resource"];
    }
    return _filePath;
}

+ (NSString *)localURLWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    return [[self sharedLocalFileManager] localURLWithUserId:userId bookId:bookId try:try format:format];
}
+ (NSString *)localIdentifyWithUserId:(NSInteger)userId bookId:(NSInteger)bookId try:(BOOL)try format:(NSInteger)format{
    return [[self sharedLocalFileManager] localIdentifyWithUserId:userId bookId:bookId try:try format:format];
}
+ (void)copyFileInBundleWithBundlePath:(NSString *)bundlePath toPath:(NSString *)path fileName:(NSString *)fileName{
    [[self sharedLocalFileManager] copyFileInBundleWithBundlePath:bundlePath toPath:path fileName:fileName];
}
+ (void)unzipFileWithPath:(NSString *)path toPath:(NSString *) toPath uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure{
    [[self sharedLocalFileManager] unzipFileWithPath:path toPath:toPath uzSuccess:success uzFailure:failure];
}
+ (void)moveFileAtPath:(NSString *)oriPath toPath:(NSString *)toPath competion:(void(^)(BOOL done,NSString *destination))completion{
    [[self sharedLocalFileManager] moveFileAtPath:oriPath toPath:toPath competion:completion];
}
+ (void)deleteLocalFileWithPath:(NSString *)path{
    [[self sharedLocalFileManager] deleteLocalFileWithPath:path];
}
+ (BOOL)fileIsExist:(NSString *)path{
    return [[self sharedLocalFileManager] fileIsExist:path];
}
+ (void)initLocalFilePath{
    [[self sharedLocalFileManager] initLocalFilePath];
}
+ (void)clearLocalFiles{
    [[self sharedLocalFileManager] clearLocalFiles];
}
+ (long long)localFileSizeWithPath:(NSString *)path{
    return [[self sharedLocalFileManager] localFileSizeWithPath:path];
}
+ (instancetype)sharedLocalFileManager{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
