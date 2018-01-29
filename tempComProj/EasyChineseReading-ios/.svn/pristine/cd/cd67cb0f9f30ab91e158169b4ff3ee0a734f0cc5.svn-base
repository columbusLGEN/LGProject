//
//  BookRequest.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/31.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseNetRequest.h"

@interface BookRequest : BaseNetRequest

#pragma mark ========== 图书相关网络请求 ==========

CM_SINGLETON_INTERFACE(BookRequest)

/**
 图书接口
 */

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
              Completion:(CompleteBlock)completion;

/**
 获取系列图书(针对每一本书都有一个开始与截止时间)
 
 @param page        页数
 @param length      每页数量
 @param series      系列 id
 @param completion  回调
 */
- (void)getSeriesBooksWithPage:(NSInteger)page
                        length:(NSInteger)length
                        series:(NSInteger)series
                    Completion:(CompleteBlock)completion;


@end
