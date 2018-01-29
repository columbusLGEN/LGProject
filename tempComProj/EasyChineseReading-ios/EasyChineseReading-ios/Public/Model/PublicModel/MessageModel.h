//
//  MessageModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

/* 消息 */

/* 消息id */
@property (assign, nonatomic) NSInteger messageId;
/* 消息内容 */
@property (strong, nonatomic) NSString *messages;
/* 消息来源 */
@property (strong, nonatomic) NSString *source;
/* 类型（已读/未读） */
@property (assign, nonatomic) NSInteger type;

@end
