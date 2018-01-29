

//
//  UTaskCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UTaskCollectionViewCell.h"

@interface UTaskCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBadge;     // 徽章
@property (weak, nonatomic) IBOutlet UILabel *lblDescTask;      // 任务描述

@property (strong, nonatomic) TaskModel *task;

@end

@implementation UTaskCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (void)configView
{
    _lblDescTask.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescTask.font = [UIFont systemFontOfSize:cFontSize_14];
}

/**
 tasktype
 1  充值 N 元
 6  每日登陆
 8  每日阅读时间
 12 读完书籍
 15 分享读书笔记
 16 用户数量
 17 首次充值
 20 读完系列
 */
- (void)dataDidChange
{
    _task = self.data;
    _lblDescTask.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _task.taskdescribe : _task.en_taskdescribe;
    [self setBadgeImage:_task];
}

- (void)getTaskIntegral
{
    _task.status = ENUM_TaskStatusTypeGetIntegral;
    [self setBadgeImage:_task];
}

- (void)setBadgeImage:(TaskModel *)task
{
    // 根据系统任务状态，拼接任务的图片
    NSString *strImgName   = @"img_badge_";
    NSString *strImgColor  = @"purple_";
    NSString *strImgStatus = @"_unfinish";
    if (task.tasktype == 6)
        strImgColor = @"light_blue_";
    else if (task.tasktype == 16)
        strImgColor = @"blue_";
    else if (task.tasktype == 17)
        strImgColor = @"orange_";
    
    strImgName = [strImgName stringByAppendingString:strImgColor];
    strImgName = [strImgName stringByAppendingString:[NSString stringWithFormat:@"%ld", task.taskreward]];
    
    if (task.status == ENUM_TaskStatusTypeGetIntegral)
        strImgStatus = @"_finish";
    else if (task.status == ENUM_TaskStatusTypeDone)
        strImgStatus = @"_done";
    
    strImgName = [strImgName stringByAppendingString:strImgStatus];
    _imgBadge.image = [UIImage imageNamed:strImgName];
}

@end
