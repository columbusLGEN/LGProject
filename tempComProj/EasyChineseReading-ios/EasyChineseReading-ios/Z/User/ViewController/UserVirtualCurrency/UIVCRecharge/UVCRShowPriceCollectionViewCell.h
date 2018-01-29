//
//  UVCRShowPriceCollectionViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseCollectionViewCell.h"

@interface UVCRShowPriceCollectionViewCell : ECRBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDescPrice; // 显示类型
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;     // 数量
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;  // 币种

@property (assign, nonatomic) NSInteger index; 

@end
