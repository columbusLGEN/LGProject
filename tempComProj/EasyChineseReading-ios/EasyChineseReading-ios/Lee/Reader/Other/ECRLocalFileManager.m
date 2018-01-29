//
//  ECRLocalFileManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRLocalFileManager.h"
#import "ZipArchive.h"
#import "ECRDownloadManager.h"

@interface ECRLocalFileManager ()
/** 文件管理者类 */
@property (strong,nonatomic) NSFileManager *fileMgr;
/** 压缩包路径 */
@property (strong,nonatomic) NSString *zipPath;

@end

@implementation ECRLocalFileManager

/**
 移动文件
 
 @param oriPath 原路径
 @param toPath 目标路径
 @param completion 结果
 */
+ (void)moveFileAtPath:(NSString *)oriPath toPath:(NSString *)toPath competion:(void(^)(BOOL done,NSString *destination))completion{
    [[self sharedLocalFileManager] moveFileAtPath:oriPath toPath:toPath competion:completion];
}
- (void)moveFileAtPath:(NSString *)oriPath toPath:(NSString *)toPath competion:(void(^)(BOOL done,NSString *destination))completion{
    __block NSError *error;
    __block BOOL done;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        done = [_fileMgr moveItemAtPath:oriPath toPath:toPath error:&error];
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

+ (void)clearLocalFiles{
    [[self sharedLocalFileManager] clearLocalFiles];
}
- (void)clearLocalFiles{
    [self.fileMgr removeItemAtPath:[self sandBoxDocumentsPath] error:nil];
    [ECRDownloadManager initLocalFilePath];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookrackLoadNewData object:nil userInfo:nil];
}

+ (long long)localFileSizeWithPath:(NSString *)path{
    return [[self sharedLocalFileManager] localFileSizeWithPath:path];
}
- (long long)localFileSizeWithPath:(NSString *)path{
    BOOL exist = [self lg_fileExistWithPath:path];
    if (exist) {
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        long long fileSize = [dict fileSize];
        return fileSize;
    }else{
        return 0;
    }
}

/**
 根据路径删除文件
 
 @param path 目标文件路径
 */
+ (void)deleteLocalFileWithPath:(NSString *)path{
    [[self sharedLocalFileManager] deleteLocalFileWithPath:path];
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

/**
 解压文件
 
 @param path 压缩包路径
 @param fileName 目标文件名
 @param toPath 目标文件夹
 @param toFileName 目标文件名
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)unzipFileWithPath:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *) toPath toFileName:(NSString *)toFileName uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure{
    [[self sharedLocalFileManager] unzipFileWithPath:path fileName:fileName toPath:toPath toFileName:toFileName uzSuccess:success uzFailure:failure];
}
- (void)unzipFileWithPath:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *) toPath toFileName:(NSString *)toFileName uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure{
    NSString *fromPath = [NSString stringWithFormat:@"%@",path];
    NSString *absoPath = [NSString stringWithFormat:@"%@/%@",toPath,fileName];// 绝对路径(包含文件名)
    BOOL isDir = FALSE;
    BOOL isDirExist = [_fileMgr fileExistsAtPath:toPath isDirectory:&isDir];
    if (isDir && isDirExist) {// 路径存在
        // 判断解压缩路径是否存在,如果存在,直接返回路径
        BOOL unzipIsDir;
        BOOL unzipExist = [_fileMgr fileExistsAtPath:absoPath isDirectory:&unzipIsDir];
        if (unzipIsDir && unzipExist) {
            if (success) {
                success(absoPath);
            }
        }else{
            // 直接解压缩致 路径下
            [self unzipItemFromPath:fromPath toPath:absoPath uzSuccess:success uzFailure:failure];
        }
    }else{
        // 路径不存在
        // 1.创建路径
        BOOL bCreateDir = [_fileMgr createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (bCreateDir) {
            // 创建路径成功,解压缩文件
            [self unzipItemFromPath:fromPath toPath:absoPath uzSuccess:success uzFailure:failure];
            
        }else{
            if (failure) {
                failure(@"创建路径失败");
            }
        }
    }
}


/**
 解压文件

 @param fromPath 压缩包路径
 @param toPath 目标路径
 @param success 成功回调
 @param failure 失败回调
 */
- (void)unzipItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath uzSuccess:(void(^)(NSString *absuPath))success uzFailure:(void(^)(NSString *info))failure{
    ZipArchive *rg_zip = [[ZipArchive alloc] init];
//    NSLog(@"解压包包包路径 -- %@",fromPath);
//    NSLog(@"解压后后后路径 -- %@",toPath);
    BOOL unzipOpen = [rg_zip UnzipOpenFile:fromPath];
    BOOL unzipTo = [rg_zip UnzipFileTo:toPath overWrite:YES];// YES: 不会创建新的目录
    if (unzipOpen) {// 打开解压缩文件成功
        if (unzipTo) {
            // 解压成功,返回所需路径
            NSString *st = [toPath stringByAppendingString:@"/document.st"];
            NSString *dbx = [toPath stringByAppendingString:@"/document.dbx"];
            NSString *dbplayer = [toPath stringByAppendingString:@"/document.dbplayer"];
            NSString *versionTxt = [toPath stringByAppendingString:@"/Version.txt"];
            
            if (![_fileMgr fileExistsAtPath:st] && ![_fileMgr fileExistsAtPath:dbx] && ![_fileMgr fileExistsAtPath:dbplayer] && ![_fileMgr fileExistsAtPath:versionTxt]) {
                if (failure) {
                    [rg_zip UnzipCloseFile];
                    failure(@"多媒体文件错误");
                }
            }else{
                // 解压成功,删除压缩包 & 返回路径
                if (success) {
                    [rg_zip UnzipCloseFile];
                    // 删除压缩包,牵扯到要改的比较多,顾暂不删除
//                    [ECRLocalFileManager deleteLocalFileWithPath:fromPath];
                    // 回调解压缩文件路径
                    success(toPath);
                }
            }
            
        }else{
            if (failure) {
                [rg_zip UnzipCloseFile];
                failure(@"解压失败");
            }
        }
    }else{
        if (failure) {
            failure(@"解压包不存在");
        }
    }
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
        [_fileMgr copyItemAtPath:bundlePath toPath:absoPath error:&error];
    });
    if (error) {NSLog(@"--error--:%@",error.description);}
}

// 1.拷贝压缩包
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

- (BOOL)lg_fileExistWithPath:(NSString *)path{
    return [_fileMgr fileExistsAtPath:path];
}
/** 但会沙盒 Documents 路径 */
- (NSString *)sandBoxDocumentsPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (instancetype)init{
    if (self = [super init]) {
        self.fileMgr = [NSFileManager defaultManager];
    }
    return self;
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
