//
//  ThemeFactory.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeFactory : NSObject

+ (UITabBarItem *)createTabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImageName;

@end

