//
//  FriendModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface FriendModel : BaseModel

/* 好友 */

/* 好友id */
@property (assign, nonatomic) NSInteger friendId;
/* 好友头像 */
@property (strong, nonatomic) NSString *friendPic;
/* 好友名 */
@property (strong, nonatomic) NSString *friendName;

@end
