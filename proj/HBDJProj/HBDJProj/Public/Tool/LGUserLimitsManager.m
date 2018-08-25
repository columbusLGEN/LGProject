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

- (UIAlertController *)showSetPushNotificationAlertViewWithViewController:(UIViewController *)vc{
    NSString *string;
    if (@available(iOS 10.0, *)) {
        string = @"App-Prefs:root=NOTIFICATIONS_ID";
    }else{
        string = @"prefs:root=NOTIFICATIONS_ID";
    }
    NSURL *url = [NSURL URLWithString:string];
    return [self requestUserToSystemSettinsWithTitle:@"推送权限" message:@"请进入系统【设置】>【通知】>【党员之家】中打开开关,开启系统推送通知" cancelText:@"取消" doneText:@"去设置" url:url vc:vc];
    
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

- (UIAlertController *)requestUserToSystemSettinsWithTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText doneText:(NSString *)doneText url:(NSURL *)url vc:(UIViewController *)vc{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
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

//- (void)systemUrls{
//    NSArray *dataArray = @[@{@"系统设置":@"prefs:root=INTERNET_TETHERING"},
//
//                           @{@"WIFI设置":@"prefs:root=WIFI"},
//
//                           @{@"蓝牙设置":@"prefs:root=Bluetooth"},
//
//                           @{@"系统通知":@"prefs:root=NOTIFICATIONS_ID"},
//
//                           @{@"通用设置":@"prefs:root=General"},
//
//                           @{@"显示设置":@"prefs:root=DISPLAY&BRIGHTNESS"},
//
//                           @{@"壁纸设置":@"prefs:root=Wallpaper"},
//
//                           @{@"声音设置":@"prefs:root=Sounds"},
//
//                           @{@"隐私设置":@"prefs:root=privacy"},
//
//                           @{@"APP Store":@"prefs:root=STORE"},
//
//                           @{@"Notes":@"prefs:root=NOTES"},
//
//                           @{@"Safari":@"prefs:root=Safari"},
//
//                           @{@"Music":@"prefs:root=MUSIC"},
//
//                           @{@"photo":@"prefs:root=Photos"}
//
//                           ];
//}

/**
 关于审核
 因为这些私有 API，上架有时候会过不了审核。
 我们可以通过利用ASCII值进行拼装组合方法。
 
 如下示例：
 
 NSString *defaultWork = [self getDefaultWork];
 NSString *bluetoothMethod = [self getBluetoothMethod];
 NSURL *url = [NSURLURLWithString:@"Prefs:root=Bluetooth"];
 Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
 [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]  performSelector:NSSelectorFromString(bluetoothMethod) withObject:url withObject:nil];
 1
 2
 3
 4
 5
 -(NSString *) getDefaultWork{
 NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
 NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
 return method; //default Workspace
 }
 
 -(NSString *) getBluetoothMethod{
 NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
 NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
 NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
 NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
 NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
 return method; //openSensitiveURL:withOptions:
 }
 
 */

@end
