//
//  ImpowerModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface ImpowerModel : BaseModel

/**
 授权
 */

@property (strong, nonatomic) NSString *content;        // 分享内容
@property (assign, nonatomic) NSInteger bookNum;        // 书籍数量
@property (assign, nonatomic) NSInteger userId;         // 创建授权的用户 id
@property (assign, nonatomic) NSInteger grantbatchId;   // 授权 id
@property (strong, nonatomic) NSString *createTime;     // 创建时间
@property (strong, nonatomic) NSString *startTime;      // 开始时间
@property (strong, nonatomic) NSString *endTime;        // 结束时间

@property (strong, nonatomic) NSArray *impowerBooks; // 授权的书籍
@property (strong, nonatomic) NSArray *impowerUsers; // 授权的用户

@end
