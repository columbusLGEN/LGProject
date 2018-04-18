//
//  EDJHomeHeaderView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJHomeHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LGSegmentControl.h"

@interface EDJHomeHeaderView ()
@property (strong,nonatomic) SDCycleScrollView *imgLoop;

@end

@implementation EDJHomeHeaderView

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    NSLog(@"self.segment -- %@",self.segment);
//}

- (void)setImgURLStrings:(NSArray<NSString *> *)imgURLStrings{
    _imgLoop.imageURLStringsGroup = imgURLStrings;
}

- (void)setupUI{
    self.backgroundColor = [UIColor randomColor];
    /// MARK: 搜索框
//    [self addSubview:self.nav];
//    [self.nav mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.width.equalTo(@(kScreenWidth));
//        make.height.equalTo(@(navHeight()));
//    }];
    /// MARK: 轮播图
    [self addSubview:self.imgLoop];
    [self.imgLoop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(navHeight());
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(homeImageLoopHeight));
    }];
    /// MARK: segment
    [self addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.imgLoop.mas_bottom);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (EDJHomeNav *)nav{
    if (_nav == nil) {
        _nav = [[EDJHomeNav alloc] init];
    }
    return _nav;
}
- (SDCycleScrollView *)imgLoop{
    if (_imgLoop == nil) {
        _imgLoop = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
        _imgLoop.placeholderImage = nil;
        _imgLoop.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgLoop;
}
- (LGSegmentControl *)segment{
    if (_segment == nil) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < 3; i++) {
            LGSegmentControlModel *model = [LGSegmentControlModel new];
            model.title = segTitle(i);
            model.imageName = [NSString stringWithFormat:@"home_test%d",i];
            [arr addObject:model];
        }
        _segment = [[LGSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, homeSegmentHeight) models:arr.copy];
        _segment.elfColor = [UIColor EDJMainColor];
    }
    return _segment;
}
+ (CGFloat)headerHeight{
    return 319 + navHeight();
}

NSString *segTitle(int i){
    switch (i) {
        case 0:
            return @"微党课";
            break;
        case 1:
            return @"党建要闻";
            break;
        case 2:
            return @"数字阅读";
            break;
    }
    return @"微党课";
}
@end
