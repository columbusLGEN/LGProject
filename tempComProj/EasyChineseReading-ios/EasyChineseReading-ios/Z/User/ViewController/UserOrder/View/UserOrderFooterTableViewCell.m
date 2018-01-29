//
//  UserOrderFooterTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserOrderFooterTableViewCell.h"

@interface UserOrderFooterTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIView *viewBotLine;
@property (weak, nonatomic) IBOutlet UIView *viewTopLine;
@property (weak, nonatomic) IBOutlet UIButton *btnLoadMore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBGConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurr;

@property (strong, nonatomic) OrderModel *order;

@end

@implementation UserOrderFooterTableViewCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configDefaultOrderFooterView];
}

- (void)configDefaultOrderFooterView
{
    self.backgroundColor = [UIColor whiteColor];
    _btnRight.layer.masksToBounds = YES;
    _btnRight.layer.cornerRadius = _btnRight.height/2;
    
    _btnRight.layer.borderWidth = 1.f;
    _btnRight.layer.borderColor = [UIColor cm_mainColor].CGColor;
    _btnRight.backgroundColor = [UIColor whiteColor];
    [_btnRight setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    [_btnRight setTitle:LOCALIZATION(@"评价") forState:UIControlStateNormal];
    
    _btnLeft.layer.masksToBounds = YES;
    _btnLeft.layer.cornerRadius = _btnLeft.height/2;
    
    _btnLeft.layer.borderWidth = 1.f;
    _btnLeft.layer.borderColor = [UIColor cm_mainColor].CGColor;
    _btnLeft.backgroundColor = [UIColor whiteColor];
    [_btnLeft setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    [_btnLeft setTitle:LOCALIZATION(@"取消订单") forState:UIControlStateNormal];
    
    _btnLoadMore.backgroundColor = [UIColor whiteColor];
    [_btnLoadMore setTitleColor:[UIColor cm_blackColor_333333_1] forState:UIControlStateNormal];
    [_btnLoadMore setTitle:[NSString stringWithFormat:@"%@ ↓", LOCALIZATION(@"加载更多")] forState:UIControlStateNormal];
    
    _viewTopLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewBotLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblMoney.textColor = [UIColor cm_blackColor_333333_1];
    _lblMoney.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblMoney.text = [NSString stringWithFormat:@"%@:", LOCALIZATION(@"实际支付")];
    
    _lblPrice.textColor = [UIColor cm_orangeColor_FF5910_1];
    _lblPrice.font = [UIFont boldSystemFontOfSize:20.f];
    
    _imgVirtualCurr.image = [UIImage imageNamed:@"icon_virtual_currency"];
}

#pragma mark - 数据更新

- (void)dataDidChange
{
    _order = self.data;
    
    _lblPrice.text = [NSString stringWithFormat:@"%.2f", _order.finalTotalMoney];
    
    _viewTopLine.hidden = YES;
    
    _btnLeft.hidden = _order.orderStatus != ENUM_ZOrderStateObligation;
    // 只有一本书或展示全部书籍, 则隐藏加载更多
    _btnLoadMore.hidden = _order.books.count <= 1 || _order.showAllBook;
    
    _btnRight.backgroundColor = _order.orderStatus == ENUM_ZOrderStateObligation ? [UIColor cm_mainColor] : [UIColor whiteColor];
    [_btnRight setTitleColor:_order.orderStatus == ENUM_ZOrderStateObligation ? [UIColor whiteColor] : [UIColor cm_mainColor] forState:UIControlStateNormal];
    if (_order.orderStatus == ENUM_ZOrderStateObligation) {
        [_btnRight setTitle:LOCALIZATION(@"立即支付") forState:UIControlStateNormal];
        _btnRight.hidden = NO;
    }
    else if (_order.orderStatus == ENUM_ZOrderStateScore) {
        [_btnRight setTitle:LOCALIZATION(@"评价") forState:UIControlStateNormal];
        _btnRight.hidden = NO;
    }
    else if (_order.orderStatus == ENUM_ZOrderStateCancel) {
        [_btnRight setTitle:LOCALIZATION(@"删除订单") forState:UIControlStateNormal];
        _btnRight.hidden = NO;
    }
    else {
        _btnRight.hidden = YES;
    }
    _heightBGConstraint.constant = _order.orderStatus == ENUM_ZOrderStateDone ? 0 : cHeaderHeight_54;
}

#pragma mark - action

/** 加载更多 */
- (IBAction)click_loadMore:(id)sender {
    _order.showAllBook = YES;
    _btnLoadMore.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(showAllBooksWithOrder:)]) {
        [self.delegate showAllBooksWithOrder:self.data];
    }
}

/** 右侧按键 */
- (IBAction)click_btnRight:(id)sender {
    if (_order.orderStatus == ENUM_ZOrderStateObligation) {
        if ([self.delegate respondsToSelector:@selector(payOrderWithOrder:)]) {
            [self.delegate payOrderWithOrder:self.data];
        }
    }
    else if (_order.orderStatus == ENUM_ZOrderStateScore) {
        if ([self.delegate respondsToSelector:@selector(evaluateWithOrder:)]) {
            [self.delegate evaluateWithOrder:self.data];
        }
    }
    else if ( _order.orderStatus == ENUM_ZOrderStateCancel) {
        if ([self.delegate respondsToSelector:@selector(deleteOrderWithOrder:)]) {
            [self.delegate deleteOrderWithOrder:self.data];
        }
    }
    else {
        // nil
    }
}

/** 左侧按键 */
- (IBAction)click_btnLeft:(id)sender {
    if (_order.orderStatus == ENUM_ZOrderStateObligation) {
        if ([self.delegate respondsToSelector:@selector(cancelOrderWithOrder:)]) {
            [self.delegate cancelOrderWithOrder:self.data];
        }
    }
}

@end
