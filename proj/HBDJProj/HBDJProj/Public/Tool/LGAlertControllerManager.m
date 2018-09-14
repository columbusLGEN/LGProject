//
//  LGAlertControllerManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGAlertControllerManager.h"

@implementation LGAlertControllerManager

+ (UIAlertController *)alertvcWithTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText doneText:(NSString *)doneText cancelABlock:(LGShowAlertVcActionBlock)cancelBlock doneBlock:(LGShowAlertVcActionBlock)doneBlock{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelBlock];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:doneBlock];
    [alertVC addAction:cancelAction];
    [alertVC addAction:doneAction];
    
    return alertVC;
}

+ (UIAlertController *)alertvcWithTitle:(NSString *)title message:(NSString *)message doneText:(NSString *)doneText doneBlock:(LGShowAlertVcActionBlock)doneBlock{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneText style:UIAlertActionStyleDefault handler:doneBlock];
    [alertVC addAction:doneAction];
    
    return alertVC;
}

@end
