

//
//  UCRStudentsShopCarView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRStudentsShopCarView.h"

@interface UCRStudentsShopCarView ()

@property (strong, nonatomic) UCRStudentMaskingView *maskingView;       //蒙版

@property (strong, nonatomic) UILabel *lblSelectedNumber;           // 选中学生的数量

@property (strong, nonatomic) UILabel *line;             // 分割线
@property (strong, nonatomic) UIView *parentView;        // 背景图层

@property (assign, nonatomic) NSInteger selectedNumber;  // 选中学生的数量

@property (assign, nonatomic) BOOL open;                 // 选中的学生列表的点开状态

@property (assign, nonatomic) CGFloat maxHeight;         // 选中学生列表的最高高度

@end

@implementation UCRStudentsShopCarView


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)parentView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.parentView = parentView;
        [self configBooksShopCarView];
    }
    return self;
}

#pragma mark - 配置学生购物车界面

- (void)configBooksShopCarView
{
    self.backgroundColor = [UIColor cm_blackColor_000000_5F];
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5f)];
    self.line.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.line.layer.borderWidth = .5f;
    [self addSubview:self.line];
    
    //选中学生的数量
    self.lblSelectedNumber = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, self.bounds.size.width-140, 30)];
    [self.lblSelectedNumber setTextColor:[UIColor whiteColor]];
    [self.lblSelectedNumber setText:_userType == ENUM_UserTypeTeacher ? LOCALIZATION(@"还没有选择老师") : LOCALIZATION(@"还没有选择学生")];
    [self.lblSelectedNumber setFont:[UIFont systemFontOfSize:cFontSize_16]];
    [self addSubview:self.lblSelectedNumber];
    
    //去推荐 选择学生
    self.btnNextWriteDescribe = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnNextWriteDescribe.frame = CGRectMake(self.bounds.size.width - 100, 5, 90, 40);
    self.btnNextWriteDescribe.layer.cornerRadius = _btnNextWriteDescribe.height/2;
    self.btnNextWriteDescribe.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.btnNextWriteDescribe.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    self.btnNextWriteDescribe.enabled = NO;
    [self.btnNextWriteDescribe setTitle:LOCALIZATION(@"下一步") forState:UIControlStateNormal];
    [self.btnNextWriteDescribe addTarget:self action:@selector(clickToNextView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnNextWriteDescribe];
    
    //查看选中的书
    self.btnShowSelectedStudents = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnShowSelectedStudents.frame = CGRectMake(10, -10, 50, 50);
    [self.btnShowSelectedStudents setUserInteractionEnabled:NO];
    [self.btnShowSelectedStudents setImage:[UIImage imageNamed:@"img_class_selected_user"] forState:UIControlStateNormal];
    [self.btnShowSelectedStudents addTarget:self action:@selector(showSelectedBooks:) forControlEvents:UIControlEventTouchUpInside];
    _btnShowSelectedStudents.backgroundColor = [UIColor cm_mainColor];
    _btnShowSelectedStudents.layer.cornerRadius = _btnShowSelectedStudents.height/2;
    _btnShowSelectedStudents.layer.masksToBounds = YES;
    [self addSubview:self.btnShowSelectedStudents];
    
    // 蒙版
    self.maskingView = [[UCRStudentMaskingView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_54)];
    self.maskingView.shoppingCarView = self;
    [self.maskingView addSubview:self];
    [self.parentView addSubview:self.maskingView];
    self.maskingView.alpha = 0.0;
    
    _maxHeight = _parentView.height*2/3;
    //选中的学生列表
    self.studentSelectedView = [[UCRStudentsSelectedView alloc] initWithFrame:CGRectMake(0, self.parentView.bounds.size.height - _maxHeight, self.bounds.size.width, _maxHeight) withObjects:nil canReorder:YES];
    self.studentSelectedView.userType = self.userType;
    [self.maskingView addSubview:_studentSelectedView];
    
    // 学生列表的展示状态
    self.open = NO;
}

