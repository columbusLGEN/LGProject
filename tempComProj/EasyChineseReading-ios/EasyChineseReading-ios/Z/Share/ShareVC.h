//
//  ShareVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/31.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface ShareVC : ECRBaseViewController

@property (strong, nonatomic) BookModel *book;
@property (assign, nonatomic) ENUM_ShareType shareType; // 分享的类型 (0好友 1动态)

@property (copy, nonatomic) void(^shareToFriendWithBook)(BookModel *book); // 分享到好友


@end
