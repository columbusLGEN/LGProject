//
//  UIColor+EDJColor.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIColor+EDJColor.h"

@implementation UIColor (EDJColor)

+ (UIColor *)EDJMainColor{
    return [self colorWithHexString:@"FF4C3E"];
}
+ (UIColor *)EDJGrayscale_EC{
    return [self colorWithHexString:@"ECECEC"];
}
+ (UIColor *)EDJGrayscale_F4{
    return [self colorWithHexString:@"F4F4F4"];
}
+ (UIColor *)EDJGrayscale_88{
    return [self colorWithHexString:@"888888"];
}

@end
