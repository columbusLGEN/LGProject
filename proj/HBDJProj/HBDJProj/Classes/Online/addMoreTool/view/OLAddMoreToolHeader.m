//
//  OLAddMoreToolHeader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLAddMoreToolHeader.h"

@interface OLAddMoreToolHeader ()
@property (strong,nonatomic) UILabel *title;

@end

@implementation OLAddMoreToolHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(marginTwenty);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)title{
    if (_title == nil) {
        _title = [UILabel new];
        _title.textColor = [UIColor EDJGrayscale_33];
        _title.font = [UIFont systemFontOfSize:17];
        _title.text = @"请选择要添加的工具:";
    }
    return _title;
}

@end
