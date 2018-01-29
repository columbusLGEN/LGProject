//
//  UserOrderFooterTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@class UserOrderFooterTableViewCell;

@protocol UserOrderFooterTableViewCellDelegate <NSObject>

/** 删除订单 */
- (void)deleteOrderWithOrder:(OrderModel *)order;
/** 取消订单 */
- (void)cancelOrderWithOrder:(OrderModel *)order;
/** 立即支付 */
- (void)payOrderWithOrder:(OrderModel *)order;
/** 评价订单 */
- (void)evaluateWithOrder:(OrderModel *)order;
/** 展示全部的书籍 */
- (void)showAllBooksWithOrder:(OrderModel *)order;

@end

@interface UserOrderFooterTableViewCell : ECRBaseTableViewCell

/* 判断是否详情界面 */
@property (assign, nonatomic) BOOL isDetailFooter;
@property (weak, nonatomic) id<UserOrderFooterTableViewCellDelegate> delegate;

@end
