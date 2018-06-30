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

/// 跳转至详情页面，外部主要调用该方法
- (void)mediaDetailWithModel:(DJDataBaseModel *)model baseVc:(UIViewController *)baseVc;

/// 原本该方法是内部方法，但是便于某些场景需要调用才暴露
- (void)skipWithType:(NSInteger)skipType model:(id)model baseVc:(UIViewController *)baseVc;

@end
