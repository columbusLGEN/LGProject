//
//  NSString+Extension.m
//  LGProject
//
//  Created by Peanut Lee on 2018/1/5.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Extension)

// MARK: 获取系统当前时间戳
+ (NSString*)getCurrentTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
// MARK: 计算时间戳距离今天有多少天
- (NSString *)dayCountByTimetemp{
    NSTimeInterval temp = [self doubleValue];
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTemp = [now timeIntervalSince1970];
    double minusResult = temp - nowTemp;
    if (minusResult < 0) {
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
// MARK: 时间戳 --> 日期
- (NSString *)timestampToDate{
    NSTimeInterval temp = [self doubleValue];
    NSDate *date = [[NSDate date] initWithTimeIntervalSince1970:temp];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    return [df stringFromDate:date];
}
// MARK: 时间戳 --> x分钟前等
- (NSString *)timestampToDescription{
    //    1218154088
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
// MARK: MD5
- (NSString *)md5String{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    const char *str = [data bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)data.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return hash;
}
// MARK: 给文本内容添加行间距
- (NSAttributedString *)setLineSpaceWithSpace:(CGFloat)space{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

// MARK：根据内容返回size
- (CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
