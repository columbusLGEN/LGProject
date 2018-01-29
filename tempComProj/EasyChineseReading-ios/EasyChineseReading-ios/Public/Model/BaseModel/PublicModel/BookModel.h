//
//  BookModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//
/** 书籍类型
 1 pdf
 2 epub
 3 超媒体
 */
typedef NS_ENUM(NSUInteger, BookModelBookFormat) {
    BookModelBookFormatPDF = 1,
    BookModelBookFormatEPUB,
    BookModelBookFormatHYPER,
};

/**
 0:未拥有 -- 即为试读
 1:购买
 2:租赁
 3:授权
 4:阅读卡
 */
typedef NS_ENUM(NSUInteger, BookModelOwnedType) {
    BookModelOwnedTypeNotOwned,
    BookModelOwnedTypeOwned,
    BookModelOwnedTypeRent,
    BookModelOwnedTypeAccess,
    BookModelOwnedTypeRearCard
};

#import "BaseModel.h"
@class MyBook;

@interface BookModel : BaseModel
/** 图书id */
@property (assign, nonatomic) NSInteger bookId;
/** 封面 */
@property (copy,   nonatomic) NSString *iconUrl;
/** 书名 */
@property (copy,   nonatomic) NSString *bookName;
/** 书名(en) */
@property (copy,   nonatomic) NSString *en_bookName;
/** 作者 */
@property (copy,   nonatomic) NSString *author;
/** 作者(en) */
@property (copy,   nonatomic) NSString *en_author;
/** 简介 */
@property (strong, nonatomic) NSString *contentValidity;
@property (copy,   nonatomic) NSString *en_contentValidity;
/** 评分（总评分） */
@property (assign, nonatomic) CGFloat score;
/** 价格 */
@property (assign, nonatomic) CGFloat price;
/** 图书租赁价格 */
@property (strong, nonatomic) NSString *rent;
/** 作者简介 */
@property (strong, nonatomic) NSString *authorSynopsis;
/** 目录 */
@property (strong, nonatomic) NSString *catalog;
@property (copy  , nonatomic) NSString *en_catalog;
/** 国际标准书号 */
@property (strong, nonatomic) NSString *isbn;
/** ？*/
@property (strong, nonatomic) NSString *eisbn;
/** 出版社 */
@property (strong, nonatomic) NSString *press;
@property (copy  , nonatomic) NSString *en_press;
/** 出版时间 */
@property (strong, nonatomic) NSString *publicationTime;
/** 图书总页数 */
@property (assign, nonatomic) NSInteger totalPageNumber;
/** 适用年龄 */
@property (assign, nonatomic) NSInteger applicableAge;
/** 图书等级 */
@property (strong, nonatomic) NSString *bookLevel;
/** 所属分类 */
@property (strong, nonatomic) NSString *classify;
/** 收藏人气 */
@property (assign, nonatomic) NSInteger favoriteNum;
/** 收藏时间 */
@property (strong, nonatomic) NSString *date;
/** 是否购买 */
@property (assign, nonatomic) NSInteger type;
/** 我的评分 */
@property (assign, nonatomic) NSInteger userScore;
/** 书籍订单明细ID */
@property (assign, nonatomic) NSInteger orderDetailId;
/** 阅读进度 */
@property (assign, nonatomic) CGFloat read_progress;
/** 授权开始时间 */
@property (strong, nonatomic) NSString *startTime;
/** 授权截止时间 */
@property (strong, nonatomic) NSString *endTime;
/** 满减类型 */
@property (assign, nonatomic) NSInteger fullminusType;
/** 拥有表中的id */
@property (assign, nonatomic) NSInteger ownId;

/**
 PDF   = 1,
 EPUB  = 2,
 HYPER = 3,
 */
@property (assign,nonatomic) BookModelBookFormat eBookFormat;

/** 书籍所属系列id */
@property (assign,nonatomic) NSInteger serialId;


/**
 0:未拥有 -- 即为试读
 1:购买
 2:租赁
 3:授权
 4:阅读卡
 */
@property (assign,nonatomic) BookModelOwnedType owendType;
/**正式的下载链接*/
@property (copy,nonatomic) NSString *locationUrl;
/**试读版本下载链接*/
@property (copy,nonatomic) NSString *academicProbationUrl;

/**
 0:未收藏
 1:已收藏
 */
@property (assign,nonatomic) BOOL collectionType;
/** 简介 */
@property (copy,  nonatomic) NSString *synopsis;
/** 价格 */
@property (assign,nonatomic) CGFloat   money;

/** 试读文件大小 */
@property (assign,nonatomic) long long academicsize;
/** 正式文件大小 */
@property (assign,nonatomic) long long locationsize;

#pragma mark - 本地属性

/** 选中状态 */
@property (assign, nonatomic) BOOL isSelected;
/** isTick 商品是否被勾选. 1:勾选, 0未勾选 */
@property (assign, nonatomic) BOOL isTick;
/**下载链接*/
@property (copy,  nonatomic) NSString *downloadURL;/// client
/** epubBookKit 模型 */
@property (strong,nonatomic) MyBook *ymeBook;//
/** epubBookKit 索引 */
@property (assign,nonatomic) NSInteger ymeBookIndex;//
/** 书籍资源文件本地存储链接 */
@property (copy,  nonatomic) NSString *localURL;//绝对路径
/** 本地epub 加密文件路径 */
@property (copy,nonatomic) NSString *localEpubEncodePath;
/** 书籍资源文件相对路径 */
@property (copy,  nonatomic) NSString *localIdentify;//相对路径
/** 书籍资源文件临时下载路径 */
@property (copy,nonatomic) NSString *tempLocalURL;
/** 登录用户id */
@property (assign,nonatomic) NSInteger userId;//

BOOL modelTry(NSInteger oweType);// 判断是否试读

@end
