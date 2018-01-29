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

/** 消息id */
@property (assign, nonatomic) NSInteger messagesId;
/** 消息创建时间 */
@property (strong, nonatomic) NSString *emailCreatedTime;
/** 消息类型 */
@property (assign, nonatomic) ENUM_MessageType messageType;
/** 消息来源 id */
@property (assign, nonatomic) NSInteger source;
/** 类型（0 未读 1已读） */
@property (assign, nonatomic) ENUM_MessageReadType type;
/** 消息内容 */
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *en_message;
/** 发送者昵称 */
@property (strong, nonatomic) NSString *name;
/** 自己的 id */
@property (strong, nonatomic) NSString *recommendedId;
/** 图片 */
@property (strong, nonatomic) NSString *iconUrl;
@property (strong, nonatomic) NSString *templetimg; 
/** 分享的话 */
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *en_title;
/** 活动链接 */
@property (strong, nonatomic) NSString *url;
/** 接受消息的用户 */
@property (strong, nonatomic) NSArray *users;
/** 专题id */
@property (strong, nonatomic) NSString *themeid;

@end
