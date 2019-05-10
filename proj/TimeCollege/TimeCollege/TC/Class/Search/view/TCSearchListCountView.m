//
//  TCSearchListCountView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSearchListCountView.h"

@interface TCSearchListCountView ()
@property (weak,nonatomic) UILabel *countLabel;

@end

@implementation TCSearchListCountView

- (void)setCount:(NSString *)count{
    _count = count;
    NSString *text = [@"共" stringByAppendingPathComponent:@"%@条"];
    _countLabel.text = text;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *line0 = UIView.new;
        UIView *line1 = UIView.new;
        UIColor *lineColor = UIColor.YBColor_F3F3F3;
        line0.backgroundColor = lineColor;
        line1.backgroundColor = lineColor;
        [self addSubview:line0];
        [self addSubview:line1];
        
        UILabel *countLabel = UILabel.new;
        countLabel.text = @"共188条";
        countLabel.textColor = UIColor.YBColor_6A6A6A;
        countLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:countLabel];
        _countLabel = countLabel;
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
        }];
        [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
//            make.width.mas_equalTo(Screen_Width * 0.5 * 0.7);
            make.left.equalTo(self.mas_left).offset(Screen_Width * 0.5 * 0.1);
            make.right.equalTo(countLabel.mas_left).offset(-20);
            make.height.mas_equalTo(1);
        }];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(line0);
//            make.width.equalTo(line0);
            make.left.equalTo(countLabel.mas_right).offset(20);
            make.right.equalTo(self.mas_right).offset(-(Screen_Width * 0.5 * 0.1));
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

@end
