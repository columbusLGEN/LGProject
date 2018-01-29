//
//  ECRSeriesAera.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

//static CGFloat svHeight = 140;// son view
static CGFloat margin = 12;
static CGFloat marginB = 16;

#import "ECRSeriesAera.h"
#import "ECRSeriesBooksView.h"
#import "ECRHeadlineView.h"
#import "ECRSeriesModel.h"

@interface ECRSeriesAera ()
@property (assign,nonatomic) CGFloat svHeight;// = (总高度 - 4 * 间距) / 3
@property (assign,nonatomic) CGFloat headLineHeight;//

@end

@implementation ECRSeriesAera

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height{
    self.svHeight = (height - 4 * marginB) / 3 - 6;
    return [self initWithFrame:frame];
}

- (void)setSeriesModels:(NSArray<ECRSeriesModel *> *)seriesModels{
    _seriesModels = seriesModels;

}
- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    // bys_11
    [self addSubview:self.headLine];
    [self addSubview:self.viewFirst];
    [self addSubview:self.viewSecond];
    [self addSubview:self.viewThird];
    
    self.headLine.showMore = NO;
    
    [self.headLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(self.headLineHeight));
    }];
    [self.viewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headLine.mas_bottom);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
        make.height.equalTo(@(self.svHeight));
    }];
    // bys_12
    [self.viewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewFirst.mas_bottom).offset(margin);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
        make.height.equalTo(@(self.svHeight));
    }];
    // bys_13
    [self.viewThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewSecond.mas_bottom).offset(margin);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
        make.height.equalTo(@(self.svHeight));
    }];
    [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
}
- (void)skinWithType:(ECRHomeUIType)type{
//    switch (type) {
//        case ECRHomeUITypeDefault:{
//        }
//        case ECRHomeUITypeAdultTwo:{
//        }
//            break;
//        case ECRHomeUITypeKidOne:{
//            _headLine.iconImgName = @"icon_headline_duck";
//        }
//            break;
//        case ECRHomeUITypeKidtwo:{
//            
//        }
//            break;
//    }
    _headLine.iconImgName = @"icon_home_series";
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

- (ECRHeadlineView *)headLine{
    if (_headLine == nil) {
        _headLine = [[ECRHeadlineView alloc] init];
//        _headLine.backgroundColor = [UIColor orangeColor];
        _headLine.headTitle = @"系列专区";
    }
    return _headLine;
}
- (ECRSeriesBooksView *)viewFirst{
    if (_viewFirst == nil) {
        _viewFirst = [[ECRSeriesBooksView alloc] initWithFrame:CGRectZero height:self.svHeight];
        _viewFirst.imgName = @"bys_11";
    }
    return _viewFirst;
}
- (ECRSeriesBooksView *)viewSecond{
    if (_viewSecond == nil) {
        _viewSecond = [[ECRSeriesBooksView alloc] initWithFrame:CGRectZero height:self.svHeight];
        _viewSecond.imgName = @"bys_12";
    }
    return _viewSecond;
}
- (ECRSeriesBooksView *)viewThird{
    if (_viewThird == nil) {
        _viewThird = [[ECRSeriesBooksView alloc] initWithFrame:CGRectZero height:self.svHeight];
        _viewThird.imgName = @"bys_13";
    }
    return _viewThird;
}
- (CGFloat)headLineHeight{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 46;
    }else{
        return 36;
    }
}

@end
