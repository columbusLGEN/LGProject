//
//  LGLoadingAssit.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGLoadingAssit : NSObject
- (void)homeAddLoadingViewTo:(UIView *)view;
- (void)homeRemoveLoadingView;
+ (instancetype)sharedInstance;

@end
