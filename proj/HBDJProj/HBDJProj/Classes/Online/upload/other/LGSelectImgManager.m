//
//  LGSelectImgManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSelectImgManager.h"

@interface LGSelectImgManager ()


@end

@implementation LGSelectImgManager

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    [HXPhotoTools selectListWriteToTempPath:photos requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        _tempImageUrls = imageUrls.copy;
    } error:^{
        NSLog(@"selectPhotoError");
    }];
    
}

// 懒加载 照片管理类
- (HXPhotoManager *)hxPhotoManager {
    if (!_hxPhotoManager) {
        _hxPhotoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    return _hxPhotoManager;
}

CM_SINGLETON_IMPLEMENTION
@end
