//
//  UCUploadCollectionCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadCollectionCell.h"
#import "UCUploadModel.h"

#import "HXPhotoPicker.h"

@interface UCUploadCollectionCell ()<
HXPhotoViewDelegate>
/**  照片管理  */
@property (nonatomic, strong) HXPhotoManager *manager;
/**  照片视图  */
@property (nonatomic, strong) HXPhotoView *photoView;

@end

@implementation UCUploadCollectionCell

- (void)setModel:(UCUploadModel *)model{
    _model = model;


}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    self.model.endCameraList = self.manager.afterCameraArray.mutableCopy;
    self.model.endCameraPhotos = self.manager.afterCameraPhotoArray.mutableCopy;

    self.model.endSelectedCameraList = self.manager.afterSelectedCameraArray.mutableCopy;
    self.model.endSelectedCameraPhotos = self.manager.afterSelectedCameraPhotoArray.mutableCopy;
    
    self.model.endSelectedList = self.manager.afterSelectedArray.mutableCopy;
    self.model.endSelectedPhotos = self.manager.afterSelectedPhotoArray.mutableCopy;
    
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    if (frame.size.height == self.model.photoViewHeight) {
        return;
    }
    self.model.photoViewHeight = frame.size.height;
    if (self.photoViewChangeHeightBlock) self.photoViewChangeHeightBlock(self);
}

- (void)setupUI{

    [self.contentView addSubview:self.photoView];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    }
    return _manager;
}
- (HXPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(12, 0, [UIScreen mainScreen].bounds.size.width - 24, 0) WithManager:self.manager];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.delegate = self;
    }
    return _photoView;
}

@end
