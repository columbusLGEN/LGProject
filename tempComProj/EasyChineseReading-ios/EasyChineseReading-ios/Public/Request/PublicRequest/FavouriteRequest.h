//
//  FavouriteRequest.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseNetRequest.h"

@interface FavouriteRequest : BaseNetRequest

#pragma mark ========== 收藏相关网络请求 ==========

CM_SINGLETON_INTERFACE(FavouriteRequest)

#pragma mark - 获取收藏列表

/**
 获取收藏列表

 @param sort        排序
 @param completion  回调
 */
- (void)getFavourtesWithSort:(ENUM_FavouriteSortType)sort
                  completion:(CompleteBlock)completion;

#pragma mark - 收藏管理

/**
 收藏管理

 @param bookId      图书id
 @param updateType  更新的类型
 @param completion  回调
 */
- (void)updateFavouriteWithBookId:(NSString *)bookId
                             type:(ENUM_FavouriteActionType)updateType
                       completion:(CompleteBlock)completion;



@end
