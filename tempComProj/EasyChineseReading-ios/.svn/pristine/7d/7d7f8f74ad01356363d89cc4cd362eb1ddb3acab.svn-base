//
//  UTaskTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTaskTableViewCell;

@protocol UTaskTableViewCellDelegate<NSObject>

- (void)getTaskAwardWithTask:(TaskModel *)task index:(NSInteger)index;

@end

@interface UTaskTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnGetIntegral;        // 领取积分(完成任务)

@property (weak, nonatomic) id<UTaskTableViewCellDelegate> delegate;  // 代理

@property (assign, nonatomic) BOOL isSelected;                          // 领取过奖励
@property (assign, nonatomic) NSInteger selectedIndex;                  // 选中cell 的 index

@end
