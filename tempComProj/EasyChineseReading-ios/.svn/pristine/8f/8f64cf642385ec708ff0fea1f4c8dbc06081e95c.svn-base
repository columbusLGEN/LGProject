//
//  BookRequest.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/31.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BookRequest.h"

@implementation BookRequest

CM_SINGLETON_IMPLEMENTION(BookRequest)


#pragma mark - 获取系列图书

/**
 获取系列图书
 
 @param page        页数
 @param length      每页数量
 @param series      系列 id
 @param completion  回调
 */
- (void)getBooksWithPage:(NSInteger)page
                  length:(NSInteger)length
                  series:(NSInteger)series
              Completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"special" : @"",
                                       @"series"  : [NSString stringWithFormat:@"%ld", series],
                                       @"classify": @"",
                                       @"length"  : [NSString stringWithFormat:@"%ld", length],
                                       @"page"    : [NSString stringWithFormat:@"%ld", page],
                                       @"sort"    : @"0",
                                       @"name"    : @""
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"books/books"
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

/**
 获取系列图书
 
 @param page        页数
 @param length      每页数量
 @param series      系列 id
 @param completion  回调
 */
- (void)getSeriesBooksWithPage:(NSInteger)page
                        length:(NSInteger)length
                        series:(NSInteger)series
                    Completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"special" : @"",
                                       @"series"  : [NSString stringWithFormat:@"%ld", series],
                                       @"classify": @"",
                                       @"length"  : [NSString stringWithFormat:@"%ld", length],
                                       @"page"    : [NSString stringWithFormat:@"%ld", page],
                                       @"sort"    : @"0",
                                       @"name"    : @""
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"books/rentingSeries"
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
