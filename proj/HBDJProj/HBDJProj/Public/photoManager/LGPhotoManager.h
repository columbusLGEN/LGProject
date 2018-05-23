//
//  LGPhotoManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGPhotoManager : NSObject

+ (void)beforeModalImgPickerWithViewController:(UIViewController *)viewController;
+ (instancetype)sharedInstance;

@end
