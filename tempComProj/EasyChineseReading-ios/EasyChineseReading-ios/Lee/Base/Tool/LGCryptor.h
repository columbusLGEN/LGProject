//
//  LGCryptor.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/23.
//  Copyright © 2018年 retech. All rights reserved.
//

typedef void(^LGCryptorSuccess)(NSString *path);
typedef void(^LGCryptorFailure)(NSError *error);

#import <Foundation/Foundation.h>

@interface LGCryptor : NSObject
/**
 对文件进行加密
 
 @param oriPath 原文件路径
 @param toPath 加密后文件路径
 */
+ (void)encryptWithOriPath:(NSString *)oriPath toPath:(NSString *)toPath success:(LGCryptorSuccess)success failure:(LGCryptorFailure)failure;
/**
 对文件进行 解密
 
 @param encodePath 加密文件路径
 @param decodePath 解密后文件路径
 */
+ (void)decryptWithEncodePath:(NSString *)encodePath decodePath:(NSString *)decodePath success:(LGCryptorSuccess)success failure:(LGCryptorFailure)failure;

@end
