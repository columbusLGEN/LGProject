//
//  UCPersonInfoModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface UCPersonInfoModel : LGBaseModel

@property (copy,nonatomic) NSString *iconUrl;
@property (copy,nonatomic) NSString *itemName;// e.g.: 身份证号
@property (copy,nonatomic) NSString *content;// e.g.: 1xxxxxxxxxx
@property (assign,nonatomic) BOOL canChangePwd;

@end
