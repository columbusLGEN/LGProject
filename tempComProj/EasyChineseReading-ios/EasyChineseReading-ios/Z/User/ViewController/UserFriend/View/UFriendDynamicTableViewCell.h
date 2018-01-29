//
//  UFriendDynamicNewTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"


@class UFriendDynamicTableViewCell;

@protocol UFriendDynamicTableViewCellDelegate <NSObject>

- (void)toBookDetailWithBookId:(NSInteger)bookId;
- (void)toFriendInfoWithFriend:(FriendModel *)friendInfo;

@end

@interface UFriendDynamicTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UFriendDynamicTableViewCellDelegate> delegate;

@end
