//
//  LGUserLimitsManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGUserLimitsManager.h"

#import <AVFoundation/AVFoundation.h>

@implementation LGUserLimitsManager

- (void)microPhoneLimitCheck:(void(^)(void))permitted denied:(void(^)(void))denied{
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
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

- (UIAlertController *)showSetMicroPhoneAlertView{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:setAction];
    
    return alertVC;
}

@end
