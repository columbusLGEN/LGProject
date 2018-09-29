//
//  RegisterBottomInfoView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "RegisterBottomInfoView.h"

@interface RegisterBottomInfoView ()
@property (weak, nonatomic) UILabel *tbts;
@property (weak, nonatomic) UILabel *content_tbts;

@property (weak, nonatomic) UILabel *ktdh;
@property (weak, nonatomic) UILabel *content_ktdh;


@end

@implementation RegisterBottomInfoView

- (void)setupUI{
    
    CGFloat textFont = 15;
    
    NSString *str0 = @"特别提示:";
    NSString *blackStr = @":";
    NSDictionary *attrDict0 = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSMutableAttributedString *muStr0 = [[NSMutableAttributedString alloc] initWithString:str0];
    [muStr0 setAttributes:attrDict0 range:NSMakeRange([str0 rangeOfString:blackStr].location, [str0 rangeOfString:blackStr].length)];
    _tbts.attributedText = muStr0;
    
    /// 原始字符串
    NSString *str1 = @"咨询电话:";
    /// 需要改变颜色的字符串 @":"
    /// 属性字典，包含了需要的颜色
    NSDictionary *attrDict1 = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    /// 可变字符串(最中目标)
    NSMutableAttributedString *muStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
    /// 将属性字典设置给可变字符串，并指定范围
    [muStr1 setAttributes:attrDict1 range:NSMakeRange([str1 rangeOfString:blackStr].location, [str1 rangeOfString:blackStr].length)];
    
    NSString *content0 = @"本软件需用户所在单位党组织统一开通后方可通过使用";
    NSString *localServiceNumber = [NSUserDefaults.standardUserDefaults objectForKey:dj_service_numberKey];
    NSString *content1 = localServiceNumber;
    
    UILabel *tbts = [UILabel new];
    tbts.textColor = [UIColor EDJMainColor];
    tbts.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:tbts];
    _tbts = tbts;
    
    UILabel *content_tbts = [UILabel new];
    content_tbts.numberOfLines = 0;
    content_tbts.textColor = [UIColor blackColor];
    content_tbts.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:content_tbts];
    _content_tbts = content_tbts;
    
    UILabel *ktdh = [UILabel new];
    ktdh.textColor = [UIColor EDJMainColor];
    ktdh.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:ktdh];
    _ktdh = ktdh;
    
    UILabel *content_ktdh = [UILabel new];
    content_ktdh.textColor = [UIColor blackColor];
    content_ktdh.font = [UIFont systemFontOfSize:textFont];
    [self addSubview:content_ktdh];
    _content_ktdh = content_ktdh;
    
    [tbts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(75);
    }];
    [content_tbts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(tbts.mas_right).offset(marginEight);
        make.right.equalTo(self.mas_right);
    }];
    [ktdh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_tbts.mas_bottom).offset(marginFifteen);
        make.left.equalTo(self.mas_left);
    }];
    [content_ktdh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ktdh.mas_right).offset(marginEight);
        make.top.equalTo(ktdh.mas_top);
    }];
    
    tbts.attributedText = muStr0;
    content_tbts.text = content0;
    ktdh.attributedText = muStr1;
    content_ktdh.text = content1;
    
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
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
@end
