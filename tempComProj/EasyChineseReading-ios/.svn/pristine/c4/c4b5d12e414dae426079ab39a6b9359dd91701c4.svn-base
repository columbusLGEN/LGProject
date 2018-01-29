//
//  ECRmultiObject.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRMultiObject : NSObject
+ (BOOL)isiPhoneX;
/** 首页推荐&系列书籍间距 */
+ (CGFloat)homeBookCoverSpace;
/** 首页图书封面 宽/高 */
+ (CGFloat)homebcwhRate;

- (NSArray *)doubleArrayWithOriginArray:(NSArray *)array rowKey:(NSString *)rowKey;// 字典

/**
 将原始数组中的元素 两两 分组,以ECRRowObject实例为新元素

 @param array 原始数组
 @return 新数组
 */
- (NSArray *)singleLineDoubleModelWithOriginArr:(NSArray *)array;// 模型

/** 获取用户余额 */
+ (CGFloat)userYue;
/** 获取用户积分 */
+ (NSInteger)userScore;


/**
 判断当前设置类型

 @return 1:iPad. 0:iPhone
 */
+ (BOOL)userInterfaceIdiomIsPad;
+ (UIUserInterfaceIdiom)userInterfaceIdiom;
- (UIUserInterfaceIdiom)userInterfaceIdiom;
+ (instancetype)sharedInstance;

@end
