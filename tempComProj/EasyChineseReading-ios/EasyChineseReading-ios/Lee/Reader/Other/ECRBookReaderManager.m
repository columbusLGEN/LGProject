
//
//  ECRBookReaderManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookReaderManager.h"
#import "ECRHypermediaManager.h"
#import "ECREpubReader.h"
#import "ReaderViewController.h"
#import "ECRLocalFileManager.h"
#import "ECRDownloadManager.h"

@interface ECRBookReaderManager ()
@property (strong,nonatomic) ReaderViewController *pdfReader;//

@end

@implementation ECRBookReaderManager

/// 根据本地路径,图书类型,打开图书
+ (void)readBookWithType:(BookModelBookFormat)eBookFormat localURL:(NSString *)localURL vc:(UIViewController *)vc bookModel:(BookModel *)bookModel ymeBook:(MyBook *)ymeBook readFailure:(ECRBookReadFailure)readFailure{
    [[self sharedInstance] readBookWithType:eBookFormat localURL:localURL vc:vc bookModel:bookModel ymeBook:ymeBook readFailure:readFailure];
}

- (void)readBookWithType:(BookModelBookFormat)eBookFormat localURL:(NSString *)localURL vc:(UIViewController *)vc bookModel:(BookModel *)bookModel ymeBook:(MyBook *)ymeBook readFailure:(ECRBookReadFailure)readFailure{
    // 判断路径是否存在
    // 如果存在,判断链接格式是否与阅读器一致
    
    // TODO: 根据文件本身判断文件类型
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:localURL];
    if (exist) {
        switch (eBookFormat) {
            case BookModelBookFormatPDF:{// pdf
                self.pdfReader = [ECRHypermediaManager openPDFWithURL:localURL book:bookModel];
                [vc presentViewController:self.pdfReader animated:YES completion:nil];
            }
                break;
            case BookModelBookFormatEPUB:{// epub
                [ECREpubReader readBookWithPath:localURL fromController:vc bookModel:bookModel ymeBook:bookModel.ymeBook];
            }
                break;
            case BookModelBookFormatHYPER:{// 超媒体
#if TARGET_IPHONE_SIMULATOR
                // 模拟器
#else
                // 真机
                NSString *hypermedia = [ECRDownloadManager hypermediaURLWithUserId:bookModel.userId bookId:bookModel.bookId try:modelTry(bookModel.owendType) isZip:NO];

                // TODO: 如果解压缩路径存在,直接 打开
                    /// 否则 解压
                // 解压缩
                [ECRLocalFileManager unzipFileWithPath:localURL fileName:hypermedia toPath:[ECRDownloadManager sharedInstance].hyperUnzipFile toFileName:hypermedia uzSuccess:^(NSString *absuPath) {
                    NSLog(@"absupath -- %@",absuPath);
                    // 打开解压缩后的超媒体文件 --> 超媒体阅读器仅支持真机
                    [ECRHypermediaManager openHypermidiaWithURL:absuPath vc:vc book:bookModel];
                } uzFailure:^(NSString *info) {
                    NSLog(@"errinfo -- %@",info);
                }];
#endif
            }
                break;
                
            default:
                break;
        }
        
    }else{
        if (readFailure) {
            readFailure(@"路径不存在");
        }
//        NSLog(@"路径不存在 -- ");
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
