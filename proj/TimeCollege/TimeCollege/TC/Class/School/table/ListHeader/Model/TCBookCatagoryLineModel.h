//
//  TCBookCatagoryLineModel.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TCQuadrateModel;

@interface TCBookCatagoryLineModel : TCBaseModel
@property (strong,nonatomic) NSString *itemName;
@property (strong,nonatomic) NSArray<TCQuadrateModel *> *bookCata;
/** 是否为二级分类 */
@property (assign,nonatomic) BOOL isSecondery;
/** 是否 展示 二级分类 */
@property (assign,nonatomic) BOOL showSeconndery;

// -----
/** 是否给分类对象指定 lineModel */
@property (assign,nonatomic) BOOL lineAssign;

@end

NS_ASSUME_NONNULL_END
