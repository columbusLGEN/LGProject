//
//  ECRBookrackDataHandler.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/25.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookrackDataHandler.h"
#import "ECRBookrackModel.h"
#import "ECRDownloadStateModel.h"
#import "ECRLocalFileFinder.h"

@interface ECRBookrackDataHandler ()
/** 本地图书 */
@property (strong,nonatomic) NSArray<ECRBookrackModel *> *localBookrackModels;

@end

@implementation ECRBookrackDataHandler

// 删除分组
+ (void)bookShelfDeleteGroupWithGroupId:(NSInteger)groupId success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    NSString *gid = [NSString stringWithFormat:@"%ld",groupId];
    [self bookShelfManagementWithType:ECRBookShelfManagTypeRemoveGroup bookIds:nil groupIds:gid groupName:nil success:success failure:failure];
}

// 将书籍加入书架
+ (void)bookShelfAddBookToBookrackWithBookId:(NSInteger)bookId success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    NSString *bid = [NSString stringWithFormat:@"%ld",bookId];
    [self bookShelfManagementWithType:ECRBookShelfManagTypeAddToBookrack bookIds:bid groupIds:nil groupName:nil success:success failure:failure];
}

// 从分组中删除一本书
+ (void)bookShelfDeleteABookFromGroupWithBookId:(NSInteger)bookId groupId:(NSInteger)groupId groupName:(NSString *)groupName success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    // type = 3
    NSString *bid = [NSString stringWithFormat:@"%ld",bookId];
    NSString *gid = [NSString stringWithFormat:@"%ld",groupId];
    [self bookShelfManagementWithType:ECRBookShelfManagTypeGroupRemoveBook bookIds:bid groupIds:gid groupName:groupName success:success failure:failure];
}

// 从书架中删除书籍
+ (void)bookshelfDeleteBooksFromGroup:(NSArray<ECRBookrackModel *> *)bookArray success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    
    // 取出全部书籍 id
    NSMutableArray *bookIds = [NSMutableArray new];
    [bookArray enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bookIds addObject:[NSString stringWithFormat:@"%ld",obj.bookId]];
    }];
//    NSArray *bookIdsString = [bookIds componentsJoinedByString:@","];
    [self bookShelfManagementWithType:ECRBookShelfManagTypeBookrackRemoveBook bookIds:bookIds.copy groupIds:nil groupName:nil success:^(id objc) {
        if (success) {
            success(objc);
        }
    } failure:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error,msg);
        }
    }];
}

// 向分组中添加一本书
+ (void)bookShelfAddBookToGroup:(ECRBookrackModel *)model groupModel:(ECRBookrackModel *)groupModel success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    [self bookShelfManagementWithType:ECRBookShelfManagTypeAddToGroup bookIds:[NSString stringWithFormat:@"%ld",model.bookId] groupIds:[NSString stringWithFormat:@"%ld",groupModel.groupId] groupName:groupModel.groupName success:^(id objc) {
        
    } failure:^(NSError *error, NSString *msg) {
        
    }];
}

// 将两本书合并为一个分组
+ (void)bookShelfDoubleBooksToNewGroupWithFromModel:(ECRBookrackModel *)fromModel toModel:(ECRBookrackModel *)toModel success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    NSArray *bookIds = @[@(fromModel.bookId),@(toModel.bookId)];
    [self bookShelfManagementWithType:ECRBookShelfManagTypeAddToGroup bookIds:bookIds groupIds:@"0" groupName:@"分组" success:success failure:failure];
}

// MARK: 管理书架
/**
 type
     1 -- 将书籍添加进书架,将书籍加入到书架默认界面
     2 -- 将两本书合并为一个分组 & 向分组中添加一本书
     3 -- 书籍移除分组
     4 -- 删除分组
     5 -- 书籍移出书架 即从书架中 删除书籍
 */
+ (void)bookShelfManagementWithType:(ECRBookShelfManagType)type bookIds:(id)bookIds groupIds:(id)groupIds groupName:(NSString *)groupName success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    if ([bookIds isKindOfClass:[NSArray class]]) {
        bookIds = [bookIds componentsJoinedByString:@","];
    }
    if ([groupIds isKindOfClass:[NSArray class]]) {
        groupIds = [groupIds componentsJoinedByString:@","];
    }

    [[ECRDataHandler sharedDataHandler] bookShelfManagementWithType:type bookIds:bookIds groupIds:groupIds groupName:groupName success:^(id object) {
        if (success) {
            success(object);
        }
    } failure:^(NSString *msg) {
        if (failure) {
            failure(nil,msg);
        }
    } commenFailure:^(NSError *error) {
        if (failure) {
            failure(error,nil);
        }
    }];
}

// MARK: 修改分组名
//bookshelf/updatebookShelfGroupName
+ (void)bookShelfUpdateGroupNameWithGroupId:(NSInteger)groupId groupName:(NSString *)groupName success:(BookrackSuccess)success failure:(BookrackFailure)failure{
    [[ECRDataHandler sharedDataHandler] bookShelfWithGroupId:groupId groupName:groupName success:^(id object) {
        if (success) {
            success(nil);
        }
    } failure:^(NSString *msg) {
        if (failure) {
            failure(nil,msg);
        }
    } commenFailure:^(NSError *error) {
        if (failure) {
            failure(error,nil);
        }
    }];
}

