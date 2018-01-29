//
//  ECRHypermediaManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRHypermediaManager.h"
#import "DBPlayer.h"
#import "ReaderViewController.h"
#import "ECRMentionBoy.h"
#import "ECRDataHandler.h"

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器1
@interface ECRHypermediaManager ()<
ReaderViewControllerDelegate
>

#else
// MARK: 真机1
@interface ECRHypermediaManager ()<
DBPlayerDelegate,
ReaderViewControllerDelegate
>

#endif

@property (strong,nonatomic) ReaderViewController *pdfReader;//
/** DB当前书籍总页数 */
@property (assign,nonatomic) NSInteger totalPages;//

/** pdf 开始阅读时间 */
@property (strong,nonatomic) NSDate *pdfBeginReadTime;//
/** pdf document */
@property (strong,nonatomic) ReaderDocument *pdfDocu;
/** pdf bookModel */
@property (strong,nonatomic) BookModel *pdfBook;

/** DB 开始阅读时间 */
@property (strong,nonatomic) NSDate *dbBeginReadTime;//
/** db bookModel */
@property (strong,nonatomic) BookModel *dbBook;

/** 保存用户超媒体阅读进度文件 */
@property (strong,nonatomic) NSString *dbProgressRecordFile;

@end

@implementation ECRHypermediaManager

+ (void)lg_initLocalFile{
    [[self sharedInstance] lg_initLocalFile];
}
- (void)lg_initLocalFile{
    BOOL dbProgressRecordFileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.dbProgressRecordFile];
    if (dbProgressRecordFileExist) {
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary new];
        BOOL createDbProgressRecordFile = [[NSFileManager defaultManager] createFileAtPath:self.dbProgressRecordFile contents:nil attributes:nil];
        if (createDbProgressRecordFile) {
            [dict writeToFile:self.dbProgressRecordFile atomically:YES];
        }else{
            
        }
    }
    
    
}
- (NSString *)dbProgressRecordFile{
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentPath stringByAppendingString:@"/dbPlayerProgress.plist"];
}

#if TARGET_IPHONE_SIMULATOR
// MARK: 模拟器1


#else
// MARK: 真机1
+ (void)openHypermidiaWithURL:(NSString *)hyperURL vc:(UIViewController *)vc book:(BookModel *)book{
    [[self sharedInstance] openHypermidiaWithURL:hyperURL vc:vc book:book];
}

- (void)openHypermidiaWithURL:(NSString *)hyperURL vc:(UIViewController *)vc book:(BookModel *)book{
    self.dbBook = book;
    [vc presentViewController:self.dbPlayer animated:YES completion:^{
        self.dbBeginReadTime = [NSDate date];
        [ECRMentionBoy mentionUser];
        [self.dbPlayer openABook:hyperURL contentUrl:@""];
        self.totalPages = [self.dbPlayer getTotalNumberOfPages];
        
    }];
}

#pragma mark - DBPlayerDelegate
- (void)dbPlayerDidClosed{
    self.totalPages = [self.dbPlayer getTotalNumberOfPages];
    NSLog(@"dbPlayerDidClosed total -- %ld",self.totalPages);
    // 当前页数
    NSInteger currentPage = [self.dbPlayer getCurrentPageIndex];
    // 计算进度
    CGFloat progress = currentPage / self.totalPages;
    
    /// 阅读时间
    NSTimeInterval readTime = [[NSDate date] timeIntervalSinceDate:self.dbBeginReadTime];
    // 转成小时
    double hour = readTime / 3600;
    // 转成字符串
    NSString *readTimeStr = [NSString stringWithFormat:@"%f",hour];
    
    /// 上传超媒体阅读进度
    [self uploadReadProgressWithBookId:self.dbBook.bookId progress:@(progress) readTime:readTimeStr totalWorld:nil];
    
    [self.dbPlayer dismissViewControllerAnimated:YES completion:^{
        // 保存进度
        [self saveDbPorgress];
        // 显示状态栏
        self.dbPlayer = nil;// 一定要释放前一个 player，否则会造成屏幕错位
        [ECRMentionBoy cancelMention];
    }];
}
- (void)saveDbPorgress{
    // 获取当前页数
    NSInteger currentPage = [self.dbPlayer getCurrentPageIndex];
    // 获取当前场景
    
    // 获取总页数
    NSInteger totalPage = [self.dbPlayer getTotalNumberOfPages];
    NSString *progressKey = [NSString stringWithFormat:@"%ld_%ld",[UserRequest sharedInstance].user.userId,self.dbBook.bookId];
    NSDictionary *progress = @{@"currentPage":@(currentPage),
                               @"totalPage":@(totalPage)
                               };
    NSLog(@"db_progress -- %@",progress);
    NSMutableDictionary *progressDict = [NSMutableDictionary dictionaryWithContentsOfFile:self.dbProgressRecordFile];
    progressDict[progressKey] = progress;
    [progressDict writeToFile:self.dbProgressRecordFile atomically:YES];
}

