//
//  LGCacheClear.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGCacheClear.h"

@interface LGCacheClear ()


@end

@implementation LGCacheClear

- (void)clearCacheWithAlertCallBack:(LGClearCacheAlertBack)alertCallBack completion:(LGClearCacheCompletion)completion{
    
    if ([[self cacheSize] isEqualToString:@"0.0M"]) {
        return;
    }
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [self cachePath];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%ld",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       
                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                           [self clearCacheSuccessWithAlertCallBack:alertCallBack completion:completion];
                       }];
                       
                   });
}

- (NSString *)cacheSize{
    
    NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cachePath] error:nil];
    
    float size = 0;
    
    for(int i = 0; i<[array count]; i++){
        NSString *fullPath = [[self cachePath] stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        
        if (!([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) ){
            
            NSDictionary *fileAttributeDic = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            
            size += fileAttributeDic.fileSize/ 1024.0/1024.0;
            
        }
    }

    NSString *sizeString = [NSString stringWithFormat:@"%0.1fM",size];
    
    return sizeString;
}

////计算单个文件的大小，多少M
//- (NSString *) fileSizeAtPath:(NSString*)cachPath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:cachPath]){
//        unsigned long long length  = [[[manager attributesOfItemAtPath:cachPath error:nil] objectForKey:NSFileSize] longLongValue];
//        float ff = length/1024.0/1024.0; //换算成多少M
//        NSString *size = [NSString stringWithFormat:@"%0.2fM",ff];
//        return size;
//    }
//    return 0;
//}


//清理缓存后刷新
-(void)clearCacheSuccessWithAlertCallBack:(LGClearCacheAlertBack)alertCallBack completion:(LGClearCacheCompletion)completion{
    
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"清理成功" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) completion();
    }];
    
    [alertvc addAction:done];

    if (alertCallBack) alertCallBack(alertvc);
}

//获取缓存文件路径
- (NSString *)cachePath{
    // tmp
    return NSTemporaryDirectory();
    // library/caches
//    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
}

@end
