//
//  RecommendModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface RecommendModel : BaseModel

/**
 推荐
 */

@property (strong, nonatomic) NSString *content;        // 分享内容
@property (strong, nonatomic) NSString *createTime;     // 创建时间
@property (assign, nonatomic) NSInteger bookNum;        // 书籍数量
@property (assign, nonatomic) NSInteger userId;         // 创建推荐的用户 id
@property (assign, nonatomic) NSInteger shareBatchId;   // 推荐 id

@property (strong, nonatomic) NSArray *recommendBooks; // 推荐的书籍
@property (strong, nonatomic) NSArray *recommendUsers; // 推荐的用户

@end
