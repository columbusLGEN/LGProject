//
//  DCSubPartStateModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 支部动态模型

#import "DJUcMyCollectBranchModel.h"

@interface DCSubPartStateModel : DJUcMyCollectBranchModel

/** ???查看次数??? */
@property (assign,nonatomic) NSInteger viewcount;

@property (assign,nonatomic) NSInteger imgCount;
@property (strong,nonatomic) NSArray *imgUrls;

@property (assign,nonatomic) CGFloat cellHeight;


@end
