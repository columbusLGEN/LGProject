//
//  USPhoneTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@interface USPhoneTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtfAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtfAreacode;
@property (copy, nonatomic) void (^selectedAreacode)();

/** 是否可变 */
@property (assign, nonatomic) BOOL isUpdated;

- (void)updateAreacodeWithAreacode:(NSString *)areacode;

@end
