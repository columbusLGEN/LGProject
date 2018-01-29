//
//  UIImage+LGExtension.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/8.
//  Copyright © 2018年 retech. All rights reserved.
//

#import "UIImage+LGExtension.h"

@implementation UIImage (LGExtension)

+ (void)load{
    
    Method origin_method = class_getClassMethod([self class], @selector(imageNamed:));
    Method instead_lg_method = class_getClassMethod([self class], @selector(lg_imageNamed:));
    method_exchangeImplementations(origin_method, instead_lg_method);
}

+ (UIImage *)lg_imageNamed:(NSString *)name{
    if ([self lg_imageNamed:name])
        return [self lg_imageNamed:name];
    else
        return [[ThemeManager sharedThemeManager] themeImageWithName:[name stringByAppendingString:@".png"]];
}

@end
