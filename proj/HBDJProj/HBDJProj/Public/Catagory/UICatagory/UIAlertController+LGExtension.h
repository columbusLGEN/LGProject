//
//  UIAlertController+LGExtension.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LGAlertActionBlock)(UIAlertAction * _Nonnull action);

@interface UIAlertController (LGExtension)

+ (instancetype)lg_popUpWindowWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)cancelTitle doneTitle:(NSString *)doneTitle cancelBlock:(LGAlertActionBlock)cancelBlock doneBlock:(LGAlertActionBlock)doneBlock;

@end
