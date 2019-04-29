//
//  Model.h
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 Libc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

@property (assign,nonatomic) NSInteger id;
/** 0: 纯代码；1：xib */
@property (assign,nonatomic) NSInteger loadType;
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *vcClassName;
+ (NSArray *)loadLocalPlistWithPlistName:(NSString *)plistName;

@end

NS_ASSUME_NONNULL_END