- (void)dbPlayerErrorOccured:(NSError *)error{
    [self.dbPlayer dismissViewControllerAnimated:YES completion:^{
        self.dbPlayer = nil;// 一定要释放前一个 player，否则会造成屏幕错位
        [ECRMentionBoy cancelMention];
        
        
    }];
    NSLog(@"DBPlayerError -- %@",error);
}

- (DBPlayer *)dbPlayer{
    if (_dbPlayer == nil) {
        _dbPlayer = [[DBPlayer alloc]init];
        _dbPlayer.delegate = self;
        _dbPlayer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return _dbPlayer;
}

#endif

// 返回 pdf 阅读器
+ (ReaderViewController *)openPDFWithURL:(NSString *)URLString book:(BookModel *)book{
    return [[self sharedInstance] openPDFWithURL:URLString book:book];
}
- (ReaderViewController *)openPDFWithURL:(NSString *)URLString book:(BookModel *)book{
    ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:URLString password:nil];
    self.pdfDocu = doc;
    self.pdfBook = book;
    [doc setValue:book.bookName forKey:@"fileName"];
    self.pdfReader = [[ReaderViewController alloc] initWithReaderDocument:doc];
    self.pdfReader.delegate = self;
    [ECRMentionBoy mentionUser];
    self.pdfBeginReadTime = [NSDate date];
    return self.pdfReader;
}

#pragma mark - 退出PDF阅读时 ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController{
//    NSLog(@"pdfDocu.pageCount -- %@",self.pdfDocu.pageCount);
//    NSLog(@"pdfDocu.pageNumber -- %@",self.pdfDocu.pageNumber);
    /// 计算进度
    CGFloat progress = 0.0;
    if (self.pdfDocu.pageCount) {
        progress = self.pdfDocu.pageNumber.floatValue / self.pdfDocu.pageCount.floatValue;
    }
    /// 阅读时间
    NSTimeInterval readTime = [[NSDate date] timeIntervalSinceDate:self.pdfBeginReadTime];
    // 转成小时
    double hour = readTime / 3600;
    // 转成字符串
    NSString *readTimeStr = [NSString stringWithFormat:@"%f",hour];
    /// 上传进度
    [self uploadReadProgressWithBookId:self.pdfBook.bookId progress:@(progress) readTime:readTimeStr totalWorld:nil];
    
    [self.pdfReader dismissViewControllerAnimated:YES completion:^{
        // 退出pdf阅读器的回调
        NSLog(@"退出PDF -- ");
        [ECRMentionBoy cancelMention];
    }];
}

// MARK: 上传阅读进度
+ (void)uploadReadProgressWithBookId:(NSInteger)bookId progress:(NSNumber *)progress readTime:(NSString *)readTime totalWorld:(NSNumber *)totalWorld{
    [[self sharedInstance] uploadReadProgressWithBookId:bookId progress:progress readTime:readTime totalWorld:totalWorld];
}
- (void)uploadReadProgressWithBookId:(NSInteger)bookId progress:(NSNumber *)progress readTime:(NSString *)readTime totalWorld:(NSNumber *)totalWorld {
    [ECRDataHandler uploadReadProgressBookId:bookId progress:progress readTime:readTime totalWord:nil success:^(id object) {
        /// 发送通知,刷新书架
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookrackLoadNewData object:nil];
    } failure:^(NSString *msg) {
        
    } commenFailure:^(NSError *error) {
        
    }];
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
