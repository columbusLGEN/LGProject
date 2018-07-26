//
//  OLTkcsTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

/** 列表类型 */
typedef NS_ENUM(NSUInteger, OLTkcsType) {
    /** 题库 */
    OLTkcsTypetk,
    /** 测试 */
    OLTkcsTypecs,
};

@interface OLTkcsTableViewController : LGBaseTableViewController
@property (assign,nonatomic) OLTkcsType tkcsType;

@end
