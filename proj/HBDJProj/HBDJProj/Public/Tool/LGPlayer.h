//
//  LGPlayer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGPlayer : NSObject

+ (BOOL)videoPlay;
+ (UIView *)playVideoWithUrl:(NSString *)urlString;

+ (instancetype)sharedInstance;
@end
