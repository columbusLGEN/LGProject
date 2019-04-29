//
//  TCBookDetailManagerController.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCBookDetailManagerController : LGBaseViewController
/**
 电子图书 - eBook == 1
 数字教材 - digTextBook == 2
 */
@property (assign,nonatomic) NSInteger detailType;

@end

NS_ASSUME_NONNULL_END
