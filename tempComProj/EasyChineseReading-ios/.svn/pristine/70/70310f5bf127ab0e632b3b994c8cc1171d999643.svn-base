//
//  UMessageTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMessageTableViewCell;

@protocol UMessageTableViewCellDelegate <NSObject>

- (void)seeUserInfoWithUser:(UserModel *)user;

@end

@interface UMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) id<UMessageTableViewCellDelegate> delegate;
- (void)updateReadType:(ENUM_MessageReadType)type;

@end
