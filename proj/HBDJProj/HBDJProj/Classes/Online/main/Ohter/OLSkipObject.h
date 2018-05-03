//
//  OLSkipObject.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 在线模块跳转管理者

#import <Foundation/Foundation.h>
@class OLHomeModel;

@interface OLSkipObject : NSObject

+ (UIViewController *)viewControllerWithOLHomeModelType:(OLHomeModel *)model;

@end
