//
//  ECRPDFRelateder.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface ECRPDFRelateder : NSObject


/**
 获取pdf文件封面

 @param path pdf文件绝对路径
 @return 封面UIImage实例
 */
+ (UIImage *)getPDFCoverWithPath:(NSString *)path;
+ (instancetype)sharedInstance;
@end
