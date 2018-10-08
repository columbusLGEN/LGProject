//
//  UITextView+Extension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)lg_setplaceHolderTextWithText:(NSString *)text textColor:(UIColor *)color font:(NSInteger)font{
    UILabel *placeHolder = [UILabel new];
    placeHolder.text = text;
    placeHolder.textColor = color;
    placeHolder.font = [UIFont systemFontOfSize:font];
    [placeHolder sizeToFit];
    [self addSubview:placeHolder];
    [self setValue:placeHolder forKey:@"_placeholderLabel"];
}

- (void)lg_setLimitTextLabelWithLength:(NSString *)lengthText superView:(UIView *)superView label:(UILabel *)label{
    label.text = [@"0/" stringByAppendingString:lengthText];
    label.textColor = UIColor.EDJColor_c2c0c0;
    label.font = [UIFont systemFontOfSize:12];
    
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-marginFive);
        make.bottom.equalTo(self.mas_bottom).offset(-marginFive);
    }];
}

@end
