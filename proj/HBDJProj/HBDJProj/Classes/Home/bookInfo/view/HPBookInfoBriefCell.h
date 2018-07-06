//
//  HPBookInfoBriefCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoBaseCell.h"

static NSString * const bookinfoBriefCell = @"HPBookInfoBriefCell";

@interface HPBookInfoBriefCell : HPBookInfoBaseCell
@property (strong,nonatomic) HPBookInfoModel *model;
+ (instancetype)bookinfoBreifCell;

@end