// MARK: 请求全部图书
+ (void)bookShelfWithSort:(ECRBookShelfListSort)sort success:(BookShelfSuccess)success failure:(BookrackFailure)failure;{
    [[self sharedInstance] bookShelfWithSort:sort success:success failure:failure];
}
- (void)bookShelfWithSort:(ECRBookShelfListSort)sort success:(BookShelfSuccess)success failure:(BookrackFailure)failure;{
    __block NSInteger abCount = 0;/// 全部图书总数
    __block NSInteger bbCount = 0;/// 已购买图书总数 --> 只有在 owendType == 1时才加1且分组减1
    
    // MARK: 获取本地书籍
    [ECRLocalFileFinder findLocalEpubAndPdfInDocuments:^(NSArray<ECRBookrackModel *> *array) {
        NSLog(@"本地书籍模型数组 -- %@",array);
        self.localBookrackModels = array;
        abCount = array.count;// 本地书籍数 计算在书籍总数之内, 否则造成书架无法全选
    }];
    
    [[ECRDataHandler sharedDataHandler] bookShelfListWithSort:sort success:^(id object) {
        NSArray *arr = object;
        // 全部图书
        NSMutableArray *arrm = [NSMutableArray array];
        // 已购买图书
        NSMutableArray *arrmBuyed = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ECRBookrackModel *book = [ECRBookrackModel mj_objectWithKeyValues:obj];
            book.isEditState = NO;
            book.currentPlace = 1;
            abCount += 1;
            
            // 下载状态模型
            [self bookSetDsModel:book];
            
            //            NSLog(@"book -- %ld",book.owendType);
            if (book.books.count != 0) {// 该模型为文件夹
                abCount -= 1;
                [book.books enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull book_group,
                                                         NSUInteger idx_group, BOOL * _Nonnull stop_group) {
                    book_group.currentPlace = 1;
                    //                    NSLog(@"sbookname %@ --iconurl %@",book_group.bookName,book_group.iconUrl);
                    abCount += 1;
                    book_group.isEditState = NO;
                    
                    [self bookSetDsModel:book_group];
                }];
                
            }
            [arrm addObject:book];
            /// 过滤掉空文件夹
            if (book.books.count == 0 && book.groupId != 0) {
                /// 调用接口删除该分组
                NSString *gid = [NSString stringWithFormat:@"%ld",book.groupId];
                [self bookShelfManagementWithType:ECRBookShelfManagTypeRemoveGroup bookIds:nil groupIds:gid groupName:book.groupName success:^(id object) {
                   NSLog(@"删除分组成功 -- %@",book.groupName);
                } failure:^(NSString *msg) {
                    NSLog(@"删除分组失败 -- %@ -- msg: %@",book.groupName,msg);
                } commenFailure:^(NSError *error) {
                    NSLog(@"删除分组失败 -- %@",book.groupName);
                }];
                
                /// 从数组中删除该数据
                abCount -= 1;
                [arrm removeObject:book];
            }
            
            // MARK: 已购买处理
            if (book.owendType == 1) {
                bbCount += 1;
                if (book.books.count != 0) {// 该模型为文件夹
                    bbCount -= 1;
                    [book.books enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull book_group,
                                                             NSUInteger idx_group, BOOL * _Nonnull stop_group) {
                        book_group.isEditState = NO;
                        [self bookSetDsModel:book_group];
                        
                        if (book_group.owendType == 1) {
                            bbCount += 1;
                            ECRBookrackModel *copyBook_group = [book_group copy];
                            [self bookSetDsModel:copyBook_group];
                            [book.alreadyBuyBooks addObject:copyBook_group];
                        }
                    }];
                    //                    NSLog(@"已购买group -- %@",book.alreadyBuyBooks);
                }
                ECRBookrackModel *copyBook = [book copy];
                [self bookSetDsModel:copyBook];
                [arrmBuyed addObject:copyBook];
            }
        }];
        
        // MARK: 添加本地书籍
        [arrm addObjectsFromArray:self.localBookrackModels];
        if (success) {
            success(arrm,arrmBuyed,abCount,bbCount);
        }
    } failure:^(NSString *msg) {
        if (failure) {
            failure(nil,msg);
        }
    } commenFailure:^(NSError *error) {
        if (failure) {
            failure(error,nil);
        }
    }];

}

- (void)bookSetDsModel:(ECRBookrackModel *)book{
    ECRDownloadStateModel *dsModel = [[ECRDownloadStateModel alloc] init];// download state
    book.dsModel = dsModel;
    dsModel.brModel = book;
    [dsModel localBookExist];
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


// 根据type 生成下载链接
//         NSString *URLString = @"http://123.59.197.176/group1/M00/00/01/CgoKBFoKft2Ad_aGAE31tVJfh_w438.pdf";// pdf 测试链接
//        NSString *URLString = @"http://192.168.10.68:8080/BLCUPManageSystem/book/epub/9787561944882.epub";// epub 测试链接
//    NSString *URLString = @"http://123.59.197.176/group1/M00/00/01/CgoKBFoEGTmAN5SaAv7FFFfh4_U313.dbz";// dbz 测试链接 超媒体压缩包


@end
