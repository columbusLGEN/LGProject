//
//  UIViewController+Camera.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIViewController+Camera.h"

@implementation UIViewController(Camera)

/**
 * 引出选择 相册、拍照 的选择框
 */
- (void)showAlertForSystemPhotoWithTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:LOCALIZATION(@"拍照") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    UIAlertAction *photos = [UIAlertAction actionWithTitle:LOCALIZATION(@"从相册选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibrary];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LOCALIZATION(@"取消") style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    if (isPad) {
        // ipad 上不加这两句会 crash ,iphone 不会
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(Screen_Width - 60, 70, 1.0, 1.0);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 系统相册
 */
- (void)openPhotoLibrary
{
    UIImagePickerController * pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    //    [pickerImage.navigationBar setTintColor:[UIColor blackTitleColor]];
    //    pickerImage.navigationBar.barStyle = UIBarStyleDefault;
    pickerImage.navigationBar.translucent = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
/**
 *  拍照
 */
- (void)openCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [picker.navigationBar setTintColor:[UIColor cm_blackColor_333333_1]];
        picker.navigationBar.barStyle = UIBarStyleDefault;
        picker.navigationBar.translucent = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [self presentFailureTips:LOCALIZATION(@"你的手机不支持拍照")];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * orgImage;
//    if ([self.isNeedNotEdit boolValue]) {
        orgImage = info[UIImagePickerControllerOriginalImage];
//    }else{
//        orgImage = info[UIImagePickerControllerEditedImage];
//    }
    // 修复方向
    [self handleImgWith:[orgImage fixOrientation]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 取到数据之后,待处理
 */
- (void)handleImgWith:(UIImage *)image
{
    
}

@end
