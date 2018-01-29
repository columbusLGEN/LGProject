//
//  DynamicModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface DynamicModel : BaseModel

/* 动态 */

/** 发布动态时间 */
@property (strong, nonatomic) NSString *createTime;
/** 已读书籍 */
@property (assign, nonatomic) NSInteger readHave;
/** 阅读总时间 */
@property (assign, nonatomic) NSInteger readTime;
/** 图书 id */
@property (assign, nonatomic) NSInteger bookId;
/** 封面 */
@property (strong, nonatomic) NSString *iconUrl;
/** 简介 */
@property (strong, nonatomic) NSString *contentValidity;
/** 英文简介 */
@property (strong, nonatomic) NSString *en_contentValidity;
/** 好友名 */
@property (strong, nonatomic) NSString *friendName;
/** 评分 */
@property (assign, nonatomic) CGFloat score;
/** 价格 */
@property (assign, nonatomic) CGFloat price;
/** 阅读字数 */
@property (assign, nonatomic) NSInteger sameDayWord;
/** 总阅读字数 */
@property (assign, nonatomic) NSInteger wordCount; 
/** 作者 */
@property (strong, nonatomic) NSString *author;
/** 英文作者名 */
@property (strong, nonatomic) NSString *en_author;
/** 好友头像 */
@property (strong, nonatomic) NSString *friendIconUrl;
/** 书名 */
@property (strong, nonatomic) NSString *bookName;
/** 英文书名 */
@property (strong, nonatomic) NSString *en_bookName;
/** 分享说明 */
@property (strong, nonatomic) NSString *shareTitle;
/** 好友 id */
@property (assign, nonatomic) NSInteger userId;
/** 战胜了多少好友 */
@property (assign, nonatomic) NSInteger ranking;

/** 阅读完多少书籍 */
@property (assign, nonatomic) NSInteger readThrough;


@end
