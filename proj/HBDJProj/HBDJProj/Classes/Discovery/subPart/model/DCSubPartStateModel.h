//
//  DCSubPartStateModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 支部动态模型

//#import "LGBaseModel.h"
#import "DJDataBaseModel.h"

@class DCSubPartStateCommentModel;

@interface DCSubPartStateModel : DJDataBaseModel

/** 标题 */
//@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSArray<DCSubPartStateCommentModel *> *frontComments;

///** 点赞id */
//@property (assign,nonatomic) NSInteger praiseid;
///** 点赞数 */
//@property (assign,nonatomic) NSInteger praisecount;
///** 收藏id */
//@property (assign,nonatomic) NSInteger collectionid;
///** 收藏数 */
//@property (assign,nonatomic) NSInteger collectioncount;
//
///** 富文本字符串 */
//@property (strong,nonatomic) NSString *content;
///** 2018-03-20 13:57:18 */
//@property (strong,nonatomic) NSString *createdtime;
/** ???查看次数??? */
@property (assign,nonatomic) NSInteger viewcount;
//"creatorid":1,
//"branchstatus":"1",
//"sort":1,
//"mechanismid":"180607092010002",
//"status":1

@property (assign,nonatomic) NSInteger imgCount;
@property (strong,nonatomic) NSArray *imgUrls;

@property (assign,nonatomic) CGFloat cellHeight;
/** 时间戳 */
@property (strong,nonatomic) NSString *timestamp;


@end
