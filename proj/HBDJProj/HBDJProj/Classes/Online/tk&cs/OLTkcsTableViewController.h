//
//  OLTkcsTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

typedef NS_ENUM(NSUInteger, OLTkcsType) {
    OLTkcsTypetk,
    OLTkcsTypecs,
};

@interface OLTkcsTableViewController : LGBaseTableViewController
@property (assign,nonatomic) OLTkcsType tkcsType;

@end
