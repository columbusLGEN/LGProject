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

/// 暴露出来，以便cell修改表单数据
@property (strong,nonatomic) NSMutableDictionary *formDataDict;

@end
