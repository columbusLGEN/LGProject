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

@interface LGLocalFileProducer ()
@property (weak,nonatomic) MBProgressHUD *progressBar;

@end

@implementation LGLocalFileProducer

+ (void)cancelDownloadAll{
    [LGDownloadManager lg_cancelDownloadTask];
}

+ (void)openBookWithModel:(EDJDigitalModel *)model vc:(UIViewController *)vc{
    [[self sharedInstance] openBookWithModel:model vc:vc];
}
- (void)openBookWithModel:(EDJDigitalModel *)model vc:(UIViewController *)vc{
    
    /// 正式代码
    BOOL resourceExist = [LGLocalFileManager fileIsExist:model.localUrl];
    NSString *bookId = [NSString stringWithFormat:@"%ld",model.seqid];
    if (resourceExist) {
        /// 直接打开
        [LGBookReaderManager openBookWithLocalUrl:model.localUrl bookId:bookId vc:vc];
    }else{
        MBProgressHUD *progressBar = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        [vc.view addSubview:progressBar];
        _progressBar = progressBar;
        progressBar.mode = MBProgressHUDModeAnnularDeterminate;
        progressBar.progress = 0.0;
        /// 先下载，再打开
        [self downloadResourceWithUrl:model.ebookresource localUrl:model.localUrl progressBlk:^(CGFloat progress,CGFloat total, CGFloat current) {
            _progressBar.progress = progress;
        } success:^(NSString *destiPath) {
            [_progressBar hideAnimated:YES];
            NSLog(@"destipath: %@",destiPath);
            model.localUrl = destiPath;
            [LGBookReaderManager openBookWithLocalUrl:destiPath bookId:bookId vc:vc];
        } failure:^(NSError *error) {
            [_progressBar hideAnimated:YES];
            NSLog(@"downloadfailure: %@",error);
        }];
    }
    
}

+ (void)downloadResourceWithUrl:(NSString *)url localUrl:(NSString *)localUrl progressBlk:(LGProducerProgress)progressBlk success:(LGProducerSuccess)success failure:(LGProducerFailure)failure{
    [[self sharedInstance] downloadResourceWithUrl:url localUrl:localUrl progressBlk:progressBlk success:success failure:failure];
}
- (void)downloadResourceWithUrl:(NSString *)url localUrl:(NSString *)localUrl progressBlk:(LGProducerProgress)progressBlk success:(LGProducerSuccess)success failure:(LGProducerFailure)failure{
    
    [LGDownloadManager downloadWithURLString:url fileName:localUrl progress:progressBlk success:^(NSString *localURL) {
        if (success) success(localURL);
    } failure:^(NSError *error) {
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
