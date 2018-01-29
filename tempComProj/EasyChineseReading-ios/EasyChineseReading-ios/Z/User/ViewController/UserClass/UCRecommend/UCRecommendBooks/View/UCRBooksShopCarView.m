//
//  UCRBooksShopCarView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRBooksShopCarView.h"

@interface UCRBooksShopCarView ()

@property (strong, nonatomic) UCRecommendMaskingView *maskingView;       //蒙版

@property (strong, nonatomic) UILabel *lblBookSelectedNumber; // 选中图书的数量
@property (strong, nonatomic) UILabel *line;                  // 分割线
@property (strong, nonatomic) UIView *parentView;             // 背景图层

@property (assign, nonatomic) NSInteger selectedNumber;  // 选中图书的数量

@property (assign, nonatomic) BOOL open;                 // 选中的图书列表的点开状态

@property (assign, nonatomic) CGFloat maxHeight;         // 选中图书列表的最高高度

@end

@implementation UCRBooksShopCarView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)parentView recommendType:(ENUM_RecommendType)type;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.parentView = parentView;
        _recommendType = type;
        [self configBooksShopCarView];
    }
    return self;
}

#pragma mark - 配置图书购物车界面

- (void)configBooksShopCarView
{
    self.backgroundColor = [UIColor cm_blackColor_000000_5F];
    _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5f)];
    _line.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _line.layer.borderWidth = .5f;
    [self addSubview:_line];
    
    //选中图书的数量
    _lblBookSelectedNumber = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, self.bounds.size.width - 140, 30)];
    _lblBookSelectedNumber.textColor = [UIColor whiteColor];
    [_lblBookSelectedNumber setText:LOCALIZATION(@"还没有选择图书")];
    [_lblBookSelectedNumber setFont:[UIFont systemFontOfSize:cFontSize_16]];
    [self addSubview:_lblBookSelectedNumber];
    
    //去推荐 选择学生
    _btnNextSelectedStudents = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnNextSelectedStudents.frame = CGRectMake(self.bounds.size.width - 100, 5, 90, 40);
    _btnNextSelectedStudents.layer.cornerRadius = _btnNextSelectedStudents.height/2;
    _btnNextSelectedStudents.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _btnNextSelectedStudents.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    _btnNextSelectedStudents.enabled = NO;
    [_btnNextSelectedStudents setTitle:[NSString stringWithFormat:@"%@", _recommendType == ENUM_RecommendTypeRecommend ? LOCALIZATION(@"推荐") : LOCALIZATION(@"授权")] forState:UIControlStateNormal];
    [_btnNextSelectedStudents addTarget:self action:@selector(clickToNextView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnNextSelectedStudents];
    
    //查看选中的书
    _btnShowSelectedBooks = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnShowSelectedBooks.frame = CGRectMake(10, -10, 50, 50);
    [_btnShowSelectedBooks setUserInteractionEnabled:NO];
    [_btnShowSelectedBooks setImage:[UIImage imageNamed:@"img_class_selected_book"] forState:UIControlStateNormal];
    [_btnShowSelectedBooks addTarget:self action:@selector(showSelectedBooks:) forControlEvents:UIControlEventTouchUpInside];
    _btnShowSelectedBooks.backgroundColor = [UIColor cm_mainColor];
    _btnShowSelectedBooks.layer.cornerRadius = _btnShowSelectedBooks.height/2;
    _btnShowSelectedBooks.layer.masksToBounds = YES;
    
    [self addSubview:_btnShowSelectedBooks];

    // 蒙版
    _maskingView = [[UCRecommendMaskingView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-50)];
    _maskingView.shoppingCarView = self;
    [_maskingView addSubview:self];
    [_parentView addSubview:_maskingView];
    _maskingView.alpha = 0.0;
    
    _maxHeight = Screen_Height / 2 * 3;
    //选中的图书列表
    _bookSelectedView = [[UCRBooksSelectedView alloc] initWithFrame:CGRectMake(0, _parentView.bounds.size.height - _maxHeight, self.bounds.size.width, _maxHeight) withObjects:nil  canReorder:YES];
    [_maskingView addSubview:_bookSelectedView];
    
    // 图书列表的展示状态
    self.open = NO;
}

#pragma mark 选择推荐的学生

/** 下一步 */
- (void)clickToNextView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(nextStep)]) {
        [self.delegate nextStep];
    }
}

#pragma mark 展示选中的图书
- (void)showSelectedBooks:(id)sender {
    // 如果没有图书 则返回
    if (!(_selectedNumber > 0)) {
        [_btnShowSelectedBooks setUserInteractionEnabled:NO];
        return;
    }
    
    if (_open)
        [self dismissWithAnimated:YES];
    else
        [self showWithAnimated:YES];
}

#pragma mark 更新 bookSelectedView 的高度

- (void)updateFrame:(UCRBooksSelectedView *)bookSelectedView
{
    // 选中图书的数量为0则消失
    if(bookSelectedView.objects.count == 0){
        [self dismissWithAnimated:YES];
        return;
    }
    
    float height = [bookSelectedView.objects count] * cHeaderHeight_54;
    
    if (height >= _maxHeight)
        height = _maxHeight;
    
    _bookSelectedView.frame = CGRectMake(_bookSelectedView.frame.origin.x, _parentView.bounds.size.height - height - cHeaderHeight_54 - cHeaderHeight_44, _bookSelectedView.frame.size.width, height);
}

#pragma mark - show and dismiss

- (void)showWithAnimated:(BOOL)animated
{
    [UIView animateWithDuration:cAnimationTime animations:^{
        _maskingView.alpha = 1.0;
        [self updateFrame:_bookSelectedView];
    } completion:^(BOOL finished) {
        self.open = YES;
    }];
}

- (void)dismissWithAnimated:(BOOL)animated
{
//    [self.btnShowSelectedBooks bringSubviewToFront:_maskingView];
    [UIView animateWithDuration:cAnimationTime animations:^{
        _btnShowSelectedBooks.frame = CGRectMake(10, -10, 50, 50);
        _lblBookSelectedNumber.frame = CGRectMake(70, 10, self.width, 30);
        _bookSelectedView.frame = CGRectMake(_bookSelectedView.x, _parentView.height, _bookSelectedView.width, _bookSelectedView.height);
        _maskingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.open = NO;
    }];
}

#pragma  mark - 计算选中图书的数量

- (void)setSelectedBooksNumber:(NSInteger)number
{
    _selectedNumber = number;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *amount = [formatter stringFromNumber:[NSNumber numberWithInteger:_selectedNumber]];
    
    [_btnNextSelectedStudents setTitle:[NSString stringWithFormat:@"%@", _recommendType == ENUM_RecommendTypeRecommend ? LOCALIZATION(@"推荐") : LOCALIZATION(@"授权")] forState:UIControlStateNormal];
    if (_selectedNumber > 0) {
        _lblBookSelectedNumber.text = [NSString stringWithFormat:@"%@ %@ %@", LOCALIZATION(@"共"), amount, LOCALIZATION(@"本书")];
        _btnNextSelectedStudents.enabled = YES;
        [_btnNextSelectedStudents setBackgroundColor:[UIColor cm_mainColor]];
        [_btnShowSelectedBooks setUserInteractionEnabled:YES];
    }
    else {
        _lblBookSelectedNumber.text = LOCALIZATION(@"还没有选择图书");
        _btnNextSelectedStudents.enabled = NO;
        [_btnNextSelectedStudents setBackgroundColor:[UIColor cm_grayColor__F1F1F1_1]];
        [_btnShowSelectedBooks setUserInteractionEnabled:NO];
    }
}

@end
