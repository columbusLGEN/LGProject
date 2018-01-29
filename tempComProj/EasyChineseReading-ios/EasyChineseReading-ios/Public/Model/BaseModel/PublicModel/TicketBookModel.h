//
//  TicketBookModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/23.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface TicketBookModel : BaseModel

@property (strong, nonatomic) NSString *startTime;    // 开始时间
@property (strong, nonatomic) NSString *activatecode; // 兑换券
@property (assign, nonatomic) NSInteger activateuser; // 兑换用户
@property (assign, nonatomic) NSInteger grantbatchId; // 批次 id
@property (strong, nonatomic) NSString *endTime;      // 截止时间
@property (strong, nonatomic) NSString *bookids;      // 图书 id
@property (strong, nonatomic) NSArray  *books;        // 图书

@end
