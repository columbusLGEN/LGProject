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

@implementation LGLocalFileProducer


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
