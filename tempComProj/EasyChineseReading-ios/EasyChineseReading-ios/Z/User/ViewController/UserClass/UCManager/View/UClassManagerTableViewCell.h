//
//  UClassManagerTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UClassManagerTableViewCell;

@interface UClassManagerTableViewCell : ECRBaseTableViewCell

@property (copy, nonatomic) void (^deleteClass)(ClassModel *); // 删除
@property (copy, nonatomic) void (^updateClass)(ClassModel *); // 更新

@property (assign, nonatomic) NSInteger index;

@end
