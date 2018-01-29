//
//  FavouriteRequest.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "FavouriteRequest.h"

@implementation FavouriteRequest

CM_SINGLETON_IMPLEMENTION(FavouriteRequest)

#pragma mark - 获取收藏列表

/**
 获取收藏列表
 
 @param sort        排序
 @param completion  回调
 */
- (void)getFavourtesWithSort:(ENUM_FavouriteSortType)sort
                  completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", (long)[UserRequest sharedInstance].user.userId],
                                       @"sort"  : [NSString stringWithFormat:@"%ld", sort],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"collection/collection"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     responseObject = [BookModel mj_objectArrayWithKeyValuesArray:responseObject];
                                     NSLog(@"收藏列表 responseObject = %@", responseObject);
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 收藏管理

/**
 收藏管理
 
 @param bookId      图书id
 @param updateType  更新的类型
 @param completion  回调
 */
- (void)updateFavouriteWithBookId:(NSString *)bookId
                             type:(ENUM_FavouriteActionType)updateType
                       completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"bookId": bookId,
                                       @"type"  : [NSString stringWithFormat:@"%ld", updateType]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"collection/collectionManagement"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}
@end
