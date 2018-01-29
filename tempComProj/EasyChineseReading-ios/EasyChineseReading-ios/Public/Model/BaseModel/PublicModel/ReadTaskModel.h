//
//  ReadTaskModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface ReadTaskModel : BaseModel

@property (strong, nonatomic) NSString *startTime;      // 授权开始时间
@property (strong, nonatomic) NSString *endTime;        // 授权结束时间
@property (strong, nonatomic) NSString *createTime;     // 创建时间

@property (assign, nonatomic) NSInteger recommendId;    // 推荐 id
@property (strong, nonatomic) NSString *content;        // 推荐说明

@property (assign, nonatomic) NSInteger grantbatchId;       //  授权 id
@property (strong, nonatomic) NSString *grantbatchContent;  //  授权说明

@property (assign, nonatomic) ENUM_RecommendType type;   // 类型 0 推荐 1 授权
@property (assign, nonatomic) NSInteger bookNum;    // 书本数量

@end
