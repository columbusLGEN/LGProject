//
//  LGReadManager.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/22.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGReadManager.h"
/// epub
#import <YMEpubReaderKit/YMEpubReaderManager.h>
/// pdf
#import "ReaderViewController.h"
#import "TCMyBookrackModel.h"
#import "LGFileManager.h"

@interface LGReadManager ()<
YMEpubReaderManagerDelegate,
ReaderViewControllerDelegate>
@property (strong,nonatomic) YMEpubReaderManager *epubReader;
@property (strong,nonatomic) ReaderViewController *pdfReader;

@end

@implementation LGReadManager

- (void)openBookWithModel:(TCMyBookrackModel *)model vc:(nonnull UIViewController *)vc{
    switch (model.resourceType) {
        case LGBookResourceTypeEpub:{
            /// TODO: userId, bookID
            MyBook *book = [self.epubReader loadBookWithPath:model.localFilePath userId:@"1" bookId:@"1"];
            /// 获取书名
            book.bookName = model.bookName?model.bookName:@"";
            
            [self.epubReader readBook:book fromController:vc];
        }
            break;
        case LGBookResourceTypePDF:{
            /// PDF doc : ReaderDocument
            ReaderDocument *doc = [ReaderDocument.alloc initWithFilePath:model.localFilePath password:nil];
            [doc setValue:model.bookName forKey:@"fileName"];
            ReaderViewController *readervc = [ReaderViewController.alloc initWithReaderDocument:doc];
            readervc.delegate = self;
            self.pdfReader = readervc;
            [vc presentViewController:readervc animated:YES completion:nil];
        }
            break;
        case LGBookResourceTypeHyperMedia:{
            /// 判断是否已经解压
            BOOL unzipExist = [LGFileManager fileExists:model.hyperUnzipPath];
            if (unzipExist) {
                /// 1.如果已解压,直接打开
                
            }else{
                /// 2.如果未解压,解压后打开
                
            }
            
        }
            break;
    }
}

#pragma mark - PDF vc delegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    [self.pdfReader dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - EPUB delegate
// read controller 生命周期 回调
- (void)willBeginRead{
    NSLog(@"willBeginRead");
}
- (void)didBeginRead{
    NSLog(@"didBeginRead");
    /// 开始计时 , 测试 == 10秒
//    self.beginReadTime = [NSDate date];
    /// MARK: 删除本地未加密文件
    /// 如果是用户从本地导入的书籍，则不删除
    //    if (!(self.currentBookModel.owendType == BookModelOwnedTypeiTunes)) {
    //        [[NSFileManager defaultManager] removeItemAtPath:self.epubPath_not_encode error:nil];
    //    }
}
- (void)willEndRead{
    NSLog(@"willEndRead");
    // 获取时间(阅读秒数)
//    self.readTime = [[NSDate date] timeIntervalSinceDate:self.beginReadTime];
    // 转成小时
//    double hour = self.readTime / 3600;
    // 转成字符串
    //    NSString *readTimeStr = [NSString stringWithFormat:@"%f",hour];
    /// 请求上传进度接口
    NSNumber *finalProgress = self.epubReader.currentReadBook.readProgress;
    if (finalProgress.floatValue > 0.99) {
        finalProgress = @1;
    }
    
    /// 1.上传阅读进度
//    [[DJHomeNetworkManager sharedInstance] homeReadPorgressBookid:_currentBookid progress:finalProgress.floatValue success:^(id responseObj) {
//        NSLog(@"上传阅读进度: %@",responseObj);
//        /// 成功之后，回调进度给控制器
//        NSDictionary *userInfo = @{LGCloseReaderProgressKey:finalProgress};
//        [[NSNotificationCenter defaultCenter] postNotificationName:LGCloseReaderNotification object:nil userInfo:userInfo];
//
//    } failure:^(id failureObj) {
//        NSLog(@"上传阅读进度_failureObj: %@",failureObj);
//    }];
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

- (YMEpubReaderManager *)epubReader{
    if (!_epubReader) {
        _epubReader = [YMEpubReaderManager shardInstance];
        _epubReader.delegate = self;
        /// 同步笔记的 hostIp
        //        _epubReader.hostIp = @"http://192.168.10.113:8080";
    }
    return _epubReader;
}

@end
