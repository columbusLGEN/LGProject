//
//  LGWMPlayerManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMPlayer;

@interface LGWMPlayerManager : NSObject

- (WMPlayer *)WMPlayerWithUrl:(NSString *)url aImgType:(NSUInteger)aImgType delegate:(id)delegate;

@end
