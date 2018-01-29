//
//  UFavouriteTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UFavouriteTableViewCell;

@protocol UFavouriteTableViewCellDelegate <NSObject>

/**
 添加到购物车

 @param book 图书
 */
- (void)addToShopCarWithBook:(BookModel *)book;


/**
 分享图书

 @param book 图书
 */
- (void)shareWithBook:(BookModel *)book;

@end

@interface UFavouriteTableViewCell : ECRBaseTableViewCell

/** 代理 */
@property (weak, nonatomic) id<UFavouriteTableViewCellDelegate> delegate;
/** 是否选中 */
@property (assign, nonatomic) BOOL isSelected;

@property (assign, nonatomic) NSInteger index; 

@end
