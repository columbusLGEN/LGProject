//
//  DJUploadDataManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadDataManager.h"
#import "HXPhotoPicker.h"
#import "DJOnlineNetorkManager.h"
#import "DJOnlineUploadTableModel.h"

static NSString * const key_path = @"path";
static NSString * const key_widthheigth = @"widthheigth";

@interface DJUploadDataManager ()
/** 要上传的表单数据 */
@property (strong,nonatomic) NSMutableDictionary *formData;

@end

@implementation DJUploadDataManager

/** 获取视频封面 */
- (UIImage *) thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}

/// 朋友圈 上传 ，目前仅做上传视频用
- (void)ugc_uploadFileWithMimeType:(NSString *)mimeType success:(DJUploadImageComplete)completeBlock singleFileComplete:(DJUploadFileComplete)singleFileComplete{
    if (_tempImageUrls.count == 1) {
        
        // 1.获取视频封面，并上传封面
        
        // 2.上传视频文件，并将封面链接、宽高，视频连接、宽高一并回调
        
//        __block NSInteger coverSuccess = 0;
//        __block NSInteger videoSuccess = 0;
//        __block NSInteger coverFailure = 0;
//        __block NSInteger videoFailure = 0;
//
//        void (^coverAndVideoUploadSuccess)(id dict) = ^(id dict){
//            if (singleFileComplete) singleFileComplete(dict);
//        };
        
        NSURL *localUrl = self.tempImageUrls[0];
        
        /// 将封面写入本地
        UIImage *cover = [self thumbnailImageForVideo:localUrl];
        NSString *tmp = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSString *coverPath = [tmp stringByAppendingPathComponent:@"tmpCover.jpeg"];
        NSData *imageData = UIImageJPEGRepresentation(cover, 0.8);
        BOOL writeSuccess = [imageData writeToFile:coverPath atomically:NO];
        
        NSLog(@"封面本地连接 %d : %@",writeSuccess,coverPath);
        
        if (writeSuccess) {
            /// 上传封面
            [self uploadFileWithLocalFileUrl:[NSURL fileURLWithPath:coverPath] mimeType:@"image/jpeg" uploadProgress:^(NSProgress *uploadProgress) {
                NSLog(@"ugc上传封面进度: %f",(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                
            } success:^(id dict) {
                NSLog(@"上传封面成功: %@",dict);
                /// 上传视频 & 删除封面
                NSDictionary *param = @{@"cover":dict[key_path],
                                        key_widthheigth:dict[key_widthheigth]};
                
                [self uploadVideoWithLocalUrl:localUrl mimeType:mimeType coverLocalPath:coverPath coverResponseObject:[param mutableCopy] singleFileComplete:singleFileComplete];
            } failure:^(id uploadFailure) {
                [self uploadVideoWithLocalUrl:localUrl mimeType:mimeType coverLocalPath:coverPath coverResponseObject:NSMutableDictionary.new singleFileComplete:singleFileComplete];
            }];
        }
        
        
        
    }else{
        [self uploadFileWithSuccess:completeBlock];
    }
}

- (void)uploadVideoWithLocalUrl:(NSURL *)localUrl mimeType:(NSString *)mimeType coverLocalPath:(NSString *)coverLocalPath coverResponseObject:(NSMutableDictionary *)coverResponseObject singleFileComplete:(DJUploadFileComplete)singleFileComplete{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:coverLocalPath error:&error];
    if (error) {
        NSLog(@"封面删除失败: %@",error);
    }
    
    [self uploadFileWithLocalFileUrl:localUrl mimeType:mimeType uploadProgress:^(NSProgress *uploadProgress) {
        NSLog(@"ugc上传视频进度: %f",(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(id dict) {
        NSLog(@"上传视频成功: %@",dict);
        coverResponseObject[key_path] = dict[key_path];
        if (singleFileComplete) singleFileComplete(coverResponseObject);
    } failure:^(id uploadFailure) {
        if (singleFileComplete) singleFileComplete(nil);
    }];
}

/// MARK: 上传内容图片
- (void)uploadContentImageWithSuccess:(DJUploadImageComplete)completeBlock{
    /**
     /// 如何保证正确的图片顺序？
     
     1.一个数组 -- 基于 tempImageUrls 的可变数组
     2.一个字典 -- value是图片上传成功后的链接，key是图片在 tempImageUrls 中的索引
     3.一个block 上传完成block
     4.两个count 失败计数 和 成功计数，上传成功或者失败时各自+1，当失败计数+成功计数与tempImageUrls.count相等时，就执行上传完成block
     
     */
    [self uploadFileWithSuccess:completeBlock];
}

- (void)uploadFileWithSuccess:(DJUploadImageComplete)completeBlock{
    if (_tempImageUrls == nil) {
        /// 表示用户没有选择图片，直接回调
        if (completeBlock) completeBlock(nil,_formData);
    }
    
    __block NSInteger successCount = 0;
    __block NSInteger failureCount = 0;
    
    /** 上传图片完成block */
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:self.tempImageUrls.copy];
    void (^uploadImageCompleteBlock)(NSDictionary *urls) = ^(NSDictionary *urls){
        for (NSInteger i = 0; i < imageUrls.count; i++) {
            imageUrls[i] = urls[[NSString stringWithFormat:@"%ld",(long)i]];
        }
        if (completeBlock) completeBlock(imageUrls.copy,_formData);
    };
    
    NSMutableDictionary *urlDict = NSMutableDictionary.new;
    for (NSInteger i = 0; i < self.tempImageUrls.count; i++) {
        NSURL *localUrl = self.tempImageUrls[i];
        
        [self uploadImageWithLocalFileUrl:localUrl uploadProgress:^(NSProgress *uploadProgress) {
            NSLog(@"%ld: %f",(long)i,(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSString *imgUrl_sub) {
            [urlDict setValue:imgUrl_sub forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            successCount++;
            if ((successCount + failureCount) == self.tempImageUrls.count) {
                uploadImageCompleteBlock(urlDict.copy);
            }
            
        } failure:^(id uploadFailure) {
            [urlDict setValue:[NSString stringWithFormat:@"第%ld张图上传失败",(long)i] forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            failureCount++;
            
            if ((successCount + failureCount) == self.tempImageUrls.count) {
                uploadImageCompleteBlock(urlDict.copy);
            }
            
        }];
    }
}

- (void)presentAlbunListViewControllerWithViewController:(UIViewController *)vc manager:(HXPhotoManager *)manager selectSuccess:(DJSelectCoverSuccess)selectSuccess uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure {
    
    [vc hx_presentAlbumListViewControllerWithManager:manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        [HXPhotoTools selectListWriteToTempPath:photoList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
            /// 选择完成之后需要做  件事
            /// 1.更新UI
            /// 2.保存封面图片的本地临时路径
            if (imageUrls.count) {
                NSURL *coverLocalUrl = imageUrls[0];
                /// MARK: 上传封面
                [self uploadImageWithLocalFileUrl:coverLocalUrl uploadProgress:progress success:success failure:failure];
                
                /// MARK: 将成功/失败的状态和数据 回调给控制器
                if (selectSuccess) selectSuccess(coverLocalUrl);
            }
        } error:^{
            NSLog(@"selectPhotoError");
        }];
        
    } cancel:^(HXAlbumListViewController *viewController) {
        
    }];
}

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    [[DJOnlineNetorkManager sharedInstance] uploadImageWithLocalFileUrl:localFileUrl uploadProgress:progress success:success failure:failure];
}
- (void)uploadFileWithLocalFileUrl:(NSURL *)localFileUrl mimeType:(NSString *)mimeType uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadFileSuccess)success failure:(LGUploadImageFailure)failure{
    [DJOnlineNetorkManager.sharedInstance uploadFileWithLocalFileUrl:localFileUrl mimeType:mimeType uploadProgress:progress success:success failure:failure];
}


/// MARK: HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    
    NSArray *array;
    if (photos.count == 0) {
        array = videos;
    }else{
        array = photos;
    }
    
    [HXPhotoTools selectListWriteToTempPath:array requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        _tempImageUrls = allUrl.copy;
        NSLog(@"_tempImageUrls: %@",_tempImageUrls);
    } error:^{
        NSLog(@"selectPhotoError");
    }];
    
}

- (NSString *)msgByFormdataVerifyWithTableModels:(NSArray *)array{
    NSString *msg;
    for (NSInteger i = 0; i < array.count; i++) {
        DJOnlineUploadTableModel *model = array[i];
        if (model.necess) {
            if ([model.content isEqualToString:@""] || model.content == nil) {
                msg = model.itemName;
                break;
            }
        }
    }
    return msg;
}

- (void)setUploadValue:(id)value key:(NSString *)key{
    NSAssert(value != nil, @"value 不能为空");
    [_formData setValue:value forKey:key];
    NSLog(@"表单数据_formData: %@",_formData);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _formData = NSMutableDictionary.new;
    }
    return self;
}

@end
