//
//  LGCryptor.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/23.
//  Copyright © 2018年 retech. All rights reserved.
//

#import "LGCryptor.h"
#import "RNCryptor iOS.h"

@interface LGCryptor ()
/** 加解密 密码 */
@property (strong,nonatomic) NSString *pwd;

@end

@implementation LGCryptor


/**
 对文件进行加密

 @param oriPath 原文件路径
 @param toPath 加密后文件路径
 */
+ (void)encryptWithOriPath:(NSString *)oriPath toPath:(NSString *)toPath success:(LGCryptorSuccess)success failure:(LGCryptorFailure)failure{
    [[self sharedInstance] encryptWithOriPath:oriPath toPath:toPath success:success failure:failure];
}
- (void)encryptWithOriPath:(NSString *)oriPath toPath:(NSString *)toPath success:(LGCryptorSuccess)success failure:(LGCryptorFailure)failure{
    NSData *data = [NSData dataWithContentsOfFile:oriPath];
    __block NSError *error;
    // 子线程处理加密以及写入过程
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *encryptedData = [RNEncryptor encryptData:data
                                            withSettings:kRNCryptorAES256Settings
                                                password:self.pwd
                                                   error:&error];
        BOOL write = [encryptedData writeToFile:toPath atomically:YES];
        // 加密成功之后删除原文件,并执行回调
        if (write) {
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:oriPath error:nil];
            NSLog(@"删除未加密的epub文件 -- %d",remove);
            // 执行成功回调
            if(success) success(toPath);
        }else{
            if(failure) failure(error);
        }
    });
}
/**
 对文件进行 解密
 
 @param encodePath 加密文件路径
 @param decodePath 解密后文件路径
 */
+ (void)decryptWithEncodePath:(NSString *)encodePath decodePath:(NSString *)decodePath success:(LGCryptorSuccess)success failure:(LGCryptorFailure)failure{
    [[self sharedInstance] decryptWithEncodePath:encodePath decodePath:decodePath success:success failure:failure];
}
- (void)decryptWithEncodePath:(NSString *)encodePath decodePath:(NSString *)decodePath success:(LGCryptorSuccess)success failure:(LGCryptorFailure)failure{
    
    NSData *data_encode = [NSData dataWithContentsOfFile:encodePath];
    __block NSError *error;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data_decode = [RNDecryptor decryptData:data_encode withPassword:self.pwd error:&error];
        BOOL write_decode = [data_decode writeToFile:decodePath atomically:YES];
        if (write_decode) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (success) success(decodePath);
            }];
            
        }else{
            if (failure) failure(error);
        }
    });
    
}

- (NSString *)pwd{
    if (_pwd == nil) {
        _pwd = @"ecrLG_2017";
    }
    return _pwd;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
