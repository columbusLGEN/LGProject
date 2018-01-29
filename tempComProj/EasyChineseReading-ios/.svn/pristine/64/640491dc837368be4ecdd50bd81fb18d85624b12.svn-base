//
//  NSObject+Notification.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NSObject+Notification.h"

@implementation NSObject(Notification)

- (void)fk_postNotification:(NSString *)notification
{
    [self fk_postNotification:notification object:nil];
}

- (void)fk_postNotification:(NSString *)notification object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object];
}
- (void)fk_postNotification:(NSString *)notification object:(id)object userInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
}
- (id <NSObject>)fk_observeNotifcation:(NSString *)name usingBlock:(void (^)(NSNotification *note))block
{
    return [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
}

- (void)fk_removeObserver:(id<NSObject>)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
