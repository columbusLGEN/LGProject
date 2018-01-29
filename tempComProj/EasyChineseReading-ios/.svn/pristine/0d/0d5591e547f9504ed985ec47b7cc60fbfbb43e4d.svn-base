//
//  LGPChangeLanguage.h
//  RGTestPorject
//
//  Created by Peanut Lee on 2017/10/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *LGPChangeLanguageNotification = @"LGPChangeLanguageNotification";

@interface LGPChangeLanguage : NSObject


/**
 获取当前app 语言环境

 @return 语言类型
 */
+ (NSString *)localAppLanguage;

/**
 判断当前app 语言环境是否为英文

 @return  1 = 是; 0 = 否
 */
+ (BOOL)currentLanguageIsEnglish;
+ (NSString *)localizedStringForKey:(NSString *)key;
+ (void)switchChineseToEnglishOrBack;
// -------------------------------------
+ (NSBundle *)bundle;//获取当前资源文件
+ (void)initUserLanguage;//初始化语言文件
+ (NSString *)userLanguage;//获取应用当前语言
+ (void)setUserlanguage:(NSString *)language;//设置当前语言

@end
