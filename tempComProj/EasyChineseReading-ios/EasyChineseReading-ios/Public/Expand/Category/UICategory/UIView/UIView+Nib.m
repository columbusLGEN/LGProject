//
//  UIView+Nib.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView(Nib)

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class])
                          bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadFromNib
{
    NSString * class_name = NSStringFromClass([self class]);
    NSArray *nibs =  [[NSBundle mainBundle] loadNibNamed:class_name owner:self options:nil];
    return [nibs firstObject];
}

+ (instancetype)loadFromNibWithFrame:(CGRect)frame
{
    UIView * nibView = [self loadFromNib];
    nibView.frame = frame;
    return nibView;
}

@end
