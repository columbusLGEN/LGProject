//
//  MultiLanguageUtil.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/25.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "MultiLanguageUtil.h"

static NSString * const kSaveLanguageDefaultKey = @"kSaveLanguageDefaultKey";
static NSString * const LanguageFileName = @"Localizable";

@interface MultiLanguageUtil()

@property (strong, nonatomic) NSDictionary *dicLanguage;

@end

@implementation MultiLanguageUtil
@synthesize currentLanguage=_currentLanguage;

/**
 *  @brief 多语言工具实例
 *
 *  @return 多语言工具
 */
+ (instancetype)shareInstance
{
    static MultiLanguageUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MultiLanguageUtil alloc] init];
    });
    
    return instance;
}

- (NSString *)localizedStringForKey:(NSString*)key
{
    // 获取当前保存在 UserDeufaults 的本地语言
    NSString *currentLanguage = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]];
    // 根据获取语言文件所在的路径 文件类型Type 为lproj, 即.lprojd 的文件夹 zh.lproj 和 en.lproj
    NSString *LanguagePath = [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"];
    // 根据键值获取结果 // table为语言文件Language.strings
    NSString *response = [[NSBundle bundleWithPath:LanguagePath] localizedStringForKey:key value:nil table:@"Language"];
    
    return response;
}



//
//+ (void)load
//{
//    [super load];
//    [[self shareInstance] loadDictionaryForLanguage];
//}
//
///**
// *  @brief 设置当前语言
// *
// *  @param currentLanguage 当前语言
// */
//- (void)setCurrentLanguage:(NSString *)currentLanguage
//{
//    _currentLanguage = currentLanguage;
//    [[NSUserDefaults standardUserDefaults] setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self loadDictionaryForLanguage];
//}
//
//- (NSString*)currentLanguage
//{
//    if ([NSString isEmpty:_currentLanguage]) {
//        NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveLanguageDefaultKey];
//        if ([NSString isEmpty:temp]) {
//            temp = @"DeviceLanguage";
//        }
//        _currentLanguage = temp;
//    }
//    return _currentLanguage;
//}
//
///**
// *  @brief 加载多语言到字典中
// */
//- (void)loadDictionaryForLanguage
//{
//    //第一版本 为中文版 以后 会国际化
//    _currentLanguage = @"zh-Hans";
//
//
//    NSURL * urlPath = [[NSBundle bundleForClass:[self class]] URLForResource:LanguageFileName withExtension:@"strings" subdirectory:nil localization:self.currentLanguage];
//
//    if ([[NSFileManager defaultManager] fileExistsAtPath:urlPath.path])
//    {
//        self.dicLanguage = [NSDictionary dictionaryWithContentsOfFile:urlPath.path];
//    }
//}

//- (NSString *)localizedStringForKey:(NSString*)key
//{
//    NSString * localizedString = nil;
//    if (self.dicLanguage == nil)
//    {
//        localizedString =  [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:LanguageFileName];
//    }
//    else
//    {
//        localizedString = self.dicLanguage[key];
//        if (localizedString == nil)
//            localizedString = key;
//    }
//    return localizedString;
//}

@end
