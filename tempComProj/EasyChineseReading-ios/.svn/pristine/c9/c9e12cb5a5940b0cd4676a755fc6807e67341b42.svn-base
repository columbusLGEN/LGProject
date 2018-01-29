//
//  UCRStudentsShopCarView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

#import "UCRStudentMaskingView.h"
#import "UCRStudentsSelectedView.h"

@class UCRStudentsShopCarView;

@protocol UCRStudentsShopCarViewDelegate <NSObject>

- (void)nextStep;

@end

@interface UCRStudentsShopCarView : ECRBaseView

@property (weak, nonatomic) id<UCRStudentsShopCarViewDelegate> delegate;

@property (strong, nonatomic) UCRStudentsSelectedView *studentSelectedView;//选择的学生列表

@property (strong, nonatomic) UIButton *btnShowSelectedStudents;           // 查看选中的学生
@property (strong, nonatomic) UIButton *btnNextWriteDescribe;              // 下一步添加描述

@property (assign, nonatomic) ENUM_UserType userType; // 用户类型

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)parentView;
- (void)dismissWithAnimated:(BOOL)animated;
- (void)setSelectedBooksNumber:(NSInteger)number;
- (void)updateFrame:(UCRStudentsSelectedView *)selectedView;

@end
