//
//  YMEpubReaderManager.h
//  YMEpubReaderKit
//
//  Created by 房志刚 on 24/8/2017.
//  Copyright © 2017 retechcorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBook.h"
#import "Catalogue.h"
#import "BookDigest.h"
#import "Bookmark.h"

@protocol YMEpubReaderManagerDelegate <NSObject>

//# read controller 生命周期 回调 #################
- (void)willBeginRead;
- (void)didBeginRead;
- (void)willEndRead;
- (void)didEndRead;
//##########################################


- (void)didAddDigest:(BookDigest *)digest;     //添加书摘或笔记，对应回调
- (void)didDeleteDigest:(BookDigest *)digest;
- (void)didAddBookMark:(Bookmark *)bookMark;   //添加书签，对应回调
- (void)didDeleteBookMark:(Bookmark *)bookMark;

@end

typedef void (^loadComplete)(NSArray<MyBook *> *bookArray, NSError *error);

@interface YMEpubReaderManager : NSObject

+ (YMEpubReaderManager *)shardInstance;

@property (strong, nonatomic) NSString *hostIp;      //服务端IP

@property (weak, nonatomic) id<YMEpubReaderManagerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *bookArray;

//- (void)loadBooksOfDirectoryAtPath:(NSString *)path completeBlock:(loadComplete)completeBlock;   //从一个文件夹一次加载多本书, 例如书架
//- (NSArray<MyBook *> *)loadBookWithPath:(NSString *)path;       //单本加载
- (MyBook *)loadBookWithPath:(NSString *)path userId:(NSString *)userId bookId:(NSString *)bookId;    //单本加载



- (void)readBook:(MyBook *)book fromController:(UIViewController *)controller;                //阅读
- (UIViewController *)fetchReadViewControllerWithBook:(MyBook *)book;         //获取read controller
- (void)deleteBook:(MyBook *)book;              //删除



- (MyBook *)currentReadBook;  //当前阅读的书

- (NSArray<Catalogue *> *)getCataloguesWithBook:(MyBook *)book;   //获取目录
- (NSArray<BookDigest *> *)getDigestWithBook:(MyBook *)book;      //获取笔记
- (NSArray<Bookmark *> *)getBookMarkWithBook:(MyBook *)book;      //获取书签

@end
