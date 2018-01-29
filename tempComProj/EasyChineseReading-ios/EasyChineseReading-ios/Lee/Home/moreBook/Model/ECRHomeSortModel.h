//
//  ECRHomeSortModel.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseModel.h"

@class ECRClassSortModel;

@interface ECRHomeSortModel : ECRBaseModel

@property (strong,nonatomic) NSArray<ECRClassSortModel *> *classModelArray;

@end
