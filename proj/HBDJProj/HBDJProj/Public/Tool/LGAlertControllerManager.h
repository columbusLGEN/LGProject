//
//  LGAlertControllerManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGAlertControllerManager : NSObject

+ (UIAlertController *)alertvcWithTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText doneText:(NSString *)doneText cancelABlock:(LGShowAlertVcActionBlock)cancelBlock doneBlock:(LGShowAlertVcActionBlock)doneBlock;

+ (UIAlertController *)alertvcWithTitle:(NSString *)title message:(NSString *)message doneText:(NSString *)doneText doneBlock:(LGShowAlertVcActionBlock)doneBlock;

@end
