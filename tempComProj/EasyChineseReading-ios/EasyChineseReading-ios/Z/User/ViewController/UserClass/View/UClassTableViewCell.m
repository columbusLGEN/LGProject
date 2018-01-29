//
//  UClassTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UClassTableViewCell.h"

@interface UClassTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgClass;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;

@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblClassNUm;

@property (weak, nonatomic) IBOutlet UIView *viewLine;

@end

@implementation UClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configClassCell];
}

- (void)configClassCell
{
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _imgClass.layer.masksToBounds = YES;
    _imgClass.layer.cornerRadius = _imgClass.height/2;
    
    _lblClassName.textColor = [UIColor cm_blackColor_333333_1];
    _lblClassName.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblClassNUm.textColor = [UIColor cm_blackColor_333333_1];
    _lblClassNUm.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    ClassModel *classInfo = self.data;
    
    [_imgClass sd_setImageWithURL:[NSURL URLWithString:classInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    _lblClassName.text = classInfo.className;
    _lblClassNUm.text = [NSString stringWithFormat:@"%ld %@", classInfo.studentNum, LOCALIZATION(@"人")];
}

@end
