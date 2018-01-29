//
//  UFriendReadPadTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/7.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@class UFriendReadPadTableViewCell;

@protocol UFriendReadPadTableViewCellDelegate<NSObject>

- (void)toFriendInfoWithFriend:(FriendModel *)friendInfo;

@end

@interface UFriendReadPadTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UFriendReadPadTableViewCellDelegate> delegate; 

@end
