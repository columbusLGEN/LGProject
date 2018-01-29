//
//  ECREpubReader.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECREpubReader.h"
#import <YMEpubReaderKit/YMEpubReaderManager.h>
#import <YMEpubReaderKit/Bookmark.h>

#import "ECRMentionBoy.h"
#import "ECRHypermediaManager.h"

@interface ECREpubReader ()
<
YMEpubReaderManagerDelegate
>
@property (strong,nonatomic) NSArray *localTestBooks;//
@property (strong,nonatomic) YMEpubReaderManager *ymepubReader;//
@property (strong,nonatomic) BookModel *cuBookModel;//

/** 开始阅读时间 */
@property (strong,nonatomic) NSDate *beginReadTime;//
/** 阅读时间 */
@property (assign,nonatomic) NSTimeInterval readTime;//

/** 本地未加密路径 */
@property (copy,nonatomic) NSString *epubPath_not_encode;

@end

@implementation ECREpubReader

// MARK: 单本阅读
+ (void)readBookWithPath:(NSString *)path fromController:(UIViewController *)vc bookModel:(BookModel *)bookModel ymeBook:(MyBook *)ymeBook{
    [[self sharedEpubReader] readBookWithPath:path fromController:vc bookModel:bookModel ymeBook:ymeBook];
}
- (void)readBookWithPath:(NSString *)path fromController:(UIViewController *)vc bookModel:(BookModel *)bookModel ymeBook:(MyBook *)ymeBook{
    self.epubPath_not_encode = path;
    NSString *currentUserId = [NSString stringWithFormat:@"%ld",[UserRequest sharedInstance].user.userId];
    NSString *currentBookId = [NSString stringWithFormat:@"%ld",bookModel.bookId];
    self.cuBookModel = bookModel;
    // 加载之前,需要判断路径是否存在
//    NSLog(@"epub_book_path -- %@",path);
    // 一定不要加载path 下的 未解密文件, 否则会造成 读取书籍错误
    BOOL pathIsExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (pathIsExist) {
        MyBook *currentMyBook = [self.ymepubReader loadBookWithPath:path userId:currentUserId bookId:currentBookId];
        currentMyBook.bookName = bookModel.bookName;
        [self.ymepubReader readBook:currentMyBook fromController:vc];
    }else{
        NSLog(@"书籍路径不存在 -- ");
    }
}

#pragma mark - YMEpubReaderManagerDelegate
// read controller 生命周期 回调
- (void)willBeginRead{
    NSLog(@"willBeginRead");
}
- (void)didBeginRead{
    NSLog(@"didBeginRead");
    /// 开始计时 , 测试 == 10秒
    [ECRMentionBoy mentionUser];
    self.beginReadTime = [NSDate date];
    /// 删除本地未加密文件
    [[NSFileManager defaultManager] removeItemAtPath:self.epubPath_not_encode error:nil];
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
    NSNumber *finalProgress = self.ymepubReader.currentReadBook.readProgress;
    if (finalProgress.floatValue > 0.99) {
        finalProgress = @1;
    }
    [ECRHypermediaManager uploadReadProgressWithBookId:self.cuBookModel.bookId progress:finalProgress readTime:readTimeStr totalWorld:nil];
}
- (void)didEndRead{
    NSLog(@"didEndRead");
    [ECRMentionBoy cancelMention];
}

//添加书摘或笔记，对应回调
- (void)didAddDigest:(BookDigest *)digest{
    // digest.summary -- 原文
    // digest.digestNote -- 注解
    /// 摘要 & 笔记
    NSLog(@"noteID -- %@",digest.noteID);

    [[ECRDataHandler sharedDataHandler] saveMyNoteWithId:nil bookId:self.cuBookModel.bookId chapterindex:digest.catIndex chaptername:digest.catName position:nil positionoffset:nil summarycontent:@"摘要" notecontent:digest.digestNote summaryunderlinecolor:nil success:^(id object) {
        NSLog(@"添加笔记success -- %@",object);
        // 添加完成之后是否应该 返回 笔记id
        // 本地的笔记id 如何 与服务器的笔记id 对应起来?
        
    } failure:^(NSString *msg) {
        NSLog(@"添加笔记msg -- %@",msg);
    } commenFailure:^(NSError *error) {
        NSLog(@"添加笔记error -- %@",error);
    }];
}
- (void)didDeleteDigest:(BookDigest *)digest{
    // TODO: 删除笔记,未执行该回调
    NSLog(@"删除笔记 -- %@",digest.summary);
    
}
//添加书签，对应回调
- (void)didAddBookMark:(Bookmark *)bookMark{
    

}
- (void)didDeleteBookMark:(Bookmark *)bookMark{

}

+ (instancetype)sharedEpubReader{
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
        _ymepubReader.hostIp = AppServerBaseURL;
    }
    return _ymepubReader;
}


@end


