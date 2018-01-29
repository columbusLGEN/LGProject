//
//  NSData+LEEEx.m
//  TOP6000
//
//  Created by user on 17/3/9.
//  Copyright © 2017年 Len. All rights reserved.
//

#import "NSData+LEEEx.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (LEEEx)

- (NSString *)md5String{
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)self.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

@end
