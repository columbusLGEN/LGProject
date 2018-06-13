
//
//  ECRBookReaderManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "LGBookReaderManager.h"
#import <YMEpubReaderKit/YMEpubReaderManager.h>
//#import <YMEpubReaderKit/Bookmark.h>

@interface LGBookReaderManager ()<
YMEpubReaderManagerDelegate>

@property (strong,nonatomic) YMEpubReaderManager *ymepubReader;//

/** 当前资源模型 */
@property (strong,nonatomic) NSObject *currentBookModel;//
/** 开始阅读时间点 */
@property (strong,nonatomic) NSDate *beginReadTime;//
/** 阅读时间 */
@property (assign,nonatomic) NSTimeInterval readTime;//

@end

@implementation LGBookReaderManager

+ (void)openBookWithLocalUrl:(NSString *)localUrl bookId:(NSString *)bookId vc:(UIViewController *)vc{
    [[self sharedInstance] openBookWithLocalUrl:localUrl bookId:(NSString *)bookId vc:vc];
}
- (void)openBookWithLocalUrl:(NSString *)localUrl bookId:(NSString *)bookId vc:(UIViewController *)vc{
    /// TODO: 获取userid
    MyBook *book = [self.ymepubReader loadBookWithPath:localUrl userId:@"1" bookId:bookId];
    [self.ymepubReader readBook:book fromController:vc];
}


#pragma mark - YMEpubReaderManagerDelegate
// read controller 生命周期 回调
- (void)willBeginRead{
    NSLog(@"willBeginRead");
}
- (void)didBeginRead{
    NSLog(@"didBeginRead");
    /// 开始计时 , 测试 == 10秒
    self.beginReadTime = [NSDate date];
    /// MARK: 删除本地未加密文件
    /// 如果是用户从本地导入的书籍，则不删除
//    if (!(self.currentBookModel.owendType == BookModelOwnedTypeiTunes)) {
//        [[NSFileManager defaultManager] removeItemAtPath:self.epubPath_not_encode error:nil];
//    }
}
- (void)willEndRead{
    NSLog(@"willEndRead");
    // 获取时间(阅读秒数)
    self.readTime = [[NSDate date] timeIntervalSinceDate:self.beginReadTime];
    // 转成小时
    double hour = self.readTime / 3600;
    // 转成字符串
    NSString *readTimeStr = [NSString stringWithFormat:@"%f",hour];
    /// 请求上传进度接口
    NSNumber *finalProgress;// = self.ymepubReader.currentReadBook.readProgress;
    if (finalProgress.floatValue > 0.99) {
        finalProgress = @1;
    }
    /// TODO: 上传阅读进度
}
- (void)didEndRead{
    NSLog(@"didEndRead");
    
}

- (void)didAddBookMark:(Bookmark *)bookMark {
    
}

- (void)didAddDigest:(BookDigest *)digest {
    
}

- (void)didDeleteBookMark:(Bookmark *)bookMark {
    
}

- (void)didDeleteDigest:(BookDigest *)digest {
    
}


+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (YMEpubReaderManager *)ymepubReader{
    if (_ymepubReader == nil) {
        _ymepubReader = [YMEpubReaderManager shardInstance];
        _ymepubReader.delegate = self;
        //        _ymepubReader.hostIp = @"http://192.168.10.113:8080";
    }
    return _ymepubReader;
}


@end
