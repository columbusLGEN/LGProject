//
//  UTicketCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UTicketCollectionViewCell.h"

@interface UTicketCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;  // 卡券左侧图
@property (weak, nonatomic) IBOutlet UIImageView *imgRight; // 卡券右侧图
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@property (weak, nonatomic) IBOutlet UIView *viewProgress;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;     // 卡券价值
@property (weak, nonatomic) IBOutlet UILabel *lblCordition; // 卡券使用条件
@property (weak, nonatomic) IBOutlet UILabel *lblRange;     // 卡券使用范围
@property (weak, nonatomic) IBOutlet UILabel *lblTime;      // 卡券可以使用时间

@property (weak, nonatomic) IBOutlet UILabel *lblHandle;    // 操作
@property (weak, nonatomic) IBOutlet UILabel *lblProgress;  // 卡券领取情况

@property (strong, nonatomic) CAShapeLayer *backLayer;     // 背景圆圈
@property (strong, nonatomic) CAShapeLayer *progressLayer; // 进度

@end

@implementation UTicketCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    [self configProgressView];
}

#pragma mark - 画进度

- (void)configProgressView
{
    // 承载 view
    _viewProgress.layer.cornerRadius = _viewProgress.width/2;
    _viewProgress.layer.masksToBounds = YES;
    // 背景圆
    _backLayer = [CAShapeLayer layer];
    CGRect rect = {2 / 2, 2 / 2, _viewProgress.width - 2, _viewProgress.height - 2};
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    _backLayer.strokeColor = [UIColor colorWithHexString:@"000000" withAlpha:.2f].CGColor;
    _backLayer.lineWidth = 2;
    _backLayer.fillColor = [UIColor clearColor].CGColor;
    _backLayer.lineCap = kCALineCapRound;
    _backLayer.path = path.CGPath;
    [_viewProgress.layer addSublayer:_backLayer];
    // 进度圆
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = 2;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.path = path.CGPath;
    [_viewProgress.layer addSublayer:self.progressLayer];
    // 向左90°旋转
    _viewProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
    // 向右90°旋转
    _lblProgress.transform = CGAffineTransformMakeRotation(M_PI_2);
}

/**
 画进度

 @param number 进度
 */
- (void)updateProgressWithNumber:(NSUInteger)number {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.progressLayer.strokeEnd = number / 100.0;
    [CATransaction commit];
}

- (void)dataDidChange
{
    TicketModel *ticket = self.data;
    
    _lblPrice.text = [NSString stringWithFormat:@"%ld",ticket.minusMoney];
    if (ticket.starttime.length > 0 && ticket.endtime.length > 0) {
        _lblTime.text = [NSString stringWithFormat:@"%@ -- %@", [ticket.starttime substringToIndex:10], [ticket.endtime substringToIndex:10]];
    }
    _lblCordition.text = [NSString stringWithFormat:@"%@%.2f%@", LOCALIZATION(@"满"), ticket.fullMoney, LOCALIZATION(@"可用")];
    _lblRange.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? ticket.memo : ticket.en_memo;
    
    NSInteger progress = ticket.receiveNum*100/ticket.totalNum;
    _lblProgress.text = [NSString stringWithFormat:@"%ld%%", progress];
    [self updateProgressWithNumber:progress];
    if (_myTicket) {
        _imgLeft.image  = [UIImage imageNamed:@"img_ticket_left"];
        _imgRight.image = [UIImage imageNamed:@"img_ticket_mine"];
        _lblHandle.text = LOCALIZATION(@"立即使用");
    }
    else {
        switch (ticket.status) {
            case ENUM_TicketStatusHaveNot:
                if (ticket.receiveNum == ticket.totalNum) {
                    _imgLeft.image  = [UIImage imageNamed:@"img_ticket_empty_left"];
                    _imgRight.image = [UIImage imageNamed:@"img_ticket_empty_right"];
                    _lblHandle.text = LOCALIZATION(@"进场看看");
                }
                else {
                    _imgLeft.image  = [UIImage imageNamed:@"img_ticket_left"];
                    _imgRight.image = [UIImage imageNamed:@"img_ticket_get"];
                    _lblHandle.text = LOCALIZATION(@"立即领取");
                }
                break;
            case ENUM_TicketStatusHave:
                _imgLeft.image  = [UIImage imageNamed:@"img_ticket_left"];
                _imgRight.image = [UIImage imageNamed:@"img_ticket_mine"];
                _lblHandle.text = LOCALIZATION(@"立即使用");
                break;
            case ENUM_TicketStatusUsed:
                _imgLeft.image  = [UIImage imageNamed:@"img_ticket_empty_left"];
                _imgRight.image = [UIImage imageNamed:@"img_ticket_empty_right"];
                _lblHandle.text = LOCALIZATION(@"已使用");
                break;
            default:
                break;
        }
    }
}

@end
