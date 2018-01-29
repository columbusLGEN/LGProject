//
//  ECRSeriesModel.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECRHomeBook,ECRClassSortModel;

@interface ECRSeriesModel : NSObject

@property (assign,nonatomic) NSInteger serialId;//
@property (strong,nonatomic) NSArray<ECRHomeBook *> *books;//
@property (copy,nonatomic) NSString *en_serialUrl;//
@property (copy,nonatomic) NSString *serialUrl;//
@property (copy,nonatomic) NSString *serialName;//
@property (copy,nonatomic) NSString *en_serialName;//

@property (strong,nonatomic) ECRClassSortModel *parent;//

@end
