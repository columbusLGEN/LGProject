//
//  ZAppStore.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAppStore : NSObject

/**
 苹果内购

 @param productsId     商品id
 @param viewController 控制器
 */
+ (void)buyProductsWithId:(NSString *)productsId viewController:(UIViewController *)viewController;

@end
