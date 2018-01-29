//
//  NSString+Category.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NSString+Category.h"
#import "spelling.h"

@implementation NSString (Category)


+ (BOOL)isEmpty:(NSString *)aString{
    BOOL ret = NO;
    if ((aString == nil) || ([[aString trim] length] == 0) || [aString isKindOfClass:[NSNull class]])
        ret = YES;
    return ret;
}

+ (NSString *)firstLetter:(NSString*)aString
{
    NSString *firstLetter = @"#";
    if (![NSString isEmpty:aString]) {
        char firstLetterChar = pinyinFirstLetter([aString characterAtIndex:0]);
        if (firstLetterChar >= 'a' && firstLetterChar <= 'z') {
            firstLetterChar = firstLetterChar - 32;
        }
        if (firstLetterChar >= 'A' && firstLetterChar <= 'Z') {
            firstLetter = [NSString stringWithFormat:@"%c",firstLetterChar];
        }
    }
    return firstLetter;
}

+ (NSArray *)indexLetters
{
    static NSMutableArray *indexTitleArray = nil;
    if (!indexTitleArray) {
        indexTitleArray = [NSMutableArray array];
        for (char c = 'A'; c <= 'Z'; c++) {
            [indexTitleArray addObject:[NSString stringWithFormat:@"%c", c]];
        }
        [indexTitleArray addObject:@"#"];
    }
    return indexTitleArray;
}
-(BOOL)isCharacter
{
    if (![NSString isEmpty:self]) {
        if (self.length > 0) {
            NSString *subString=[self substringWithRange:NSMakeRange(0, 1)];
            const char *cString=[subString UTF8String];
            return strlen(cString) == 1 ;
        }
    }
    return NO;
}

/**
 * 获取字符长度
 */
- (NSInteger)charLength
{
    if (self && self.length > 0)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData * data = [self dataUsingEncoding:enc];
        return [data length];
    }
    return 0;
}

/**
 * 从0开始截图字符长度为charLength的字符串，如果节点上市汉字 则截取charLength-1个字符
 */
- (NSString *)subStringWithCharLenth:(NSInteger)charLength
{
    if ([NSString isEmpty:self])
    {
        return nil;
    }
    if ([self charLength] <= charLength)
    {
        return self;
    }
    NSString * result = @"";
    for (int i = 0; i < self.length; i ++)
    {
        NSString * str = [self substringWithRange:NSMakeRange(i, 1)];
        result = [result stringByAppendingString:str];
        if ([result charLength] > charLength)
        {
            result = [result substringWithRange:NSMakeRange(0, result.length - 1)];
            break;
        }
    }
    
    return result;
}
/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

//转换成 2015年02月01日
+(NSString *)convertDateWithString:(NSString *)dateStr andtype:(int)type
{
    NSDateFormatter *formtter1 = [[NSDateFormatter alloc] init];
    formtter1.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    formtter.dateFormat = @"yyyy/MM/dd HH:mm";
    if (type == 0) {
        formtter.dateFormat = @"yyyy/MM/dd HH:mm";
    }else if (type == 1){
        formtter.dateFormat = @"yyyy年MM月dd日" ;
    }else if(type == 2){
        formtter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    }
    
    NSString *date = [formtter stringFromDate:[formtter1 dateFromString:dateStr]];
    return date;
}

/**
 *   浮点型 转 字符串 没有多余的零
 *传 float  得到 nsstring
 */
