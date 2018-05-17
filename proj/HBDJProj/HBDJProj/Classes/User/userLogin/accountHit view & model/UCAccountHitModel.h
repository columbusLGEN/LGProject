//
//  UCAccountHitModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, AccountHitLineType) {
    AccountHitLineTypePN,/// phone number
    AccountHitLineTypeOpwd,/// origin pwd
    AccountHitLineTypeNpwd,/// new pwd
    AccountHitLineTypeCpwd/// confirm pwd
};

@interface UCAccountHitModel : LGBaseModel

@property (assign,nonatomic) AccountHitLineType lineType;
@property (strong,nonatomic) NSString *iconName;
@property (strong,nonatomic) NSString *placeholder;
/** 接收用户输入的值 */
@property (strong,nonatomic) NSString *lineValue;

@end
