//
//  NSString+ChineseCharactersToSpelling.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NSString+ChineseCharactersToSpelling.h"

@implementation NSString (ChineseCharactersToSpelling)

+(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:chinese];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //返回小写拼音
    return [str lowercaseString];
}

@end
