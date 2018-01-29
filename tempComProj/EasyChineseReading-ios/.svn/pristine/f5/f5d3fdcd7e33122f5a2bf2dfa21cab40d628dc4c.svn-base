//
//  OrderTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserOrderTableViewCell;

@protocol UserOrderTableViewCellDelegate <NSObject>

- (void)toBookDetailWithBook:(BookModel *)book;
- (void)readBookWithBook:(BookModel *)book;

@end

@interface UserOrderTableViewCell : ECRBaseTableViewCell

/* cell 编号 */
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id<UserOrderTableViewCellDelegate> delegate;

@end