+(NSString *)returnStringWithFloat:(float)floatNum
{
    NSString *stringFloat = [NSString stringWithFormat:@"%.4f",floatNum];
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

/**
 * 按最长字符长度截取字符串
 */
-(NSString *)returnCharMaxLengthStringWith:(float)maxLength
{
    if ([self charLength] > maxLength && ![NSString isEmpty:self] && maxLength > 1) {
        int maxNum = 0;
        NSString *subString = @"";
        for (int i=0;i<self.length;i++)
        {
            NSString *unitStr = [self substringWithRange:NSMakeRange(i, 1)];
            if (maxNum > (maxLength-2)) {
                return subString;
            }
            maxNum += [unitStr charLength];
            subString = [subString stringByAppendingString:unitStr];
        }
    }
    return self;
}


- (NSString *)URLEncoding
{
    return (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
}

- (NSString *)URLDecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
    if ( self.length >= 2 )
    {
        if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
        
        if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }
    
    return self;
}

- (NSString *)normalize
{
    //	return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    //	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ( lines && lines.count )
    {
        NSMutableString * mergedString = [NSMutableString string];
        
        for ( NSString * line in lines )
        {
            NSString * trimed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ( trimed && trimed.length )
            {
                [mergedString appendString:trimed];
            }
        }
        
        return mergedString;
    }
    
    return nil;
}

- (NSString *)repeat:(NSUInteger)count
{
    if ( 0 == count )
        return @"";
    
    NSMutableString * text = [NSMutableString string];
    
    for ( NSUInteger i = 0; i < count; ++i )
    {
        [text appendString:self];
    }
    
    return text;
}

- (NSString *)strongify
{
    return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)match:(NSString *)expression
{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    if ( nil == regex )
        return NO;
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, self.length)];
    if ( 0 == numberOfMatches )
        return NO;
    
    return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
    for ( NSString * str in array )
    {
        if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)empty
{
    return (self == nil || [self isEqualToString:@""] || [self length] == 0) ? YES : NO;
}

- (BOOL)notEmpty
{
    return (self != nil && ![self isEqualToString:@""] && [self length] > 0) ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
    return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
    return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
    NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
    
    for ( NSObject * obj in array )
    {
        if ( NO == [obj isKindOfClass:[NSString class]] )
            continue;
        
        if ( NSOrderedSame == [(NSString *)obj compare:self options:option] )
            return YES;
    }
    
    return NO;
}

