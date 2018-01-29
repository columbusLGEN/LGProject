//
//  PayTypeModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/7.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface PayTypeModel : BaseModel

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *payType;    // 中文名
@property (strong, nonatomic) NSString *en_paytype; // 英文名
@property (strong, nonatomic) NSString *isdisplay;  // 是否展示

@end
