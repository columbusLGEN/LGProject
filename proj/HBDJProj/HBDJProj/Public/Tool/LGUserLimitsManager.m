//
//  LGUserLimitsManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGUserLimitsManager.h"

#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@implementation LGUserLimitsManager

- (void)microPhoneLimitCheck:(void(^)(void))permitted denied:(void(^)(void))denied{
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
    }];
    switch (permission) {
        case AVAudioSessionRecordPermissionDenied:
        case AVAudioSessionRecordPermissionUndetermined:
            if (denied) denied();
            break;
        case AVAudioSessionRecordPermissionGranted:
            if (permitted) permitted();
            break;

    }
}

+ (void)userUNAuthorizationWith:(void(^)(BOOL granted))userGrantedCallBack{
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                /// 用户允许通知
//
//            }
            if (userGrantedCallBack) userGrantedCallBack(granted);
        }];
    } else {
        // Fallback on earlier versions
//        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
//        }
    }
   

}

- (UIAlertController *)showSetPushNotificationAlertViewWithViewController:(UIViewController *)vc cancelABlock:(LGShowAlertVcActionBlock)cancelBlock doneBlock:(LGShowAlertVcActionBlock)doneBlock {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    return [self requestUserToSystemSettinsWithTitle:@"推送权限" message:@"请进入系统【设置】>【通知】>【党员之家】中打开开关,开启系统推送通知" cancelText:@"取消" doneText:@"去设置" url:url vc:vc cancelABlock:cancelBlock doneBlock:doneBlock];
    
}

- (UIAlertController *)showSetMicroPhoneAlertView{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:setAction];
    
    return alertVC;
}

- (UIAlertController *)requestUserToSystemSettinsWithTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText doneText:(NSString *)doneText url:(NSURL *)url vc:(UIViewController *)vc cancelABlock:(LGShowAlertVcActionBlock)cancelBlock doneBlock:(LGShowAlertVcActionBlock)doneBlock{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelBlock];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [vc.navigationController popViewControllerAnimated:NO];
        //跳入当前App设置界面
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:setAction];
    
    return alertVC;
}

@end
