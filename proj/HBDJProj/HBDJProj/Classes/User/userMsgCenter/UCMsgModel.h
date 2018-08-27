//
//  UCMsgModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface UCMsgModel : LGBaseModel
@property (strong,nonatomic) NSString *content;
@property (assign,nonatomic) BOOL isEdit;
@property (assign,nonatomic) BOOL select;

@end
