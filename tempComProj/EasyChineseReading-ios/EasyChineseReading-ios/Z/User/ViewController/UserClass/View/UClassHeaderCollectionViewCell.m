//
//  UClassHeaderCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UClassHeaderCollectionViewCell.h"

@interface UClassHeaderCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblAction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImgConstraint;

@end

@implementation UClassHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lblAction.textColor = [UIColor cm_blackColor_333333_1];
    _lblAction.font = [UIFont systemFontOfSize:16.f];
}

- (void)dataDidChange
{
    NSDictionary *dic = self.data;
    
    _lblAction.text = dic[@"action"];
    _imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dic[@"icon"]]];
    _widthImgConstraint.constant = isPad ? 50.f : 40.f;
}

@end
