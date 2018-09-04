//
//  LGNoticer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGNoticer : NSObject

- (void)noticeNetworkStatusWithBlock:(void(^)(BOOL notice))noticeBlock;

@end
