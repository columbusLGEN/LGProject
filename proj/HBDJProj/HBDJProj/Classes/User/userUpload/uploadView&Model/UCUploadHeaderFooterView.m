//
//  UCUploadHeaderView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadHeaderFooterView.h"

@interface UCUploadHeaderFooterView ()
@property (weak,nonatomic) UIView *rectangleView;
@property (weak,nonatomic) UILabel *title;

@end

@implementation UCUploadHeaderFooterView

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [_title setText:titleText];
}

- (void)setupUI{
    UIView *rectangleView = [UIView new];
    _rectangleView = rectangleView;
    rectangleView.backgroundColor = [UIColor EDJMainColor];
    [self addSubview:rectangleView];
    
    UILabel *title = [UILabel new];
    _title = title;
    title.font = [UIFont systemFontOfSize:19];
    title.textColor = [UIColor EDJGrayscale_66];
    [self addSubview:title];
    
    [rectangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(18);;
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rectangleView.mas_centerY);
        make.left.equalTo(rectangleView.mas_right).offset(marginTen);
    }];
    
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


@end
