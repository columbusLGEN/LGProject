//
//  ZSegment.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZSegment.h"

static CGFloat const kSegmentHeight = 3;

@interface ZSegment ()

@property (strong, nonatomic) UIView *viewSlider; // 底部滑块

@property (strong, nonatomic) UIView *botline; // 底部横线
@property (strong, nonatomic) UIView *verLine; // 竖线

@property (strong, nonatomic) UIView *viewLeft;
@property (strong, nonatomic) UIView *viewRight;
@property (strong, nonatomic) UIView *viewSelect;  // 色块

@property (strong, nonatomic) UILabel *lblLeft;
@property (strong, nonatomic) UILabel *lblRight;

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation ZSegment

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt
{
    return [self initWithFrame:frame leftTitle:lt rightTitle:rt selectedColor:[UIColor cm_mainColor] sliderColor:[UIColor cm_mainColor]];
}

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedColor:(UIColor *)selectedColor sliderColor:(UIColor *)sliderColor
{
    return [self initWithFrame:frame leftTitle:lt rightTitle:rt selectedColor:selectedColor sliderColor:sliderColor verLineColor:[UIColor cm_lineColor_D9D7D7_1] diamondColor:[UIColor whiteColor]];
}

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedColor:(UIColor *)selectedColor sliderColor:(UIColor *)sliderColor verLineColor:(UIColor *)verLineColor diamondColor:(UIColor *)diamondColor
{
    return [self initWithFrame:frame leftTitle:lt rightTitle:rt selectedColor:selectedColor sliderColor:sliderColor verLineColor:verLineColor diamondColor:diamondColor selectedIndex:0];
}

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedIndex:(NSInteger)selectedIndex
{
    return [self initWithFrame:frame leftTitle:lt rightTitle:rt selectedColor:[UIColor cm_mainColor] sliderColor:[UIColor cm_mainColor] verLineColor:[UIColor cm_lineColor_D9D7D7_1] diamondColor:[UIColor whiteColor] selectedIndex:selectedIndex];
}

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedColor:(UIColor *)selectedColor sliderColor:(UIColor *)sliderColor verLineColor:(UIColor *)verLineColor diamondColor:(UIColor *)diamondColor selectedIndex:(NSInteger)selectedIndex
{
    if (self = [super initWithFrame:frame]) {
        [self configSegmentWithSColor:selectedColor lt:lt rt:rt sliderColor:sliderColor verLineColor:verLineColor diamondColor:diamondColor selectedIndex:selectedIndex];
    }
    return self;
}

#pragma mark - 界面布局

- (void)configSegmentWithSColor:(UIColor *)scolor lt:(NSString *)lt rt:(NSString *)rt sliderColor:(UIColor *)sliderColor verLineColor:(UIColor *)verLineColor diamondColor:(UIColor *)diamondColor selectedIndex:(NSInteger)selectedIndex
{
    self.backgroundColor = [UIColor whiteColor];
    _selectedIndex = selectedIndex;
    
    _viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width/2 - 1, self.height - 1)];
    [self addSubview:_viewLeft];
    
    _viewRight = [[UIView alloc] initWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height - 1)];
    [self addSubview:_viewRight];
    
    _lblLeft = [[UILabel alloc] init];
    _lblLeft.textAlignment = NSTextAlignmentCenter;
    _lblLeft.textColor = _selectedIndex == 0 ? scolor : [UIColor cm_blackColor_333333_1];
    _lblLeft.text = lt;
    _lblLeft.font = [UIFont systemFontOfSize:cFontSize_16];
    [_viewLeft addSubview:_lblLeft];

    [_lblLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_viewLeft);
    }];

    _lblRight = [[UILabel alloc] init];
    _lblRight.textAlignment = NSTextAlignmentCenter;
    _lblRight.textColor = _selectedIndex == 1 ? scolor : [UIColor cm_blackColor_333333_1];
    _lblRight.text = rt;
    _lblRight.font = [UIFont systemFontOfSize:cFontSize_16];
    [_viewRight addSubview:_lblRight];
    [_lblRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_viewRight);
    }];
    
    _botline = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    _botline.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [self addSubview:_botline];
    
    _verLine = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - 1, (self.height - cFontSize_16)/2, 1, cFontSize_16)];
    _verLine.backgroundColor = verLineColor;
    [self addSubview:_verLine];

    _viewSlider = [[UIView alloc] initWithFrame:_selectedIndex == 0 ? CGRectMake((_viewLeft.width - [NSString stringWidthWithText:lt fontSize:cFontSize_16])/2
                                                                                 , _viewLeft.height - kSegmentHeight
                                                                                 , [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16]
                                                                                 , kSegmentHeight)
                                                                    : CGRectMake(_viewLeft.width + (_viewRight.width - [NSString stringWidthWithText:_lblRight.text fontSize:cFontSize_16])/2
                                                                                 , _viewRight.height - kSegmentHeight
                                                                                 , [NSString stringWidthWithText:_lblRight.text fontSize:cFontSize_16]
                                                                                 , kSegmentHeight)];
    _viewSlider.backgroundColor = sliderColor;
    [self addSubview:_viewSlider];
    
    _viewSelect = [[UIView alloc] initWithFrame:CGRectMake(_viewSlider.x - 8, self.height/2 - 3, 6, 6)];
    _viewSelect.backgroundColor = diamondColor;
    [self addSubview:_viewSelect];

    _viewLeft.userInteractionEnabled  = YES;
    _viewRight.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapL = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLLabel)];
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRLabel)];

    [_viewLeft  addGestureRecognizer:tapL];
    [_viewRight addGestureRecognizer:tapR];
}

- (void)tapLLabel
{
    if (_selectedIndex == 1) {
        _selectedIndex = 0;
        _lblLeft.textColor  = [UIColor cm_mainColor];
        _lblRight.textColor = [UIColor cm_blackColor_333333_1];
        
        _viewSlider.frame = CGRectMake((_viewLeft.width - [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16])/2, _viewLeft.height - kSegmentHeight
                                       , [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16], kSegmentHeight);
        
        _viewSelect.frame = CGRectMake(_viewSlider.x - 8, self.height/2 - 3, 6, 6);
        self.selectedLeft();
    }
}

- (void)tapRLabel
{
    if (_selectedIndex == 0) {
        _selectedIndex = 1;
        _lblLeft.textColor  = [UIColor cm_blackColor_333333_1];
        _lblRight.textColor = [UIColor cm_mainColor];
        
        _viewSlider.frame = CGRectMake(_viewLeft.width + (_viewRight.width - [NSString stringWidthWithText:_lblRight.text fontSize:cFontSize_16])/2, _viewRight.height - kSegmentHeight
                                       , [NSString stringWidthWithText:_lblRight.text fontSize:cFontSize_16], kSegmentHeight);
        _viewSelect.frame = CGRectMake(_viewSlider.x - 8, self.height/2 - 3, 6, 6);

        self.selectedRight();
    }
}



@end
