//
//  MultiLanguageUtil.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/25.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCALIZATION(text) [[MultiLanguageUtil shareInstance] localizedStringForKey:(text)]

@interface MultiLanguageUtil : NSObject

/**
 *  @brief 当前语言
 */
@property (strong, nonatomic) NSString *currentLanguage;

/**
 *  @brief 多语言工具实例
 *
 *  @return 多语言工具
 */
+ (instancetype)shareInstance;

/**
 *  @brief 获取多语言名字
 *
 *  @param key 语言内容Key
 *
 *  @return 正确的多语言值
 */
- (NSString *)localizedStringForKey:(NSString*)key;

@end
