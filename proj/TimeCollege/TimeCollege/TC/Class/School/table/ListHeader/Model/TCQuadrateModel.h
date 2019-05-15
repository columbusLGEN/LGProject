//
//  TCQuadrateModel.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TCBookCatagoryLineModel;

@interface TCQuadrateModel : TCBaseModel
/** 分类标题 */
@property (strong,nonatomic) NSString *title;
/** 二级分类 */
@property (strong,nonatomic) NSArray<TCQuadrateModel *> *secondaryCata;
/** 是否选中 */
@property (assign,nonatomic) BOOL seleted;

@property (strong,nonatomic) TCBookCatagoryLineModel *lineModel;

@end

NS_ASSUME_NONNULL_END
