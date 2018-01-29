//
//  ECRLocalFileFinder.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRLocalFileFinder.h"
#import "ECRBookrackModel.h"
#import "ECRLocalFileManager.h"
#import "ReaderViewController.h"
#import "ECRDownloadStateModel.h"
#import "ECRPDFRelateder.h"

static NSString * const epub = @"epub";
static NSString * const pdf = @"pdf";

@interface ECRLocalFileFinder ()
/** 书架模型数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *bookrackModels;

@end

@implementation ECRLocalFileFinder

+ (void)findLocalEpubAndPdfInDocuments:(LocalFileFinderDone)lffDone{
    [[self sharedInstance] findLocalEpubAndPdfInDocuments:lffDone];
}
- (void)findLocalEpubAndPdfInDocuments:(LocalFileFinderDone)lffDone{
    if (self.bookrackModels.count > 0) {
        [self.bookrackModels removeAllObjects];
        self.bookrackModels = nil;
    }
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    for (NSInteger i = 0; i<array.count; i++) {
        NSString *path = array[i];
//        NSLog(@"本地文件相对路径 -- %@",path);
        if ([path hasSuffix:pdf]) {
            [self setUpBookrackModelWithPath:path eBookformat:BookModelBookFormatPDF];
        }
        if ([path hasSuffix:epub]) {
            [self setUpBookrackModelWithPath:path eBookformat:BookModelBookFormatEPUB];
        }
    }
    if (lffDone) {
        [self.bookrackModels enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//           NSLog(@"本地图书书名 -- %@",obj.bookName);
        }];
        lffDone(self.bookrackModels.copy);
    }
}
- (void)setUpBookrackModelWithPath:(NSString *)path eBookformat:(BookModelBookFormat)eBookformat{
    NSString *suffix = suffixWithFormat(eBookformat);
    if ([path hasSuffix:suffix]) {
        NSString *fileAbsulotePath = [[self sandBoxDocumentsPath] stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        long long fileSize = [ECRLocalFileManager localFileSizeWithPath:fileAbsulotePath];
//        NSLog(@"%@文件大小 -- %lld",suffix,fileSize);
//        NSLog(@"%@文件 绝对路径 -- %@",suffix,fileAbsulotePath);
        
        /// 创建模型
        ECRBookrackModel *localBook = [ECRBookrackModel new];
        
        /// 获取pdf文件封面
        if ([suffix isEqualToString:pdf]) {
            localBook.localFileCover = [ECRPDFRelateder getPDFCoverWithPath:fileAbsulotePath];
        }
        
        /// 获取epub文件封面
        if ([suffix isEqualToString:epub]) {
            localBook.localFileCover = LGPlaceHolderImg;
        }
        
        localBook.iTunesResource = YES;
        /// 书籍类型
        localBook.eBookFormat = eBookformat;
        /// 下载模型
        ECRDownloadStateModel *dsModel = [ECRDownloadStateModel new];
        dsModel.modelState = ECRDownloadStateModelStateDownloaded;
        localBook.dsModel = dsModel;
        /// 
        localBook.currentPlace = 1;
        /// 获取文件名
        NSString *bName = [self bNameWithPath:path suffix:suffix];
        localBook.bookName = bName;
        localBook.en_bookName = bName;
        /// 作者
//        localBook.author;
        /// 文件大小
        localBook.locationsize = fileSize;
        localBook.localURL = fileAbsulotePath;
        [self.bookrackModels addObject:localBook];
    }
}

/**
 截取本地文件名
 
 @param path 文件的相对路径
 @param suffix 后缀
 @return 结果
 */
- (NSString *)bNameWithPath:(NSString *)path suffix:(NSString *)suffix{
    NSRange range;
    range.location = 0;
    range.length = path.length - suffix.length - 1;
    return [path substringWithRange:range];
}

/** 返回沙盒 Documents 路径 */
- (NSString *)sandBoxDocumentsPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
- (NSMutableArray<ECRBookrackModel *> *)bookrackModels{
    if (_bookrackModels == nil) {
        _bookrackModels = [NSMutableArray array];
    }
    return _bookrackModels;
}

NSString *suffixWithFormat(BookModelBookFormat format){
    switch (format) {
        case BookModelBookFormatPDF:
            return pdf;
            break;
        case BookModelBookFormatEPUB:
            return epub;
        default:
            return @"";
    }
}
@end
