//
//  ECRMoreRowModel.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECRClassSortModel;

@interface ECRMoreRowModel : NSObject

@property (strong,nonatomic) NSIndexPath *indexPath;//
@property (strong,nonatomic) NSMutableArray<ECRClassSortModel *> *classArray;//

@end
