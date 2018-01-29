//
//  UCStudentListTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCStudentListTableViewCell : ECRBaseTableViewCell

@property (copy, nonatomic) void (^deleteSelectedUser)(UserModel *user); // 删除
@property (copy, nonatomic) void (^updateSelectedUser)(UserModel *user); // 更新

@property (assign, nonatomic) NSInteger index; 

@end
