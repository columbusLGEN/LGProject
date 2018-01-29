//
//  UserLeaseDetailVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UserLeaseDetailVC : ECRBaseViewController

@property (strong, nonatomic) SerialModel *serial; // 系列
@property (strong, nonatomic) TicketBookModel *ticket; // 兑换券

@end
