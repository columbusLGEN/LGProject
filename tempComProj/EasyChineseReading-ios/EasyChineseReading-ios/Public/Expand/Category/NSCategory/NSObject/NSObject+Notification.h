//
//  NSObject+Notification.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^BlankBlock)(void);

@interface NSObject(Notification)

/**
 发送通知
 
 @param notification 通知
 */
- (void)fk_postNotification:(NSString *)notification;

/**
 发送通知
 
 @param notification 通知
 @param object (id)object
 */
- (void)fk_postNotification:(NSString *)notification object:(id)object;

/**
 发送通知
 
 @param notification 通知
 @param object (id)object
 @param userInfo (NSDictionary)userInfo
 */
- (void)fk_postNotification:(NSString *)notification object:(id)object userInfo:(NSDictionary *)userInfo;

/**
 接收通知

 @param name 通知名
 @param block 回调
 */
- (id <NSObject>)fk_observeNotifcation:(NSString *)name usingBlock:(void (^)(NSNotification *note))block;

/**
 移除通知

 @param observer 通知
 */
- (void)fk_removeObserver:(id <NSObject>)observer;

@end
