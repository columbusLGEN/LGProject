//
//  LGPChangeLanguage.m
//  RGTestPorject
//
//  Created by Peanut Lee on 2017/10/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

//#define LocalLanguageKey @"AppleLanguages"
#define LocalLanguageKey @"langeuageset"

#import "LGPChangeLanguage.h"

@implementation LGPChangeLanguage

static NSBundle *bundle = nil;

/// 1:英文,0:中文;其他语言也返回1
+ (BOOL)currentLanguageIsEnglish{
    NSString *currentlanguagee = [self localAppLanguage];
    if ([currentlanguagee hasPrefix:@"en"]) {
        //            currLanguage = @"en";
        return YES;
    }else if ([currentlanguagee hasPrefix:@"zh"]) {
        //            currLanguage = @"zh-Hans";
        return NO;
    }else {
        return YES;
    };
    
}

+ (NSString *)localizedStringForKey:(NSString *)key{
//    [self switchChineseToEnglishOrBack];
    NSString *language = [LGPChangeLanguage localAppLanguage];
    if ([language isEqualToString:@"en"]) {
        [LGPChangeLanguage setUserlanguage:@"en"];
    }else{
        [LGPChangeLanguage setUserlanguage:@"zh-Hans"];
    }
    return [[self bundle] localizedStringForKey:key value:nil table:@"Language"];
}

// appLanguage
+ (NSString *)localAppLanguage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
}

+ (void)switchChineseToEnglishOrBack{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LGPChangeLanguageNotification object:self];
}

+ (NSBundle *)bundle{
    if (bundle == nil) {
        [self initUserLanguage];
    }
    return bundle;
}

// ----------分割线
// 根据设备语言环境初始化语言
+ (void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *currLanguage = [def valueForKey:LocalLanguageKey];

    if(!currLanguage){
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        currLanguage = preferredLanguages[0];
        if ([currLanguage hasPrefix:@"en"]) {
            currLanguage = @"en";
        }else if ([currLanguage hasPrefix:@"zh"]) {
            currLanguage = @"zh-Hans";
        }else currLanguage = @"en";
        [def setValue:currLanguage forKey:LocalLanguageKey];
        [def synchronize];
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:currLanguage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

//获取当前语言
+ (NSString *)userLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:LocalLanguageKey];
    
    return language;
}
//设置语言
+ (void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:LocalLanguageKey];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:LocalLanguageKey];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}


@end
