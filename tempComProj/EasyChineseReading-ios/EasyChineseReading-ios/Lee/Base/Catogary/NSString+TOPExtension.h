//
//  NSString+TOPExtension.h
//  Top6000
//
//  Created by user on 16/10/22.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TOPExtension)

- (NSUInteger)ChineseCharacterCount;
/** 打印字符串中的汉字 测试用 */
- (void)hasChinese;
// MARK: 时间戳 转换 --- x分钟前，x小时前，x天前
- (NSString *)timeCalculation;
// MARK: 时间戳 转 日期 --- 2017-3-24
- (NSString *)dateByTimetemp;
// MARK: 计算时间戳距离今天又多少天
- (NSString *)dayCountByTimetemp;
// MARK: 获取系统当前时间戳
- (NSString *)getCurrentTimestamp;

// MARK: 多行字符串设置行间距
- (NSAttributedString *)setLineSpaceWithSpace:(CGFloat)space;

// MARK: MD5
- (NSString *)md5String;
// 根据字符串内容返回size
- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font;
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;

@end
