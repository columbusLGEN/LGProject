//
//  LPhoneTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@interface LPhoneTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) IBOutlet ZTextField *txtfAreaCode;
@property (weak, nonatomic) IBOutlet ZTextField *txtfAccount;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (assign, nonatomic) BOOL cantSelected; 
@property (copy, nonatomic) void (^selectedAreacode)();

- (void)updateAreacodeWithAreacode:(NSString *)areacode;

@end
