//
//  HPBookInfoBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class HPBookInfoModel;

@interface HPBookInfoBaseCell : LGBaseTableViewCell
@property (strong,nonatomic) HPBookInfoModel *model;

@end
