//
//  USEmailTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/7.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseTableViewCell.h"

@interface USEmailTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtfAccount;
/** 是否可变 */
@property (assign, nonatomic) BOOL isUpdated;

@end
