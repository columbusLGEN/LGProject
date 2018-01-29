//
//  ECRHomeMainView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRHomeMainView.h"
#import "ECRHomeMainModel.h"
#import "SDCycleScrollView.h"
#import "ECRBookClasses.h"
#import "ECRBoomRecomment.h"
#import "ECRThemeAera.h"
#import "ECRSeriesAera.h"
#import "ECRReadMonster.h"
#import "ECRHomeMainModel.h"
#import "ECRAdvModel.h"

@interface ECRHomeMainView ()<
SDCycleScrollViewDelegate,
UIScrollViewDelegate
>
@property (strong,nonatomic) NSArray *Advertisement;//
@property (assign,nonatomic)  CGFloat cvHeight;// 轮播
@property (assign,nonatomic) CGFloat bcHeight;// 分类
@property (assign,nonatomic) CGFloat brHeight;// 推荐
@property (assign,nonatomic) CGFloat saHeight;// 系列
@property (assign,nonatomic) CGFloat taHeight;// 主题
@property (assign,nonatomic) CGFloat rmHeight;// 达人

@end

@implementation ECRHomeMainView

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ECRAdvModel *adv = self.Advertisement[index];
    // MARK: 点击广告
    if ([self.delegate respondsToSelector:@selector(hmClickAdView:model:)]) {
        [self.delegate hmClickAdView:self model:adv];
    }
}


- (void)setModel:(ECRHomeMainModel *)model{
    _model = model;
    // 广告
    self.Advertisement = model.Advertisement;
    NSMutableArray *advM = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < model.Advertisement.count; i++) {
        ECRAdvModel *adv = model.Advertisement[i];
        [advM addObject:adv.imghref];/// adurl // imghref
    }
    // MARK: 赋值网络轮播数组
    _cycleView.imageURLStringsGroup = advM.copy;
    _cycleView.autoScroll = YES;
    _cycleView.infiniteLoop = YES;
    _cycleView.autoScrollTimeInterval = 4;
    _cycleView.placeholderImage = LGPAdvertisePlaceHolder;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.scrollView];
    // MARK: 必要时轮播器需要加载本地图片
    [self.scrollView addSubview:self.cycleView];
    [self.scrollView addSubview:self.bookClasses];
    [self.scrollView addSubview:self.boomRecomment];
    [self.scrollView addSubview:self.seriesAera];
    [self.scrollView addSubview:self.readMonster];
    [self.scrollView addSubview:self.themeAera];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-49);;
        make.right.equalTo(self.mas_right);
    }];
    // MARK: 轮播
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(self.mas_width);
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(self.cvHeight));
    }];
    // MARK: 分类
    [self.bookClasses mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(@(Screen_Width));
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(self.bcHeight));
    }];
    // MARK: 推荐阅读
    [self.boomRecomment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookClasses.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(@(Screen_Width));
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(self.brHeight));;
    }];
    // MARK: 系列专区
    [self.seriesAera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boomRecomment.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(@(Screen_Width));
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(self.saHeight));;
    }];
    // MARK: 主题
    [self.themeAera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seriesAera.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(@(Screen_Width));
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(self.taHeight));;
    }];
    // MARK: 阅读达人榜
    [self.readMonster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeAera.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(@(Screen_Width));
        make.right.equalTo(self.scrollView.mas_right);
        make.height.equalTo(@(self.rmHeight));;
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
    [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
}
- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{
            self.scrollView.backgroundColor = [UIColor whiteColor];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
        }
        case ECRHomeUITypeKidOne:{
        }
        case ECRHomeUITypeKidtwo:{
            
            if ([ECRMultiObject userInterfaceIdiomIsPad]) {
                self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
            }else{
                self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg_phone"]];
            }
        }
            break;
    }
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (SDCycleScrollView *)cycleView{
    if (_cycleView == nil) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageNamesGroup:nil];
        _cycleView.delegate = self;
//        _cycleView.bannerImageViewContentMode;
        NSLog(@"_cycleView.bannerImageViewContentMode -- %ld",_cycleView.bannerImageViewContentMode);
    }
    return _cycleView;
}
- (ECRBookClasses *)bookClasses{
    if (_bookClasses == nil) {
        _bookClasses = [[ECRBookClasses alloc] initWithFrame:CGRectZero height:self.bcHeight];
    }
    return _bookClasses;
}

- (ECRBoomRecomment *)boomRecomment{
    if (_boomRecomment == nil) {
        _boomRecomment = [[ECRBoomRecomment alloc] initWithFrame:CGRectZero height:self.brHeight];
    }
    return _boomRecomment;
}
- (ECRSeriesAera *)seriesAera{
    if (_seriesAera == nil) {
        _seriesAera = [[ECRSeriesAera alloc] initWithFrame:CGRectZero height:self.saHeight];
    }
    return _seriesAera;
}
- (ECRThemeAera *)themeAera{
    if (_themeAera == nil) {
        _themeAera = [[ECRThemeAera alloc] initWithFrame:CGRectZero height:self.taHeight];
    }
    return _themeAera;
}
- (ECRReadMonster *)readMonster{
    if (_readMonster == nil) {
        _readMonster = [[ECRReadMonster alloc] init];
    }
    return _readMonster;
}

- (CGFloat)cvHeight{
    // 130 轮播
    CGFloat h;
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        h = 285;
    }else{
        h = 130;
    }
    return h + 64;
}
- (CGFloat)bcHeight{
    // 126 分类
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 170;
    }
    return 146;
}
- (CGFloat)brHeight{
//    230 推荐
    CGFloat add = 33;
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 248 + add;
    }
    return 200 + add;
}
- (CGFloat)saHeight{
    // 系列
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 766;// 720 760
    }
    return 673;//
}
- (CGFloat)taHeight{
    // 220 主题
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 354;
    }
    return 220;
}
- (CGFloat)rmHeight{
    // 316 达人
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 382;
    }
    return 316;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end















