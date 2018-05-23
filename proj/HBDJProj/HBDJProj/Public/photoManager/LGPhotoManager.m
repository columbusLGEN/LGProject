//
//  LGPhotoManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGPhotoManager.h"
#import <PhotosUI/PhotosUI.h>

@interface LGPhotoManager ()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@end

@implementation LGPhotoManager



#pragma mark - UIImagePickerControllerDelegate,
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)modalImgPickerWithViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
//    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
//    picker.cameraOverlayView;
    
    [viewController presentViewController:picker animated:YES completion:nil];
}

+ (void)beforeModalImgPickerWithViewController:(UIViewController *)viewController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //    alert.popoverPresentationController.sourceView = viewController.view;
    //    alert.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight - 100, kScreenWidth, 1.0);
    //    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[self sharedInstance] modalImgPickerWithViewController:viewController sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[self sharedInstance] modalImgPickerWithViewController:viewController sourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:photo];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
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