#pragma mark 选择推荐的学生

- (void)clickToNextView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nextStep)]) {
        [self.delegate nextStep];
    }
}

#pragma mark 展示选中的学生

- (void)showSelectedBooks:(id)sender {
    // 如果没有学生 则返回
    if (!(_selectedNumber > 0)) {
        [self.btnShowSelectedStudents setUserInteractionEnabled:NO];
        return;
    }
    
    if (self.open) {
        [self dismissWithAnimated:YES];
    }
    else {
        [self showWithAnimated:YES];
    }
}

#pragma mark 更新 studentSelectedView 的高度

- (void)updateFrame:(UCRStudentsSelectedView *)studentSelectedView
{
    // 选中学生的数量为0则消失
    if(studentSelectedView.objects.count == 0){
        [self dismissWithAnimated:YES];
        return;
    }
    
    float height = [studentSelectedView.objects count] * cHeaderHeight_54;
    
    if (height >= _maxHeight) {
        height = _maxHeight;
    }
    
    _studentSelectedView.frame = CGRectMake(_studentSelectedView.frame.origin.x,
                                            Screen_Height - cHeaderHeight_64 - height - cHeaderHeight_54 - cHeaderHeight_44,
                                            _studentSelectedView.frame.size.width,
                                            height + cHeaderHeight_44);
    
}

#pragma mark - show and dismiss

- (void)showWithAnimated:(BOOL)animated
{
    [self.parentView bringSubviewToFront:_maskingView];
    [self.parentView bringSubviewToFront:self];
    [UIView animateWithDuration:cAnimationTime animations:^{
        _maskingView.alpha = 1.0;
        [self updateFrame:_studentSelectedView];
    } completion:^(BOOL finished) {
        self.open = YES;
    }];
}

- (void)dismissWithAnimated:(BOOL)animated
{
//    [self.btnShowSelectedStudents bringSubviewToFront:_maskingView];
    [UIView animateWithDuration:cAnimationTime animations:^{
        self.btnShowSelectedStudents.frame = CGRectMake(10, -10, 50, 50);
        self.lblSelectedNumber.frame = CGRectMake(70, 10, self.width, 30);
        _studentSelectedView.frame = CGRectMake(_studentSelectedView.x, self.parentView.height, _studentSelectedView.width, _studentSelectedView.height);
        _maskingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.open = NO;
    }];
}

#pragma  mark - 计算选中学生的数量

- (void)setSelectedBooksNumber:(NSInteger)number
{
    _selectedNumber = number;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    NSString *amount = [formatter stringFromNumber:[NSNumber numberWithInteger:_selectedNumber]];
    [_btnNextWriteDescribe setTitle:LOCALIZATION(@"下一步") forState:UIControlStateNormal];
    if(_selectedNumber > 0) {
        _lblSelectedNumber.text = [NSString stringWithFormat:@"%@ %@ %@%@", LOCALIZATION(@"已选中"), amount, LOCALIZATION(@"名"), _userType == ENUM_UserTypeTeacher ? LOCALIZATION(@"教师") : LOCALIZATION(@"学生")];
        _btnNextWriteDescribe.enabled = YES;
        [_btnNextWriteDescribe setBackgroundColor:[UIColor cm_mainColor]];
        [_btnShowSelectedStudents setUserInteractionEnabled:YES];
    }
    else {
        _lblSelectedNumber.text = _userType == ENUM_UserTypeTeacher ? LOCALIZATION(@"还没有选择教师") : LOCALIZATION(@"还没有选择学生");
        _btnNextWriteDescribe.enabled = NO;
        [_btnNextWriteDescribe setBackgroundColor:[UIColor cm_grayColor__F1F1F1_1]];
        [_btnShowSelectedStudents setUserInteractionEnabled:NO];
    }
}

@end
