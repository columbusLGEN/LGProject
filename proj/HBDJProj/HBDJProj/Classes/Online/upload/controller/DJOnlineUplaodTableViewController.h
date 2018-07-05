//
//  DJOnlineUplaodTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

@interface DJOnlineUplaodTableViewController : LGBaseTableViewController

- (instancetype)initWithListType:(OnlineModelType)listType;

/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath;

@end
