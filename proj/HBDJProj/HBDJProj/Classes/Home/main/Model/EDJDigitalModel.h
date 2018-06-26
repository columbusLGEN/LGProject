//
//  EDJDigitalModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// MARK: 数字阅读模型
#import "LGBaseModel.h"

@interface EDJDigitalModel : LGBaseModel

/** 书名 */
@property (strong,nonatomic) NSString *ebookname;
/** publisher */
@property (strong,nonatomic) NSString *publisher;
/** introduction */
@property (strong,nonatomic) NSString *introduction;
/** author */
@property (strong,nonatomic) NSString *author;
/** creatorid */
@property (assign,nonatomic) NSInteger creatorid;
/** ebookstatus */
@property (assign,nonatomic) NSInteger ebookstatus;
/** status */
@property (assign,nonatomic) NSInteger status;
/** 目录 */
@property (strong,nonatomic) NSString *catalog;
/** 出版日期 */
@property (strong,nonatomic) NSString *pubdate;
/** createdtime */
@property (strong,nonatomic) NSString *createdtime;
/** ebookresource */
@property (strong,nonatomic) NSString *ebookresource;
/** 本地资源文件存储路径 */
@property (strong,nonatomic) NSString *localUrl;
/** 阅读进度 */
@property (assign,nonatomic) CGFloat progress;
/** 设置在页面上的进度值 */
@property (strong,nonatomic) NSString *progressForUI;


@end
