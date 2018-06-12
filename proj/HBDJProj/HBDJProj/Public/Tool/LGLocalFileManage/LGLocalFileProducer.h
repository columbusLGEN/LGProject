//
//  LGLocalFileProducer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LGProducerProgress)(CGFloat progress);
typedef void(^LGProducerSuccess)(NSString *destiPath);
typedef void(^LGProducerFailure)(NSError *error);

@class EDJDigitalModel;

@interface LGLocalFileProducer : NSObject

#pragma 阅读
+ (void)openBookWithModel:(EDJDigitalModel *)model;

#pragma 下载
+ (void)downloadResourceWithUrl:(NSString *)url seqid:(NSInteger)seqid progressBlk:(LGProducerProgress)progressBlk success:(LGProducerSuccess)success failure:(LGProducerFailure)failure;

#pragma 路径管理

+ (instancetype)sharedInstance;
@end
