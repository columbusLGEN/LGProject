//
//  OLExamCollectionViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseCollectionViewCell.h"
@class OLExamSingleModel;

@interface OLExamCollectionViewCell : LGBaseCollectionViewCell
@property (strong,nonatomic) OLExamSingleModel *model;

@end
