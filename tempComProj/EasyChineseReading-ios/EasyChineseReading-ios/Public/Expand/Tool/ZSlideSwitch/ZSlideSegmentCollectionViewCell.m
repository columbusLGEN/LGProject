//
//  ZSlideSegmentCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ZSlideSegmentCollectionViewCell.h"

@implementation ZSlideSegmentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    _lblTitle = [[UILabel alloc] init];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.font = [UIFont systemFontOfSize:16.f];
    _lblTitle.textColor = [UIColor cm_blackColor_333333_1];
    [self.contentView addSubview:_lblTitle];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lblTitle.frame = self.bounds;
}

- (void)dataDidChange
{
    NSString *title = self.data;
    _lblTitle.text = title;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _lblTitle.textColor = isSelected ? [UIColor cm_mainColor] : [UIColor cm_blackColor_333333_1];
}

@end
