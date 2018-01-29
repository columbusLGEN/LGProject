//
//  ECRDownloadFirstReadSecond.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRDownloadFirstReadSecond.h"
#import "ECRDownloadManager.h"
#import "ECRBookReaderManager.h"
#import "ECRBookInfoModel.h"
#import "ECRBookrackDataHandler.h"
#import "ECRLocalFileManager.h"
#import "LGCryptor.h"

@interface ECRDownloadFirstReadSecond ()
/** 下载进度条 */
@property (strong,nonatomic) MBProgressHUD *dlProgressHUD;//

@end

@implementation ECRDownloadFirstReadSecond

+ (void)downloadFirstReadSecondWithvc:(UIViewController *)vc book:(BookModel *)book success:(void (^)())success failure:(void(^)(NSError *error))failure{
    [[self sharedInstance] downloadFirstReadSecondWithvc:vc book:book success:success failure:failure];
}
- (void)downloadFirstReadSecondWithvc:(UIViewController *)vc book:(BookModel *)book success:(void (^)())success failure:(void(^)(NSError *error))failure{
    MBProgressHUD *dlProgressHUD;
    //        self.model.eBookFormat = 3;
    ///http://wind4app-bdys.oss-cn-hangzhou.aliyuncs.com/CMD_MarkDown.zip
//    NSString *URLString = @"http://123.59.197.176/group1/M00/00/01/CgoKBFoKft2Ad_aGAE31tVJfh_w438.pdf";// pdf 测试链接
    //        NSString *URLString = @"http://192.168.10.68:8080/BLCUPManageSystem/book/epub/9787561944882.epub";// epub 测试链接
    //        NSString *URLString = @"http://123.59.197.176/group1/M00/00/01/CgoKBFoEGTmAN5SaAv7FFFfh4_U313.dbz";// dbz 测试链接 超媒体压缩包
    // 1 获取下载链接
    NSString *URLString = book.downloadURL;
    if ([URLString empty] || URLString == nil) {
        [vc presentFailureTips:LOCALIZATION(@"下载链接已失效, 请联系管理员")];
        return;
    }
    //        // 2 创建本地存储链接 -- 将拼接链接的操作封装到 ECRDownloadManager 内部
//    NSString *localFilePath /// -->> book.localURL
    
    // 3 判断本地存储链接是否存在,若存在直接打开,否则进行下载
    BOOL filePathIsExist;
    
    if (book.eBookFormat == BookModelBookFormatEPUB) {
        filePathIsExist = [ECRDownloadManager fileIsExist:book.localEpubEncodePath];
    }else{
        filePathIsExist = [ECRDownloadManager fileIsExist:book.localURL];
    }
    
    if (filePathIsExist) {
        // 3.1 直接打开本地路径
        if (success) {
            success();
        }
        if (book.eBookFormat == BookModelBookFormatEPUB) {
            // 对 epub 文件解密
            [LGCryptor decryptWithEncodePath:book.localEpubEncodePath decodePath:book.localURL success:^(NSString *path) {
                // 打开 解密后的epub 文件
                NSLog(@"打开parh -- %@",path);
                [ECRBookReaderManager readBookWithType:book.eBookFormat localURL:path vc:vc bookModel:book ymeBook:book.ymeBook readFailure:^(id info) {
                    NSLog(@"readfailure -- %@",info);
                }];
            } failure:^(NSError *error) {
                
            }];
        }else{
            [ECRBookReaderManager readBookWithType:book.eBookFormat localURL:book.localURL vc:vc bookModel:book ymeBook:book.ymeBook readFailure:^(id info) {
                NSLog(@"readfailure -- %@",info);
            }];
        }
    }else{
        // 3.2.1 添加下载进度条
        dlProgressHUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        _dlProgressHUD = dlProgressHUD;
        [vc.view addSubview:dlProgressHUD];
        dlProgressHUD.mode = MBProgressHUDModeAnnularDeterminate;
        dlProgressHUD.progress = 0.0;
        
        // 3.2.2 开始下载
        [ECRDownloadManager downloadWithURLString:URLString fileName:book.tempLocalURL progress:^(CGFloat progress, CGFloat total, CGFloat current) {
            //        NSLog(@"下载中 grogress -- %f",progress / 100);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 3.2.2.1 更新下载进度
                dlProgressHUD.progress = progress / 100;
            }];
        } success:^(NSString *tempLocalURL) {
//            NSLog(@"localURL -- %@",tempLocalURL);
            // 3.2.2.2.1 隐藏下载进度条
            [dlProgressHUD hideAnimated:YES];
            
            if (success) success();
            
            [ECRLocalFileManager moveFileAtPath:tempLocalURL toPath:book.localURL competion:^(BOOL done, NSString *destination) {
                
                if (book.eBookFormat == BookModelBookFormatEPUB) {
                    // 对 epub 文件加密
                    [LGCryptor encryptWithOriPath:destination toPath:book.localEpubEncodePath success:^(NSString *path) {
                        // 对 epub 文件解密
                        [LGCryptor decryptWithEncodePath:book.localEpubEncodePath decodePath:book.localURL success:^(NSString *path) {
                            // 打开 解密后的epub 文件
                            NSLog(@"打开parh -- %@",path);
                            [ECRBookReaderManager readBookWithType:book.eBookFormat localURL:path vc:vc bookModel:book ymeBook:book.ymeBook readFailure:^(id info) {
                                NSLog(@"readfailure -- %@",info);
                            }];
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    } failure:^(NSError *error) {
                       NSLog(@"加密失败 -- %@",error);
                    }];
                    
                }else{
                    // 3.2.2.2.2 打开本地路径
                    [ECRBookReaderManager readBookWithType:book.eBookFormat localURL:destination vc:vc bookModel:book ymeBook:book.ymeBook readFailure:^(id info) {
                        NSLog(@"readfailure -- %@",info);
                    }];
                }
                
            }];
            

            // MARK: 调用接口, 将该书加入书架,
            [ECRBookrackDataHandler bookShelfAddBookToBookrackWithBookId:book.bookId success:^(id objc) {
                NSLog(@"加入书架成功 -- %@",objc);
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookrackLoadNewData object:nil userInfo:nil];
            } failure:^(NSError *error, NSString *msg) {
                NSLog(@"加入书架失败 error: %@ --msg %@",error,msg);
            }];
            
        } failure:^(NSError *error) {
            [_dlProgressHUD hideAnimated:YES];
            if (failure){
                failure(error);
            }
        }];
    }
}

+ (void)removeDlProgressHUD{
    [[self sharedInstance] removeDlProgressHUD];
}

- (void)removeDlProgressHUD{
    if (_dlProgressHUD != nil) {
        [_dlProgressHUD hideAnimated:YES];
    }
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
