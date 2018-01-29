//
//  ECRShoppingCarCell.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRShoppingCarModel,ECRShoppingCarCell;

@protocol ECRShoppingCarCellDelegate <NSObject>

// 点击单个商品选择按钮
- (void)scCell:(ECRShoppingCarCell *)cell selectProduct:(ECRShoppingCarModel *)model;
// 点击商品(查看商品详情)
- (void)scCell:(ECRShoppingCarCell *)cell clickProduct:(ECRShoppingCarModel *)model;
// 删除商品

// 商品的增加删除

@end

@interface ECRShoppingCarCell : UITableViewCell

@property (strong,nonatomic) ECRShoppingCarModel *model;
@property (weak,nonatomic) id<ECRShoppingCarCellDelegate> delegate;

@end
