//
//  ZAES.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/26.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZAES.h"

#import "NSData+AES.h"

#define IV  @"0000000000000000"
#define KEY @"123123qweasdzxcv"

@implementation ZAES

/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptStrig:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [data AES128EncryptWithKey:KEY iv:IV];
    return [aesData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128DecryptString:(NSString *)string{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *aesData = [data AES128DecryptWithKey:KEY iv:IV];
    return [[NSString alloc] initWithData:aesData encoding:NSUTF8StringEncoding];
}

//16进制转换为NSData
+ (NSData *)convertHexStrToData:(NSString*)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:[str length]*2];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    //    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

//NSData转换为16进制
+ (NSString *)convertDataToHexStr:(NSData*)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]/2];
    
    [data enumerateByteRangesUsingBlock:^(const void*bytes,NSRange byteRange,BOOL*stop) {
        unsigned char *dataBytes = (unsigned  char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
