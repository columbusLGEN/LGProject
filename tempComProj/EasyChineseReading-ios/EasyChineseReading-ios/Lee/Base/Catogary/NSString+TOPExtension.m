//
//  NSString+TOPExtension.m
//  Top6000
//
//  Created by user on 16/10/22.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "NSString+TOPExtension.h"
#import "NSData+LEEEx.h"

@implementation NSString (TOPExtension)

- (NSUInteger)ChineseCharacterCount{
    NSUInteger ccCount = 0;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            ccCount += 1;
        }
    }
    return ccCount;
}
- (void)hasChinese{
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            NSRange range;
            range.length = 1;
            range.location = i;
            NSString *currentChar = [self substringWithRange:range];
            NSLog(@"currentChar -- %@",currentChar);
        }
    }
}

// MARK: 时间戳 转换
- (NSString *)timeCalculation{
    // 服务器返回的时间戳
    NSTimeInterval timeTemp = [self doubleValue];
    // 系统当前时间戳
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    double sec = timeNow - timeTemp;
    
    int timeText_int;
    if (sec > 86400) {// 大于一天
        timeText_int = sec / 86400.0;
        return [NSString stringWithFormat:@"%d天前",timeText_int];
    }else if (sec > 3600) {// 大于一小时
        timeText_int = sec / 3600.0;
        return [NSString stringWithFormat:@"%d小时前",timeText_int];
    }else if (sec > 60) {// 大于一分钟
        timeText_int = sec / 60.0;
        return [NSString stringWithFormat:@"%d分钟前",timeText_int];
    }else {
        return @"1分钟前";
    }
}
// MARK: 时间戳 转 日期
- (NSString *)dateByTimetemp{
    
    NSTimeInterval temp = [self doubleValue];
    
    NSDate *date = [[NSDate date] initWithTimeIntervalSince1970:temp];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy-MM-dd";
    
    return [df stringFromDate:date];
}
// MARK: 计算时间戳距离今天又多少天
- (NSString *)dayCountByTimetemp{
    
    NSTimeInterval temp = [self doubleValue];
    
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTemp = [now timeIntervalSince1970];
    
    double minusResult = temp - nowTemp;
    
    if (minusResult < 0) {
        // 说明已经结束
        return @"0";
    }else{
        int timeText_int;
        if (minusResult > 86400) {// 大于一天
            timeText_int = minusResult / 86400.0;
            return [NSString stringWithFormat:@"%d",timeText_int];
        }else{
            return @"1";
        }
    }
    return @"0";
}
// MARK: 获取系统当前时间戳
- (NSString*)getCurrentTimestamp {
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
    
}

- (NSAttributedString *)setLineSpaceWithSpace:(CGFloat)space{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

// MARK: MD5
- (NSString *)md5String{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data md5String];
}


// MARK：根据内容返回size
- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font {
    return [text sizeOfTextWithMaxSize:maxSize font:font];
}



@end
