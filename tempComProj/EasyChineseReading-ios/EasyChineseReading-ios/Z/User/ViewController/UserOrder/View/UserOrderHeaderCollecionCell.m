//
//  UserOrderHeaderCollecionCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/9.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserOrderHeaderCollecionCell.h"

@interface UserOrderHeaderCollecionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblHandle;

@end

@implementation UserOrderHeaderCollecionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lblHandle.textColor = [UIColor cm_blackColor_333333_1];
    _lblHandle.font = [UIFont systemFontOfSize:isPad ? cFontSize_14 : cFontSize_12];
}

- (void)dataDidChange
{
    NSDictionary *dic = self.data;
    
    _lblHandle.text = dic[@"handle"];
    NSNumber *orderState = dic[@"orderState"];
    
    _imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _orderState == orderState.integerValue ? dic[@"selected"] : dic[@"icon"]]];
}

@end
