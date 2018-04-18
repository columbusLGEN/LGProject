//
//  UCSettingModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface UCSettingModel : LGBaseModel

@property (copy,nonatomic) NSString *itemName;
@property (assign,nonatomic) NSInteger contentType;
@property (copy,nonatomic) NSString *content;

@end
