//
//  UIViewController+ECRExtension.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UIViewController+ECRExtension.h"

@implementation UIViewController (ECRExtension)

- (void)userOnLine:(void(^)())onLine offLine:(void(^)())offLine;{
    if (UserRequest.sharedInstance.online) {
        if (onLine) onLine();
    }else{
        if (offLine) {
            offLine();
        }else{
            [self pushToViewControllerWithClassName:@"LoginVC"];
        }
    }
}

@end
