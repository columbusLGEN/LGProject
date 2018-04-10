//
//  NSString+Extension.h
//  LGProject
//
//  Created by Peanut Lee on 2018/1/5.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)


/**
 @return 当前时间戳
 */
+ (NSString*)getCurrentTimestamp;
/**
 计算时间戳距离今天有多少天
 @return 天数
 */
- (NSString *)dayCountByTimetemp;
/**
 时间戳 --> 日期
 @return 日期 eg: 2018-1-5
 */
- (NSString *)timestampToDate;
/**
 时间戳 --> x分钟前，x小时前，x天前
 @return 描述性结果
 */
- (NSString *)timestampToDescription;
/**
 MD5
 @return 加密后的字符串
 */
- (NSString *)md5String;
/**
 给字符串添加行间距
 @param space 间距
 @return 增加间距之后的字符串
 */
- (NSAttributedString *)setLineSpaceWithSpace:(CGFloat)space;
/**
 计算文本内容的size

 @param maxSize 最大size,如果计算文字高度要给定宽度,如果计算文字宽度要给定高度 eg: (200,MAXFLOAT) 表示 在200宽度内计算文字高度
 @param font 字体大小
 @return 返回结果
 */
- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font;
@end
