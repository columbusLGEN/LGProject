//
//  TCSchoolBookTableViewController.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TCListType) {
    /// 数字教材
    TCListTypeDigitalTextbook,
    /// 电子图书
    TCListTypeEBook
};

@interface TCSchoolBookTableViewController : LGTableViewController
/** 第一个cell 是否隐藏分割线 */
@property (assign,nonatomic) BOOL firstCellHiddenLine;

@property (assign,nonatomic) TCListType listType;

@end

NS_ASSUME_NONNULL_END
