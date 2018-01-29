//
//  UserCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserCollectionViewCell.h"

@interface UserCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewBLine;  // 底部边线
@property (weak, nonatomic) IBOutlet UIView *viewRTLine; // 右上边线
@property (weak, nonatomic) IBOutlet UIView *viewRBLine; // 右下边线

@end

@implementation UserCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (void)configCell
{
    _imgHeightConstraint.constant = isPad ? 50.f : 40.f;
    _lblTopConstraint.constant = isPad ? 20.f : 10.f;
    
    _lblTitle.font = [UIFont systemFontOfSize:isPad ?  cFontSize_18 : cFontSize_16];
    _lblTitle.textColor = [UIColor cm_blackColor_333333_1];
    
    _viewBLine.backgroundColor  = [UIColor cm_lineColor_D9D7D7_1];
    _viewRTLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewRBLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}

- (void)dataDidChange
{
    NSDictionary *dic = self.data;
    _lblTitle.text = [dic objectForKey:@"title"];
    _imgIcon.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    
    _viewBLine.hidden = _index > 3;
    _viewRTLine.hidden = _index <= 3 || _index == 7;
    _viewRBLine.hidden = _index >= 3 || _index == 7;
}

@end
