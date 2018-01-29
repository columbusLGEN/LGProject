//
//  UFriendReadNewTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@class UFriendReadTableViewCell;

@protocol UFriendReadTableViewCellDelegate<NSObject>

- (void)toFriendInfoWithFriend:(FriendModel *)friendInfo;

@end

@interface UFriendReadTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UFriendReadTableViewCellDelegate> delegate;

@end
