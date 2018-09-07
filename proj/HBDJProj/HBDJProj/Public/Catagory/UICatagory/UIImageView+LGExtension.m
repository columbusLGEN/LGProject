//
//  UIImageView+LGExtension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIImageView+LGExtension.h"

@implementation UIImageView (LGExtension)

- (void)addLittleRedDot{
    UIView *lrd = UIView.new;
    [lrd cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:4];
    lrd.backgroundColor = UIColor.redColor;
    [self addSubview:lrd];
    [lrd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(marginEight);
        make.right.equalTo(self.mas_right).offset(2);
        make.top.equalTo(self.mas_top).offset(-2);
    }];
    NSLog(@"self.subviews: %@",self.subviews);
}

- (void)removeLittleRedDot{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSLog(@"self.subviews: %@",self.subviews);
}

@end
