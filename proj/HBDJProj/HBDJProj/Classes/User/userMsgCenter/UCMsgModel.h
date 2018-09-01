//
//  UCMsgModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, UCMsgModelResourceType) {
    /** 三会一课 */
    UCMsgModelResourceTypeThreeMeetings,
    /** 主题党日 */
    UCMsgModelResourceTypeThemeDay,
    /** 在线投票 */
    UCMsgModelResourceTypeVote,
    /** 知识测试 */
    UCMsgModelResourceTypeTest,
    /** 系统消息 */
    UCMsgModelResourceTypeSystem
};

@interface UCMsgModel : LGBaseModel
@property (assign,nonatomic) BOOL isEdit;
@property (assign,nonatomic) BOOL select;

/** 消息内容 */
@property (strong,nonatomic) NSString *content;
/** 是否已读 */
@property (assign,nonatomic) BOOL isread;
/** 1三会一课 2主题党日 3在线投票 4知识测试 5系统消息 */
@property (assign,nonatomic) NSInteger noticetype;
/** 源id */
@property (assign,nonatomic) NSInteger resourceid;

@property (assign,nonatomic) BOOL showAll;
@property (strong,nonatomic) NSIndexPath *indexPath;

@end
