//
//  ThemeTabBarItem.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ThemeTabBarItem.h"

@implementation ThemeTabBarItem

// 初始化时注册观察者
- (id) init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:kNotificationThemeChanged object:nil];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    if (self = [self init]) {
        self.title = title;
        // 调用[self setImageName:imageName] ---> [self reloadThemeImage] ---> [self setImage:image]
        self.imageName = imageName;
        // 调用[self setSelectedImageName:selectedImageName];
        self.selectedImageName = selectedImageName;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Override Setter

- (void) setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    
    [self reloadThemeImage];
}

- (void) setSelectedImageName:(NSString *)selectedImageName {
    if (_selectedImageName != selectedImageName) {
        _selectedImageName = selectedImageName;
    }
    
    [self reloadThemeImage];
}

// 主题改变之后重新加载图片
- (void)themeChangedNotification:(NSNotification *)notification {
    [self reloadThemeImage];
}

- (void)reloadThemeImage {
    ThemeManager * themeManager = [ThemeManager sharedThemeManager];
    
    if (self.imageName != nil) {
        UIImage * image = [themeManager themeImageWithName:self.imageName];
        [self setImage:image];
    }
    
    if (self.selectedImageName != nil) {
        UIImage * selectedImage = [themeManager themeImageWithName:self.selectedImageName];
        [self setSelectedImage:selectedImage];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
