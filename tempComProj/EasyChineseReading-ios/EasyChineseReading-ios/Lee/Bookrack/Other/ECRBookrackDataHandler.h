//
//  ECRBookrackDataHandler.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/25.
//  Copyright © 2017年 retech. All rights reserved.
//

//1 -- 将书籍添加进书架,将书籍加入到书架默认界面
//2 -- 将两本书合并为一个分组 & 向分组中添加一本书
//3 -- 书籍移除分组
//4 -- 删除分组
//5 -- 书籍移出书架 即从书架中 删除书籍
/**
 管理书架类型

 - ECRBookShelfManagTypeAddToBookrack: 将书籍添加进书架,将书籍加入到书架默认界面
 - ECRBookShelfManagTypeAddToGroup: 将两本书合并为一个分组 & 向分组中添加一本书
 - ECRBookShelfManagTypeGroupRemoveBook: 书籍移除分组
 - ECRBookShelfManagTypeRemoveGroup: 删除分组
 - ECRBookShelfManagTypeBookrackRemoveBook: 书籍移出书架 即从书架中 删除书籍
 */
typedef NS_ENUM(NSUInteger, ECRBookShelfManagType) {
    ECRBookShelfManagTypeAddToBookrack = 1,
    ECRBookShelfManagTypeAddToGroup,
    ECRBookShelfManagTypeGroupRemoveBook,
    ECRBookShelfManagTypeRemoveGroup,
    ECRBookShelfManagTypeBookrackRemoveBook
};

typedef NS_ENUM(NSUInteger, ECRBookShelfListSort) {
    ECRBookShelfListSortDefault = 1,
    ECRBookShelfListSortBackOrder = 0,
};

#import "ECRDataHandler.h"
@class ECRBookrackModel;

typedef void(^BookShelfSuccess)(NSMutableArray *arrAll,NSMutableArray *arrBuyed,NSInteger abCount,NSInteger bbCount);// abCount:全部图书; bbCount: 已购买图书
typedef void(^BookrackFailure)(NSError *error,NSString *msg);
typedef void(^BookrackSuccess)(id objc);

@interface ECRBookrackDataHandler : ECRDataHandler


/**
 删除分组

 @param groupId NSInteger: 分组id
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)bookShelfDeleteGroupWithGroupId:(NSInteger)groupId success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// 将书籍加入书架
+ (void)bookShelfAddBookToBookrackWithBookId:(NSInteger)bookId success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// 从分组中删除一本书
+ (void)bookShelfDeleteABookFromGroupWithBookId:(NSInteger)bookId groupId:(NSInteger)groupId groupName:(NSString *)groupName success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// 从书架中删除书籍
+ (void)bookshelfDeleteBooksFromGroup:(NSArray<ECRBookrackModel *> *)bookArray success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// 向分组中添加一本书
+ (void)bookShelfAddBookToGroup:(ECRBookrackModel *)model groupModel:(ECRBookrackModel *)groupModel success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// 将两本书合并为一个分组
+ (void)bookShelfDoubleBooksToNewGroupWithFromModel:(ECRBookrackModel *)fromModel toModel:(ECRBookrackModel *)toModel success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// MARK: 管理书架
+ (void)bookShelfManagementWithType:(ECRBookShelfManagType)type bookIds:(id)bookIds groupIds:(id)groupIds groupName:(NSString *)groupName success:(BookrackSuccess)success failure:(BookrackFailure)failure;

// MARK: 修改分组名
+ (void)bookShelfUpdateGroupNameWithGroupId:(NSInteger)groupId groupName:(NSString *)groupName success:(BookrackSuccess)success failure:(BookrackFailure)failure;


/**
 请求书架全部数据

 @param sort 排序方式
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)bookShelfWithSort:(ECRBookShelfListSort)sort success:(BookShelfSuccess)success failure:(BookrackFailure)failure;


@end