- (BOOL)isNumber
{
    NSString *		regex = @"-?[0-9]+";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

// 判断是否是密码格式(a-z,A-Z,0-9,8-16位长度)
- (BOOL)isPassword
{
//    NSString *regex   = @"(^[A-Za-z0-9]{8,16}$)";
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)notPassword
{
    return ![self isPassword];
}

- (BOOL)isPasswordWithMinLength:(NSInteger)minL maxLength:(NSInteger)maxL
{
    NSString *regex   = [NSString stringWithFormat:@"(^[A-Za-z0-9]{%ld,%ld}$)", minL, maxL];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPhone
{
//    NSString *		regex = @"^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$"; // 国际电话 2-3位国际区号 - 2-3位区号 - 7-8位电话号 - 3位分机号
//    NSString *		regex = @"^((d{2,3}-)?(d{7,8})?"; // 2-3位区号 7-8位电话号
    NSString *      phone = @"^1\\d{10}";   // 中国手机号
//    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSPredicate *  preds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    return [preds evaluateWithObject:self];
}

// --------------国际手机号正则表达----------------

//'ar-DZ': /^(\+?213|0)(5|6|7)\d{8}$/,
//'ar-SY': /^(!?(\+?963)|0)?9\d{8}$/,
//'ar-SA': /^(!?(\+?966)|0)?5\d{8}$/,
//'en-US': /^(\+?1)?[2-9]\d{2}[2-9](?!11)\d{6}$/,
//'cs-CZ': /^(\+?420)? ?[1-9][0-9]{2} ?[0-9]{3} ?[0-9]{3}$/,
//'de-DE': /^(\+?49[ \.\-])?([\(]{1}[0-9]{1,6}[\)])?([0-9 \.\-\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$/,
//'da-DK': /^(\+?45)?(\d{8})$/,
//'el-GR': /^(\+?30)?(69\d{8})$/,
//'en-AU': /^(\+?61|0)4\d{8}$/,
//'en-GB': /^(\+?44|0)7\d{9}$/,
//'en-HK': /^(\+?852\-?)?[569]\d{3}\-?\d{4}$/,
//'en-IN': /^(\+?91|0)?[789]\d{9}$/,
//'en-NZ': /^(\+?64|0)2\d{7,9}$/,
//'en-ZA': /^(\+?27|0)\d{9}$/,
//'es-ES': /^(\+?34)?(6\d{1}|7[1234])\d{7}$/,
//'fi-FI': /^(\+?358|0)\s?(4(0|1|2|4|5)?|50)\s?(\d\s?){4,8}\d$/,
//'fr-FR': /^(\+?33|0)[67]\d{8}$/,
//'he-IL': /^(\+972|0)([23489]|5[0248]|77)[1-9]\d{6}/,
//'hu-HU': /^(\+?36)(20|30|70)\d{7}$/,
//'it-IT': /^(\+?39)?\s?3\d{2} ?\d{6,7}$/,
//'ja-JP': /^(\+?81|0)\d{1,4}[ \-]?\d{1,4}[ \-]?\d{4}$/,
//'ms-MY': /^(\+?6?01){1}(([145]{1}(\-|\s)?\d{7,8})|([236789]{1}(\s|\-)?\d{7}))$/,
//'nb-NO': /^(\+?47)?[49]\d{7}$/,
//'nl-BE': /^(\+?32|0)4?\d{8}$/,
//'nn-NO': /^(\+?47)?[49]\d{7}$/,
//'pl-PL': /^(\+?48)? ?[5-8]\d ?\d{3} ?\d{2} ?\d{2}$/,
//'pt-BR': /^(\+?55|0)\-?[1-9]{2}\-?[2-9]{1}\d{3,4}\-?\d{4}$/,
//'pt-PT': /^(\+?351)?9[1236]\d{7}$/,
//'ru-RU': /^(\+?7|8)?9\d{9}$/,
//'sr-RS': /^(\+3816|06)[- \d]{5,9}$/,
//'tr-TR': /^(\+?90|0)?5\d{9}$/,
//'vi-VN': /^(\+?84|0)?((1(2([0-9])|6([2-9])|88|99))|(9((?!5)[0-9])))([0-9]{7})$/,
//'zh-CN': /^(\+?0?86\-?)?1[345789]\d{9}$/,
//'zh-TW': /^(\+?886\-?|0)?9\d{8}$/
//'en-ZM': /^(\+?26)?09[567]\d{7}$/,

// ---------------------------------------------

- (BOOL)isEmail
{
    NSString *		regex = @"\\S+@\\S+\\.\\S+";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress
{
    NSArray *			components = [self componentsSeparatedByString:@"."];
    NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    if ( [components count] == 4 )
    {
        NSString *part1 = [components objectAtIndex:0];
        NSString *part2 = [components objectAtIndex:1];
        NSString *part3 = [components objectAtIndex:2];
        NSString *part4 = [components objectAtIndex:3];
        
        if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
        {
            if ( [part1 intValue] < 255 &&
                [part2 intValue] < 255 &&
                [part3 intValue] < 255 &&
                [part4 intValue] < 255 )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string
{
    return [self substringFromIndex:from untilString:string endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfString:string options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
    return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
    if ( 0 == self.length )
        return 0;
    
    if ( from >= self.length )
        return 0;
    
    NSCharacterSet * reversedCharset = [charset invertedSet];
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        return self.length - from;
    }
    else
    {
        return range2.location - from;		
    }
}

- (NSArray *)pairSeparatedByString:(NSString *)separator
{
    if ( nil == separator )
        return nil;
    
    NSUInteger	offset = 0;
    NSString *	key = [self substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:separator] endOffset:&offset];
    NSString *	val = nil;
    
    if ( nil == key || offset >= self.length )
        return nil;
    
    val = [self substringFromIndex:offset];
    if ( nil == val )
        return nil;
    
    return [NSArray arrayWithObjects:key, val, nil];
}

#pragma mark - 获取文字长度

//获取文字宽度
+ (CGFloat)stringWidthWithText:(NSString *)text fontSize:(NSInteger)fontSize {
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize], NSParagraphStyleAttributeName : style };
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(Screen_Width, cHeaderHeight_44)
                                         options:opts
                                      attributes:attributes
                                         context:nil].size;
    return textSize.width;
}

#pragma mark - 是否有 emoji

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1F9FF) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

#pragma mark - 包含特殊字符

+ (BOOL)stringContainsIllegalCharacter:(NSString *)content{
    // 不能输入特殊字符(只能输入中英文数字)
    NSString *str = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![predicate evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

@end
