//
//  DJOnlineUplaodTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

@interface DJOnlineUplaodTableViewController : LGBaseTableViewController

/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath;

/// MARK: 给子类继承实现
- (void)setCoverFormDataWithUrl:(NSString *)url;
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls;

@end
