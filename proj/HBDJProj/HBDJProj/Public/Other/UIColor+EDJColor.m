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
    return [self colorWithHexString:@"F4F4F4"];// 244
}
+ (UIColor *)EDJGrayscale_88{
    return [self colorWithHexString:@"888888"];
}
+ (UIColor *)EDJGrayscale_F3{
    return [self colorWithHexString:@"F3F3F3"];// 243
}
+ (UIColor *)EDJGrayscale_C6{
    return [self colorWithHexString:@"C6C6C6"];
}
+ (UIColor *)EDJGrayscale_33{/// 51,51,51
    return [self colorWithHexString:@"333333"];
}
+ (UIColor *)EDJColor_9B1212{
    return [self colorWithHexString:@"9B1212"];
}
+ (UIColor *)EDJColor_A2562C{/// 163,86,44
    return [self colorWithHexString:@"A2562C"];
}

@end
