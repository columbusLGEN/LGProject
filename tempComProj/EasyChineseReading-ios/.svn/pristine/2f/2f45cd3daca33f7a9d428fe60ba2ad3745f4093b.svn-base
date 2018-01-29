//
//  UCRStudentSelectedTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRStudentSelectedTableViewCell.h"

@interface UCRStudentSelectedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblStudentName;
@property (weak, nonatomic) IBOutlet UIButton *btnUnselectedStudent;

@end

@implementation UCRStudentSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self configSelectedStudentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dataDidChange
{
    UserModel *user = self.data;
    _lblClassName.text = user.className;
    _lblStudentName.text = user.name;
}

- (void)configSelectedStudentView
{
    _lblClassName.textColor = _lblStudentName.textColor = [UIColor cm_blackColor_333333_1];
    _lblClassName.font = _lblStudentName.font = [UIFont systemFontOfSize:15.f];
    [_btnUnselectedStudent setImage:[UIImage imageNamed:@"icon_class_delete"] forState:UIControlStateNormal];
}

- (IBAction)click_btnUnselectedStudent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(removeSelectedStudent:)]) {
        [self.delegate removeSelectedStudent:self.data];    
    }
}

@end
