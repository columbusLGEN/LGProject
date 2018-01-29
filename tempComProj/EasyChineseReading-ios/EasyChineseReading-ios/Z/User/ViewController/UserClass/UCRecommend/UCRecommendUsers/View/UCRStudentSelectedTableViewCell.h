//
//  UCRStudentSelectedTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCRStudentSelectedTableViewCell;

@protocol UCRStudentSelectedTableViewCellDelegate <NSObject>

- (void)removeSelectedStudent:(id)student;

@end

@interface UCRStudentSelectedTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<UCRStudentSelectedTableViewCellDelegate> delegate;

@end
