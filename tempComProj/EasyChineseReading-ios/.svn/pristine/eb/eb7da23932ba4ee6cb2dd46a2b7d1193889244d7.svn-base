//
//  UClassManagerTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UClassManagerTableViewCell.h"

@interface UClassManagerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblStudentNum;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (strong, nonatomic) ClassModel *classInfo;

@end

@implementation UClassManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 配置界面

- (void)configCell
{
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblClassName.textColor = [UIColor cm_blackColor_333333_1];
    _lblStudentNum.textColor = [UIColor cm_blackColor_333333_1];

    _lblClassName.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblStudentNum.font = [UIFont systemFontOfSize:cFontSize_16];

    [_btnUpdate setTintColor:[UIColor cm_blackColor_333333_1]];
    [_btnDelete setTintColor:[UIColor cm_blackColor_333333_1]];

    [_btnUpdate setImage:[UIImage imageNamed:@"icon_class_edit"] forState:UIControlStateNormal];
    [_btnDelete setImage:[UIImage imageNamed:@"icon_trash"]      forState:UIControlStateNormal];
}

#pragma mark - 数据

- (void)dataDidChange
{
    _classInfo = self.data;

    _lblClassName.text = _classInfo.className;
    _lblStudentNum.text = [NSString stringWithFormat:@"%ld", _classInfo.studentNum];
}

#pragma mark - 操作

/** 编辑班级信息 */
- (IBAction)click_btnUpdate:(id)sender {
    self.updateClass(self.data);
}

/** 删除班级 */
- (IBAction)click_btnDelete:(id)sender {
    self.deleteClass(self.data);
}

@end
