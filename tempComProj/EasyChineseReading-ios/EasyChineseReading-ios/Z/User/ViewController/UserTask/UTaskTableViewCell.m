//
//  UTaskTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UTaskTableViewCell.h"

@interface UTaskTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTaskName;
@property (weak, nonatomic) IBOutlet UIView  *viewBackground;

@property (strong, nonatomic) TaskModel *task; // 任务

@end

@implementation UTaskTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configTaskCell];
}

#pragma mark - config task cell

- (void)configTaskCell
{
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
    
    _lblTaskName.textColor = [UIColor cm_blackColor_333333_1];
    _lblTaskName.font = [UIFont systemFontOfSize:15.f];
    
    _btnGetIntegral.layer.masksToBounds = YES;
    _btnGetIntegral.layer.cornerRadius  = _btnGetIntegral.height/2;
    
    _btnGetIntegral.layer.borderColor = [UIColor cm_mainColor].CGColor;
    _btnGetIntegral.layer.borderWidth = .5f;
    
    _btnGetIntegral.backgroundColor = [UIColor whiteColor];
    
    
    [_btnGetIntegral setTitle:LOCALIZATION(@"未完成") forState:UIControlStateNormal];
    [_btnGetIntegral setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        [_btnGetIntegral setTitle:LOCALIZATION(@"已领取") forState:UIControlStateNormal];
        _btnGetIntegral.backgroundColor = [UIColor cm_mainColor];
        [_btnGetIntegral setTintColor:[UIColor cm_mainColor]];
        [_btnGetIntegral setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - action

- (void)dataDidChange
{
    _task = self.data;
    _lblTaskName.text = [NSString stringWithFormat:@"%@(%ld %@)", [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _task.taskdescribe : _task.en_taskdescribe, _task.taskreward, LOCALIZATION(@"积分")];
    
    if (_task.status == ENUM_TaskStatusTypeUnFinish) {
        [_btnGetIntegral setTitle:LOCALIZATION(@"未完成") forState:UIControlStateNormal];
        [_btnGetIntegral setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
        _btnGetIntegral.backgroundColor = [UIColor whiteColor];
    }
    else if (_task.status == ENUM_TaskStatusTypeDone) {
        [_btnGetIntegral setTitle:LOCALIZATION(@"未领取") forState:UIControlStateNormal];
        [_btnGetIntegral setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
        _btnGetIntegral.backgroundColor = [UIColor whiteColor];
    }
    else {
        [_btnGetIntegral setTitle:LOCALIZATION(@"已领取") forState:UIControlStateNormal];
        [_btnGetIntegral setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnGetIntegral.backgroundColor = [UIColor cm_mainColor];
    }
    self.isSelected = _task.status == ENUM_TaskStatusTypeGetIntegral;
}

- (IBAction)click_btnGetIntegral:(id)sender
{
    [self.delegate getTaskAwardWithTask:_task index:_selectedIndex];
}

@end
