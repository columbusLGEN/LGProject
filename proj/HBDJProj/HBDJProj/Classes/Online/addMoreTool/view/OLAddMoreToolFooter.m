//
//  OLAddMoreToolFooter.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLAddMoreToolFooter.h"

@interface OLAddMoreToolFooter ()
@property (strong,nonatomic) UILabel *title;

@end

@implementation OLAddMoreToolFooter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(marginTwenty);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-marginTwenty);
        }];
    }
    return self;
}

- (UILabel *)title{
    if (_title == nil) {
        _title = [UILabel new];
        _title.numberOfLines = 0;
        _title.textColor = [UIColor EDJGrayscale_33];
        _title.font = [UIFont systemFontOfSize:15];
        
//        NSString *phoneNumber = @"027-87679599";
        NSString *phoneNumber = [NSUserDefaults.standardUserDefaults objectForKey:dj_service_numberKey];
        
        NSDictionary *attrStrDict = @{NSForegroundColorAttributeName:[UIColor EDJColor_FC774E]};
        
        NSString *originString = [@"特别提示:定制工具需用户所在单位党组织开通后方可添加。\n开通咨询电话:" stringByAppendingString:phoneNumber];
        
        NSMutableAttributedString *destiStr = [[NSMutableAttributedString alloc] initWithString:originString];
        
        [destiStr setAttributes:attrStrDict range:NSMakeRange([originString rangeOfString:phoneNumber].location, [originString rangeOfString:phoneNumber].length)];
        
        _title.attributedText = destiStr;
        
    }
    return _title;
}

@end
