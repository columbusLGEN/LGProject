//
//  ECRClassSortModel.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseModel.h"

@interface ECRClassSortModel : ECRBaseModel

@property (assign,nonatomic) NSInteger id;//
@property (assign,nonatomic) NSInteger parentId;//
@property (copy,nonatomic) NSString *name;//
@property (copy,nonatomic) NSString *en_name;//
@property (assign,nonatomic) NSInteger type;// 1：分类，2：系列

@property (copy,nonatomic) NSString *btnTitle;
@property (strong,nonatomic) NSNumber *classType;
@property (assign,nonatomic) BOOL lg_isSwitch;// 是否具有切换分类功能,1:有,0:无
@property (assign,nonatomic) BOOL lg_isSelected;// 1: 选中, 0未选中

+ (instancetype)defaultModel;

@end
