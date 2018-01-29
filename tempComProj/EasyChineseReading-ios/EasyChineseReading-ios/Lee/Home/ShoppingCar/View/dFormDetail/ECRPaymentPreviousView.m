//
//  ECRPaymentPreviousView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRPaymentPreviousView.h"
#import "ECRTopupFieldView.h"
#import "ECRFullMinusRollView.h"
#import "ECRPpvPirceView.h"
#import "ECRPpvSwitchView.h"
#import "ECRPpvScoreView.h"
#import "ECRRequestFailuredView.h"

//static CGFloat marginA         = 15;
static CGFloat height_fifty    = 50;
static CGFloat heightBB        = 50;// bottom button

@interface ECRPaymentPreviousView ()<
UIScrollViewDelegate,
ECRPpvSwitchViewDelegate
>

@property (strong,nonatomic) ECRPpvSwitchView *switchView;// 切换 --> 充值 满减卷 积分抵扣
@property (strong,nonatomic) UIScrollView *scrollView;//

@end

@implementation ECRPaymentPreviousView

- (void)textDependsLauguage{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"offsetX -- %f",offsetX);
    [self.switchView switchBtnWithOffsetX:offsetX];

}

- (void)ppvsView:(ECRPpvSwitchView *)view offsetPoint:(CGPoint)offsetPoint{
    [self.scrollView setContentOffset:offsetPoint animated:YES];
}

#pragma mark - ECRPpvSwitchViewDelegate

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.priceView];
    [self addSubview:self.switchView];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.fullMinusView];
    [self.scrollView addSubview:self.scoreCoun];
    [self.scrollView addSubview:self.rrfView];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(self.marginA);
        make.right.equalTo(self.mas_right).offset(-(self.marginA));
        make.bottom.equalTo(self.switchView.mas_top);
        make.height.equalTo(@(height_fifty));
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView.mas_left);
        make.right.equalTo(self.priceView.mas_right);
        make.height.equalTo(@(height_fifty));
    }];
    CGFloat heightA = Screen_Height - 3 * height_fifty - heightBB - 64;
    if ([ECRMultiObject isiPhoneX]) {
        heightA -= 24;
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(heightA));
//        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.fullMinusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scoreCoun.mas_left);
        make.top.equalTo(self.scrollView.mas_top);//.offset(self.marginA);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.width.equalTo(@(Screen_Width));
    }];
    [self.rrfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fullMinusView.mas_top);
        make.left.equalTo(self.fullMinusView.mas_left);
        make.bottom.equalTo(self.fullMinusView.mas_bottom);
        make.right.equalTo(self.fullMinusView.mas_right);
    }];
    [self.scoreCoun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.width.equalTo(@(Screen_Width));
        make.height.equalTo(@(heightA));
    }];
    [self textDependsLauguage];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (ECRPpvPirceView *)priceView{
    if (_priceView == nil) {
        _priceView = [[ECRPpvPirceView alloc] init];
    }
    return _priceView;
}
- (ECRPpvSwitchView *)switchView{
    if (_switchView == nil) {
        _switchView = [[ECRPpvSwitchView alloc] init];
        _switchView.delegate = self;
    }
    return _switchView;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (ECRFullMinusRollView *)fullMinusView{
    if (_fullMinusView == nil) {
        _fullMinusView = [[ECRFullMinusRollView alloc] init];
    }
    return _fullMinusView;
}
- (ECRRequestFailuredView *)rrfView{
    if (_rrfView == nil) {
        _rrfView = [ECRRequestFailuredView new];
        _rrfView.emptyType = ECRRFViewEmptyTypeNoJuan;
    }
    return _rrfView;
}
- (ECRPpvScoreView *)scoreCoun{
    if (_scoreCoun == nil) {
        _scoreCoun = [[ECRPpvScoreView alloc] init];
    }
    return _scoreCoun;
}
- (CGFloat)marginA{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return 15;
    }else{
        return 10;
    }
}
@end
