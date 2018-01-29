//
//  ECRBookClassSortHeader.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseTableViewHeaderFooterView.h"
@class ECRBookClassSortHeader,ECRMoreRowModel,ECRSortTableViewController;

@protocol ECRBookClassSortHeaderDelegate <NSObject>

@optional
- (void)bcsHeader:(ECRBookClassSortHeader *)header tag:(NSInteger)tag;// 0销量,1价格,2好评论

/**

 @param header self
 @param tag 0销量,1价格,2好评论,-1 默认
 @param isDesOrder 1 降序, 0 升序
 */
- (void)bcsHeader:(ECRBookClassSortHeader *)header tag:(NSInteger)tag isDesOrder:(BOOL)isDesOrder;

@end

@interface ECRBookClassSortHeader : ECRBaseTableViewHeaderFooterView

/** 行模型 */
@property (strong,nonatomic) NSArray<ECRMoreRowModel *> *rowModels;
@property (weak,nonatomic) id<ECRBookClassSortHeaderDelegate> delegate;
@property (strong,nonatomic) ECRSortTableViewController *stvc;
/** YES = 没有数据 */
@property (assign,nonatomic) BOOL noFilterData;

@end
