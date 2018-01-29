//
//  UFriendAddTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UFriendAddTableViewCell;

@protocol UFriendAddTableViewCellDelegate <NSObject>

- (void)addFriendWithFriend:(FriendModel *)user;
- (void)delFriendWithFriend:(FriendModel *)user;
- (void)toFriendInfoWithFriend:(FriendModel *)user;

@end

@interface UFriendAddTableViewCell : UITableViewCell

@property (weak, nonatomic) id<UFriendAddTableViewCellDelegate> delegate;

@end
