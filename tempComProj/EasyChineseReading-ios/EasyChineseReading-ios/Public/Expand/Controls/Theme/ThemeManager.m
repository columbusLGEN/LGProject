//
//  ThemeManager.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ThemeManager.h"

static ThemeManager *shareThemeManager;

@implementation ThemeManager

- (id)init
{
    if (self = [super init]) {
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.dicThemePlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        NSInteger skinType = [LGSkinSwitchManager getCurrentUserSkin];
        switch (skinType) {
            case ECRHomeUITypeDefault:{
                self.themeName = @"成人一";
            }
                break;
            case ECRHomeUITypeAdultTwo:{
                self.themeName = @"成人二";
            }
                break;
            case ECRHomeUITypeKidOne:{
                self.themeName = @"儿童一";
            }
                break;
            case ECRHomeUITypeKidtwo:{
                self.themeName = @"儿童二";
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

+ (ThemeManager *)sharedThemeManager
{
    @synchronized (self) {
        if (!shareThemeManager) {
            shareThemeManager = [[ThemeManager alloc] init];
        }
    }
    return shareThemeManager;
}


/**
 重写 setThemeName 方法
 */
- (void)setThemeName:(NSString *)themeName
{
    _themeName = themeName;
}

/**
 根据主题图片位置获取主题相关图片
 */
- (UIImage *)themeImageWithName:(NSString *)imageName
{
    if (imageName == nil)
        return nil;
    
    NSString *themePath = [self themePath];
    NSString *themeImagePath = [themePath stringByAppendingPathComponent:imageName];
    UIImage *themeImage = [UIImage imageWithContentsOfFile:themeImagePath];
    
    // 主题图片中为png、jpg混用(非透明大图使用jpg)，如果png未检测到图片，则切换图片后缀并重新加载图片
    if (!themeImage) {
        imageName = [imageName substringToIndex:imageName.length - 4];
        imageName = [imageName stringByAppendingString:@".jpg"];
        themeImagePath = [themePath stringByAppendingPathComponent:imageName];
        themeImage = [UIImage imageWithContentsOfFile:themeImagePath];
    }
    
    return themeImage;
}

/**
 主题路径
 */
- (NSString *)themePath
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    if (self.themeName == nil || [self.themeName isEqualToString:@""])
        return [resourcePath stringByAppendingString:@"/Skins/Adult/one"];
    
    NSString *themePath = [self.dicThemePlist objectForKey:self.themeName];
    NSString *themeFilePath = [resourcePath stringByAppendingPathComponent:themePath];
    
    return themeFilePath;
}

@end
