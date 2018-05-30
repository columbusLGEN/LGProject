//
//  MyBook.h
//  JRReader
//
//  Created by 刘思洋 on 15/8/21.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, BookDownloadStatus) {
    BookDownloadStatusNotDownload      = 0,    // 未下载
    BookDownloadStatusDownloading      = 1,    // 下载中
    BookDownloadStatusPause            = 2,    // 暂停
    BookDownloadStatusFinished         = 3,    // 已下载
    BookDownloadStatusError            = 4,    // 下载出错
};

typedef NS_ENUM(NSInteger, BooSynchronizeStatus) {
    BookSynchronizeStatusFinished      = 1,    // 已同步
    BookSynchronizeStatusNeedUpload    = 2,    // 需要同步到服务器
    BookSynchronizeStatusNeedDelete    = 3,    // 需要从服务器删除
};

@interface MyBook : NSManagedObject

@property (nonatomic, retain) NSDate * accessDate;
@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * bookID;
@property (nonatomic, retain) NSString * bookJRID;
@property (nonatomic, retain) NSString * bookName;
@property (nonatomic, retain) NSString * bookName_EN;
@property (nonatomic, retain) NSString * bookType;
@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * cover;
@property (nonatomic, retain) NSString * cycle;
@property (nonatomic, retain) NSNumber * downloadingSortID;
@property (nonatomic, retain) NSNumber * downloadProgress;
@property (nonatomic, retain) NSNumber * downloadStatus;
@property (nonatomic, retain) NSString * downloadURL;
@property (nonatomic, retain) NSNumber * dreamBookPage;
@property (nonatomic, retain) NSNumber * dreamBookScene;
@property (nonatomic, retain) NSString * epubVersion;
@property (nonatomic, retain) NSNumber * expiringDate;
@property (nonatomic, retain) NSString * expiringMessage;
@property (nonatomic, retain) NSString * fatherFolder;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSNumber * isBook;
@property (nonatomic, retain) NSNumber * isDownloaded;
@property (nonatomic, retain) NSNumber * isFolder;
@property (nonatomic, retain) NSNumber * isInCloud;
@property (nonatomic, retain) NSNumber * isPageParsed;
@property (nonatomic, retain) NSNumber * isReaded;
@property (nonatomic, retain) NSNumber * isSdFile;
@property (nonatomic, retain) NSString * issueString;
@property (nonatomic, retain) NSNumber * itemIndex;
@property (nonatomic, retain) NSDate * lastOperateDate;
@property (nonatomic, retain) NSNumber * lastReadCID;
@property (nonatomic, retain) NSNumber * lastReadPosition;
@property (nonatomic, retain) NSString * ncxPath;
@property (nonatomic, retain) NSString * opsPath;
@property (nonatomic, retain) id pageCounts;
@property (nonatomic, retain) NSString * publishName;
@property (nonatomic, retain) NSNumber * readProgress;
@property (nonatomic, retain) NSString * smallCover;
@property (nonatomic, retain) NSNumber * sortID;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * unitDomain;
@property (nonatomic, retain) NSString * unitName;
@property (nonatomic, retain) NSNumber * usedFontSizeScale;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * fileSize;

-(void) show;

@end
