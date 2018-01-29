//
//  UFriendListNewTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@class UFriendListTableViewCell;

@protocol UFriendListTableViewCellDelegate <NSObject>

- (void)addFriendWithFriend:(FriendModel *)user;
- (void)delFriendWithFriend:(FriendModel *)user;
- (void)toFriendInfoWithFriend:(FriendModel *)user;

@end

@interface UFriendListTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UFriendListTableViewCellDelegate> delegate;

@end
