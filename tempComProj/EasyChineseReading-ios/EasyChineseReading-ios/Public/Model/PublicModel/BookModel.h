//
//  BookModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface BookModel : BaseModel

/**
 图书
 */

/*  图书id */
@property (assign, nonatomic) NSInteger bookid;
/*  封面 */
@property (strong, nonatomic) NSString *coverPhoto;
/*  书名 */
@property (strong, nonatomic) NSString *bookName;
/*  作者 */
@property (strong, nonatomic) NSString *author;
/*  简介 */
@property (strong, nonatomic) NSString *synopsis;
/*  评分（总评分） */
@property (assign, nonatomic) double score;
/*  价格 */
@property (assign, nonatomic) float money;

/*  图书租赁价格 */
@property (strong, nonatomic) NSString *rent;
/*  作者简介 */
@property (strong, nonatomic) NSString *authorSynopsis;
/*  目录 */
@property (strong, nonatomic) NSString *catalog;
/*  编辑推荐 */
@property (strong, nonatomic) NSString *recommend;
/*  国际标准书号 */
@property (strong, nonatomic) NSString *isbn;
/*  ？ */
@property (strong, nonatomic) NSString *eisbn;
/*  出版社 */
@property (strong, nonatomic) NSString *press;
/*  出版时间 */
@property (strong, nonatomic) NSString *publicationTime;
/*  图书总页数 */
@property (assign, nonatomic) NSInteger totalPageNumber;
/*  适用年龄 */
@property (assign, nonatomic) NSInteger applicableAge;
/*  图书等级 */
@property (strong, nonatomic) NSString *bookLevel;
/*  所属分类 */
@property (strong, nonatomic) NSString *classify;

/*  收藏人气 */
@property (assign, nonatomic) NSInteger hot;
/*  收藏时间 */
@property (strong, nonatomic) NSString *date;
/*  是否购买 */
@property (assign, nonatomic) NSInteger type;

/*  我的评分 */
@property (assign, nonatomic) NSInteger userScore;

@end
