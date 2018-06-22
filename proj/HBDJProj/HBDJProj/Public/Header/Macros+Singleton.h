//
//  Macros+Singleton.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#ifndef Macros_Singleton_h
#define Macros_Singleton_h

//#import <objc/runtime.h>

#pragma mark -
#pragma mark - interface
/* Usage:
 *
 * MyClass.h:
 * ========================================
 *	#import "CMSingleton.h"
 *
 *	@interface MyClass: SomeSuperclass
 *	{
 *      ...
 *	}
 *	CM_SYNTHESIZE_SINGLETON_INTERFACE(MyClass);
 *
 *	@end
 * ========================================
 */

#undef	CM_SINGLETON_INTERFACE
#define CM_SINGLETON_INTERFACE \
\
+ (instancetype)sharedInstance; \
\

#pragma mark -
#pragma mark - implementation

/* Usage:
 *
 *	MyClass.m:
 * ========================================
 *	#import "MyClass.h"
 *
 *	@implementation MyClass
 *
 *	CM_SYNTHESIZE_SINGLETON_IMPLEMENTION(MyClass);
 *
 *	...
 *
 *	@end
 * ========================================
 */

#undef	CM_SINGLETON_IMPLEMENTION
#define CM_SINGLETON_IMPLEMENTION \
+ (instancetype)sharedInstance{\
static id instance;\
static dispatch_once_t once;\
dispatch_once(&once, ^{\
instance = [self new];\
});\
return instance;\
}

//\
//static __class * __singleton__; \
//\
//+ (__class *)sharedInstance \
//{ \
//static dispatch_once_t predicate; \
//dispatch_once( &predicate, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
//return __singleton__; \
//} \
//+ (void)load \
//{ \
//[self sharedInstance]; \
//} \


#endif
 /* Macros_Singleton_h */
