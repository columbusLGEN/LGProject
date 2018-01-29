//
//  ULeaseTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserLeaseTableViewCell;

@protocol UserLeaseTableViewCellDelegate <NSObject>

- (void)continueLeaseWithSerial:(SerialModel *)serial;

@end

@interface UserLeaseTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UserLeaseTableViewCellDelegate> delegate;
@property (copy, nonatomic) void (^toSerialBooksListView)();

@end
