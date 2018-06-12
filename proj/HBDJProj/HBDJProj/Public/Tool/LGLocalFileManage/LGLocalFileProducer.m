//
//  LGLocalFileProducer.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGLocalFileProducer.h"
#import "LGBookReaderManager.h"// 阅读
#import "LGDownloadManager.h"// 下载
#import "LGLocalFileManager.h"// 路径管理

#import "EDJDigitalModel.h"

@implementation LGLocalFileProducer

+ (void)openBookWithModel:(EDJDigitalModel *)model{
    [[self sharedInstance] openBookWithModel:model];
}
- (void)openBookWithModel:(EDJDigitalModel *)model{
    
    BOOL resourceExist = [LGLocalFileManager fileIsExist:model.localUrl];
    if (resourceExist) {
        /// 直接打开
        [LGBookReaderManager openBookWithLocalUrl:model.localUrl];
        NSLog(@"epubisalreadyexists_localurl: %@",model.localUrl);
    }else{
        NSLog(@"downloadurl_ebookresource: %@",model.ebookresource);
        /// 先下载，再打开
        [self downloadResourceWithUrl:model.ebookresource seqid:model.seqid progressBlk:^(CGFloat progress) {
            NSLog(@"progress: %f",progress);
        } success:^(NSString *destiPath) {
            NSLog(@"destipath: %@",destiPath);
            model.localUrl = destiPath;
            [LGBookReaderManager openBookWithLocalUrl:destiPath];
        } failure:^(NSError *error) {
//            NSLog(@"downloadfailure: %@",error);
        }];
    }
    
}

+ (void)downloadResourceWithUrl:(NSString *)url seqid:(NSInteger)seqid progressBlk:(LGProducerProgress)progressBlk success:(LGProducerSuccess)success failure:(LGProducerFailure)failure{
    [[self sharedInstance] downloadResourceWithUrl:url seqid:seqid progressBlk:progressBlk success:success failure:failure];
}
- (void)downloadResourceWithUrl:(NSString *)url seqid:(NSInteger)seqid progressBlk:(LGProducerProgress)progressBlk success:(LGProducerSuccess)success failure:(LGProducerFailure)failure{
    
    NSString *fileName = [[LGLocalFileManager sharedLocalFileManager].filePath stringByAppendingString:[NSString stringWithFormat:@"/DJDigital_%@.epub",[NSString stringWithFormat:@"%ld",seqid]]];
    
    [LGDownloadManager downloadWithURLString:url fileName:fileName progress:^(CGFloat progress, CGFloat total, CGFloat current) {
//        NSLog(@"progress: %f",progress / 100);
        if (progressBlk) progressBlk(progress);
    } success:^(NSString *localURL) {
//        NSLog(@"success_localurl: %@",localURL);
        if (success) success(localURL);
    } failure:^(NSError *error) {
//        NSLog(@"failure_error: %@",error);
        if (failure) failure(error);
    }];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 初始化本地路径
        [LGLocalFileManager initLocalFilePath];
    }
    return self;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
@end
