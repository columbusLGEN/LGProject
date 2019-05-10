//
//  TCSearchViewController.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/8.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
//TCBookListRequestTypeSearch_bookrack,    /// 搜索 我的书橱
//TCBookListRequestTypeSearch_school,      /// 搜索 学校书橱
//TCBookListRequestTypeDigital,            /// 数字教材
//TCBookListRequestTypeEBook               /// 电子图书

@interface TCSearchViewController : LGBaseViewController
/** 值参照 TCBookListRequestType
 0 搜索 我的书橱
 1 搜索 学校书橱
 2 数字教材
 3 电子图书
 */
@property (assign,nonatomic) NSInteger blrType;

@end

NS_ASSUME_NONNULL_END
