//
//  LGLocalFileProducer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LGProducerProgress)(CGFloat progress,CGFloat total,CGFloat current);
typedef void(^LGProducerSuccess)(NSString *destiPath);
typedef void(^LGProducerFailure)(NSError *error);

@class EDJDigitalModel;

@interface LGLocalFileProducer : NSObject

#pragma 阅读
+ (void)openBookWithModel:(EDJDigitalModel *)model vc:(UIViewController *)vc;

#pragma 下载
+ (void)downloadResourceWithUrl:(NSString *)url localUrl:(NSString *)localUrl progressBlk:(LGProducerProgress)progressBlk success:(LGProducerSuccess)success failure:(LGProducerFailure)failure;
/** 取消下载 */
+ (void)cancelDownloadAll;

#pragma 路径管理

+ (instancetype)sharedInstance;
@end
