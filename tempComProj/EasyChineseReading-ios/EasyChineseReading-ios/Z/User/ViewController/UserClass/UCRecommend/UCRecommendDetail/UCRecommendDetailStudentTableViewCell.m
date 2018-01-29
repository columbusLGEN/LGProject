//
//  UCRecommendDetailStudentTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendDetailStudentTableViewCell.h"

@interface UCRecommendDetailStudentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblStudentName;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@end
@implementation UCRecommendDetailStudentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configView
{
    _lblNumber.textColor = _lblClassName.textColor = _lblStudentName.textColor = [UIColor cm_blackColor_333333_1];
    _lblNumber.font = _lblClassName.font = _lblStudentName.font = [UIFont systemFontOfSize:15.f];
    
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}

- (void)dataDidChange
{
    if ([self.data isKindOfClass:[NSString class]]) {
        self.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
        _lblClassName.text   = LOCALIZATION(@"班级");
        _lblStudentName.text = LOCALIZATION(@"姓名");
        _lblNumber.text      = LOCALIZATION(@"序号");
    }
    else {
        UserModel *user = self.data;
        _lblStudentName.text = user.name.length > 0 ? user.name : LOCALIZATION(@"匿名");
        _lblClassName.text = user.className.length > 0 ? user.className : @"";
    }
}

@end
