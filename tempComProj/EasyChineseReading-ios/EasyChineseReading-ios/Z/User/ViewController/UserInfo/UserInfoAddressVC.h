//
//  UInfoAddressViewController.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UserInfoAddressVC : ECRBaseViewController

/** 选择国家 */
@property (copy, nonatomic) void(^selectedCountryBlock)(CountryModel *);

/** 语言 */
@property (assign, nonatomic) NSInteger language;

@property (assign, nonatomic) NSInteger country;

@end
