//
//  BaseNetRequest.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import "BaseNetRequest.h"
#import "ZNetworkRequest.h"

@interface BaseNetRequest ()

@end

@implementation BaseNetRequest

CM_SINGLETON_IMPLEMENTION(BaseNetRequest)

- (id)init
{
    self = [super init];
    if (self)
    {
        self.arrDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (NSString *)encodeToPercentEscapeString:(NSString *)string
{
    CFStringRef customString = CFURLCreateStringByAddingPercentEscapes(  NULL/* allocator */
                                                                 , (__bridge CFStringRef)string
                                                                 , NULL/* charactersToLeaveUnescaped */
                                                                 , (CFStringRef)@"!*'();:@&=+$,/?%#[]"
                                                                 , kCFStringEncodingUTF8);
    NSString *outputStr = (__bridge NSString *)customString;
    CFRelease(customString);
    return outputStr;
}

@end
