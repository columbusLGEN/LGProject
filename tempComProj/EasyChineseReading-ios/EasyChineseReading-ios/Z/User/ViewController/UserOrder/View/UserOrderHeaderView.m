//
//  UOrderHeaderView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserOrderHeaderView.h"

@interface UserOrderHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderState;
@property (weak, nonatomic) IBOutlet UIView  *viewBotLine;
@property (weak, nonatomic) IBOutlet UIView  *viewTopLine;

@end

@implementation UserOrderHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configOrderHeaderView];
}

- (void)configOrderHeaderView
{
    self.backgroundColor = [UIColor colorWithHexString:@"FAFBFA"];
    
    _lblOrderId.textColor    = [UIColor cm_blackColor_666666_1];
    _lblOrderState.textColor = [UIColor cm_blackColor_666666_1];
    
    _lblOrderId.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblOrderState.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _viewTopLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewBotLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}

- (void)dataDidChange
{
    OrderModel *order = self.data;
    _lblOrderId.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"订单编号"), order.orderId];
    if (!_isDetailHeader) {
        if (order.orderStatus == ENUM_ZOrderStateDone) {
            _lblOrderState.textColor = [UIColor cm_blackColor_666666_1];
            _lblOrderState.text = LOCALIZATION(@"已完成");
        }
        else if (order.orderStatus == ENUM_ZOrderStateScore) {
            _lblOrderState.textColor = [UIColor cm_orangeColor_FF5910_1];
            _lblOrderState.text = LOCALIZATION(@"待评价");
        }
        else if (order.orderStatus == ENUM_ZOrderStateObligation) {
            _lblOrderState.textColor = [UIColor cm_blackColor_666666_1];
            _lblOrderState.text = LOCALIZATION(@"待付款");
        }
        else if (order.orderStatus == ENUM_ZOrderStateCancel){
            _lblOrderState.textColor = [UIColor cm_blackColor_666666_1];
            _lblOrderState.text = LOCALIZATION(@"交易取消");
        }
        else {
            _lblOrderState.textColor = [UIColor cm_blackColor_666666_1];
            _lblOrderState.text = LOCALIZATION(@"正在处理中...");
        }
    }
    else {
        _lblOrderState.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"下单时间"), order.date];
    }
}

@end
