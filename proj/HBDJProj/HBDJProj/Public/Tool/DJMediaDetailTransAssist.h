//
//  DJMediaDetailTransAssist.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 本类负责 跳转 图文、音视频详情 

#import <Foundation/Foundation.h>

@class DJDataBaseModel,EDJHomeImageLoopModel;

@interface DJMediaDetailTransAssist : NSObject

- (void)imgLoopClick:(NSInteger)index model:(EDJHomeImageLoopModel *)model baseVc:(UIViewController *)baseVc;

- (void)homeListClick:(NSDictionary *)userInfo baseVc:(UIViewController *)baseVc;

- (void)mediaDetailWithModel:(DJDataBaseModel *)model baseVc:(UIViewController *)baseVc;

- (void)skipWithType:(NSInteger)skipType model:(id)model baseVc:(UIViewController *)baseVc;

@end
