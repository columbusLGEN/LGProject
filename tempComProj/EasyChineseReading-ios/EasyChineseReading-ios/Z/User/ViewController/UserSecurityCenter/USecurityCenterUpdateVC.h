//
//  USCUpdateVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface USecurityCenterUpdateVC : ECRBaseViewController

/** 修改类型 */
@property (assign, nonatomic) ENUM_ZUserSecurityCenterUpdateMethod securityCenterUpdateType;
@property (assign, nonatomic) NSInteger userId; // 用户 id
@property (assign, nonatomic) ENUM_AccountType accountType; // 账号类型
@property (strong, nonatomic) NSString *account;  // 账号（忘记密码）
@property (strong, nonatomic) NSString *areacode; // 国家码
@end
