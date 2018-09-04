//
//  UIAlertController+LGExtension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIAlertController+LGExtension.h"

@implementation UIAlertController (LGExtension)

+ (instancetype)lg_popUpWindowWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)cancelTitle doneTitle:(NSString *)doneTitle cancelBlock:(LGAlertActionBlock)cancelBlock doneBlock:(LGAlertActionBlock)doneBlock {
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
    UIAlertAction *done = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:doneBlock];
    
    [avc addAction:cancel];
    [avc addAction:done];
    
    return avc;
}

@end
