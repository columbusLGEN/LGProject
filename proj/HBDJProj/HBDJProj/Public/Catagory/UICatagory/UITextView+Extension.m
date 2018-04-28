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

@end
