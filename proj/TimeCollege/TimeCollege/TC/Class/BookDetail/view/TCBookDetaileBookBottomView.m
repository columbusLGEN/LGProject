//
//  TCBookDetaileBookBottomView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDetaileBookBottomView.h"

@interface TCBookDetaileBookBottomView ()


@end

@implementation TCBookDetaileBookBottomView

+ (instancetype)bookDetailBottomv{
    return [NSBundle.mainBundle loadNibNamed:@"TCBookDetaileBookBottomView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.borrowRead cutBorderWithBorderWidth:1 borderColor:UIColor.TCColor_mainColor cornerRadius:18];
    
    UIColor *textColor = UIColor.YBColor_6A6A6A;
    [self.borrowAgain setTitleColor:textColor forState:UIControlStateNormal];
    [self.back setTitleColor:textColor forState:UIControlStateNormal];
    [self.tipRead setTitleColor:textColor forState:UIControlStateNormal];
    
    
}

@end
