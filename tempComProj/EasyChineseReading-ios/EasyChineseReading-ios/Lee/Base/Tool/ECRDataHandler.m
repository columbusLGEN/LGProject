//
//  ECRDataHandler.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRDataHandler.h"
#import "ECRHTTPSessionManager.h"
#import "ECRResObjc.h"
#import "ECRHomeMainModel.h"
#import "ECRBookInfoModel.h"
#import "BookModel.h"
#import "ECRSubjectRowModel.h"
#import "ECRLocationManager.h"
#import "ECRFullminusModel.h"
//#import "AESCipher.h"
#import "ZAES.h"
#import "LGNetworkCache.h"

@interface ECRDataHandler ()

@end

@implementation ECRDataHandler

//+ (void)neededUserIdWithInterface:(NSString *)interface param:(id)param success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
//    param[@"userId_self"] = [self userId];
//    [[self sharedDataHandler] commonGetDataWithInterface:interface param:param success:^(id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//
//    } failure:failure commenFailure:commenFailure];
//}

// MARK: 上传阅读进度
+ (void)uploadReadProgressBookId:(NSInteger)bookId progress:(NSNumber *)progress readTime:(NSString *)readTime totalWord:(NSNumber *)totalWord success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"bookId"] = [NSString stringWithFormat:@"%ld",bookId];
    param[@"userId"] = [self userId];
    param[@"progress"] = [NSString stringWithFormat:@"%@",progress];
    param[@"readTime"] = readTime;
    //    param[@"totalWord"] = @"";
    [[self sharedDataHandler] commonGetDataWithInterface:@"read/recordReadHistory" param:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:failure commenFailure:commenFailure];
    
}

// MARK: 虚拟币兑换比例
+ (void)selectCoinrateSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    /// user/selectCoinrate
    NSMutableDictionary *param = [NSMutableDictionary new];
    [[self sharedDataHandler] commonGetDataWithInterface:@"user/selectCoinrate" param:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:failure commenFailure:commenFailure];
}

// MARK: 余额支付
// 创建订单 & 继续支付订单
+ (void)yuePayWithBookIds:(NSArray *)bookIds juanIds:(NSArray *)juanIds totalMoney:(CGFloat)totalMoney finalTotalMoney:(CGFloat)finalTotalMoney score:(CGFloat)score orderId:(NSString *)orderId success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure {
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"orderId"] = orderId;
    param[@"userId"] = [self userId];
    param[@"totalmoney"] = [NSString stringWithFormat:@"%f",totalMoney];
    if (juanIds == nil) {
        param[@"fullMinusCost"] = @"";
    }else{
        param[@"fullMinusCost"] = [juanIds componentsJoinedByString:@","];
    }
    param[@"finalTotalMoney"] = [NSString stringWithFormat:@"%f",finalTotalMoney];
    param[@"id"] = @"0";
    param[@"rechargeMoney"] = @"0";
    param[@"score"] = [NSString stringWithFormat:@"%f",score];
    param[@"type"] = @"0";
    param[@"payType"] = @"0";
    param[@"booksId"] = [bookIds componentsJoinedByString:@","];
    param[@"domorfore"] = [NSString stringWithFormat:@"%d",![ECRLocationManager currentLocationIsChina]];// domorfore:  0国内,1国外
    
    NSString *joger;
    if (orderId.length > 0) {
        joger = @"order/updateOrder";
    }else{
        joger = @"order/addOrder";
    }
    NSLog(@"创建订单(addOrder) & 继续支付(updateOrder) -- %@",joger);
    [[self sharedDataHandler] commonGetDataWithInterface:joger param:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:failure commenFailure:commenFailure];
    
}

// MARK: 购买系列请求列表
+ (void)selectBuySeriesWithSeries:(NSInteger)series success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    [[self sharedDataHandler] selectBuySeriesWithSeries:series success:success failure:failure commenFailure:commenFailure];
}
- (void)selectBuySeriesWithSeries:(NSInteger)series success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"series"] = [NSString stringWithFormat:@"%ld",series];
    param[@"userId"] = [self userId];
    [self commonGetDataWithInterface:@"books/selectBuySeries" param:param success:^(id responseObject) {
        NSArray *arr = responseObject;
        NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:10];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            NSLog(@"keyvalues -- %@",obj);
            BookModel *book = [BookModel mj_objectWithKeyValues:obj];
            //            NSLog(@"model -- %@ -- %@ -- %@",book,[book class],book.bookName);
            [arrm addObject:book];
        }];
        if (success) {
            success(arrm.copy);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 记录笔记
- (void)saveMyNoteWithId:(NSNumber *)noteId bookId:(NSInteger)bookId chapterindex:(NSNumber *)chapterindex chaptername:(NSString *)chaptername position:(id)position positionoffset:(id)positionoffset summarycontent:(NSString *)summarycontent notecontent:(NSString *)notecontent summaryunderlinecolor:(NSString *)summaryunderlinecolor success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"id"] = [NSString stringWithFormat:@"%@",noteId];
    param[@"bookId"] = [NSString stringWithFormat:@"%ld",bookId];
    param[@"chapterindex"] = [NSString stringWithFormat:@"%@",chapterindex];
    param[@"chaptername"] = chaptername;
    //    param[@"position"];
    //    param[@"positionoffset"];
    param[@"summarycontent"] = summarycontent;
    param[@"notecontent"] = notecontent;
    param[@"summaryunderlinecolor"] = summaryunderlinecolor;
    param[@"userId"] = [self userId];
    [self commonGetDataWithInterface:@"epubReadingInformation/saveMyNote" param:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
    
}
// MARK: 删除笔记
- (void)removeMyNoteWithNoteId:(NSNumber *)noteId success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"id"] = [NSString stringWithFormat:@"%@",noteId];
    param[@"userId"] = [self userId];
    [self commonGetDataWithInterface:@"epubReadingInformation/recordReadHistory" param:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 收藏图书
- (void)bookCollectWithBookId:(NSInteger)bookId type:(NSInteger)type success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"type"] = [NSString stringWithFormat:@"%ld",type];
    param[@"bookId"] = [NSString stringWithFormat:@"%ld",bookId];
    param[@"userId"] = [self userId];
    [self commonGetDataWithInterface:@"collection/collectionManagement" param:param success:^(id responseObject) {
        if (success) {
            //            NSLog(@"responseobject -- %@",responseObject);
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 管理书架
- (void)bookShelfManagementWithType:(NSInteger)type bookIds:(id)bookIds groupIds:(id)groupIds groupName:(NSString *)groupName success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    param[@"type"] = [NSString stringWithFormat:@"%ld",type];
    param[@"bookId"] = bookIds;
    param[@"groupId"] = groupIds;
    param[@"groupName"] = groupName ? groupName : @"";
    param[@"userId"] = [self bookshelfTestId];// 书架用1测试
    [self commonGetDataWithInterface:@"bookshelf/bookShelfManagement" param:param success:^(id responseObject) {
        if (success) {
            NSLog(@"responseobject -- %@",responseObject);
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 修改分组名
- (void)bookShelfWithGroupId:(NSInteger)groupId groupName:(NSString *)groupName success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    param[@"groupId"] = [NSString stringWithFormat:@"%ld",groupId];
    param[@"groupName"] = groupName;
    param[@"userId"] = [self bookshelfTestId];// 书架用1测试
    [self commonGetDataWithInterface:@"bookshelf/updatebookShelfGroupName" param:param success:^(id responseObject) {
        if (success) {
            //            NSLog(@"responseobject -- %@",responseObject);
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 书架全部图书
- (void)bookShelfListWithSort:(NSInteger)sort success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    param[@"userId"] = [self bookshelfTestId];
    param[@"sort"] = [NSString stringWithFormat:@"%ld",sort];
    [self commonGetDataWithInterface:@"bookshelf/bookShelf" param:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 查询用户所有满减卷
- (void)fullminusListWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    param[@"userId"] = [self userId];
    // shoppingcart/shoppingCart
    [self commonGetDataWithInterface:@"cardCouponsInfo/getUserFullminusCard" param:param success:^(id responseObject) {
        NSArray *arr = responseObject;
        NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:10];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ECRFullminusModel *model = [ECRFullminusModel mj_objectWithKeyValues:obj];
            [arrm addObject:model];
        }];
        if (arrm.count == 0) {
            arrm = nil;
        }
        if (success) {
            success(arrm.copy);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 专题
// 该方法仅用于 iPad 显示两列时请求，如果正常显示1列，使用下面的方法
- (void)subjectDataWithSpecial:(id)special series:(id)series classify:(id)classify length:(NSInteger)length page:(NSUInteger)page sort:(NSInteger)sort success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    //    param[@"userId"] = [self userId];
    param[@"special"] = [self parameterWithParameter:special];
    param[@"series"] = [self parameterWithParameter:series];
    param[@"classify"] = [self parameterWithParameter:classify];
    
    param[@"length"] = [NSString stringWithFormat:@"%ld",length];
    param[@"page"] = [NSString stringWithFormat:@"%ld",page];
    param[@"sort"] = [NSString stringWithFormat:@"%ld",sort];
    //    NSLog(@"rgparam -- %@",param);
    [self commonGetDataWithInterface:@"books/books" param:param success:^(id responseObject) {
        NSArray *arr = responseObject;
        if (success) {
            success(arr);
        }
    } failure:failure commenFailure:commenFailure];
}
// MARK: 管理购物车
- (void)manageShopCarDataWithDict:(NSDictionary *)dict success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    param[@"userId"] = [self userId];
    [self commonGetDataWithInterface:@"shoppingcart/shoppingCartManagement" param:param success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}
// MARK: 购物车列表
- (void)shopCarDataWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    param[@"userId"] = [self userId];
    // shoppingcart/shoppingCart
    [self commonGetDataWithInterface:@"shoppingcart/shoppingCart" param:param success:^(id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 图书分类list
// MARK: 搜索 --> 接口同 books 传入name 即可
- (void)bmListDataWithInterface:(NSString *)interface special:(id)special series:(id)series classify:(id)classify length:(NSInteger)length page:(NSUInteger)page sort:(NSInteger)sort searchName:(NSString *)searchName success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    param[@"special"] = [self parameterWithParameter:special];
    param[@"series"] = [self parameterWithParameter:series];
    param[@"classify"] = [self parameterWithParameter:classify];
    
    param[@"name"] = searchName;
    
    param[@"length"] = [NSString stringWithFormat:@"%ld",length];
    param[@"page"] = [NSString stringWithFormat:@"%ld",page];
    param[@"sort"] = [NSString stringWithFormat:@"%ld",sort];
    param[@"userId"] = [self userId];
    [self commonGetDataWithInterface:interface param:param success:^(id responseObject) {
        NSArray *arr = responseObject;
        NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:10];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            NSLog(@"keyvalues -- %@",obj);
            BookModel *book = [BookModel mj_objectWithKeyValues:obj];
            //            NSLog(@"model -- %@ -- %@ -- %@",book,[book class],book.bookName);
            [arrm addObject:book];
        }];
        if (success) {
            success(arrm.copy);
        }
    } failure:failure commenFailure:commenFailure];
}


// MARK: 图书分类
- (void)bmDataWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    [self commonGetDataWithInterface:@"books/classifyBook" param:param success:^(id responseObject) {
        
        if (success) {
            success([responseObject firstObject]);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 书籍详情请求
- (void)biDataWithBookId:(NSInteger)bookId success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    param[@"bookId"] = [NSString stringWithFormat:@"%ld",bookId];
    param[@"userId"] = [self userId];
    //books/bookDetails
    [self commonGetDataWithInterface:@"books/bookDetails" param:param success:^(id responseObject) {
        ECRBookInfoModel *model = [ECRBookInfoModel mj_objectWithKeyValues:[responseObject firstObject]];
        if (success) {
            success(model);
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 首页请求
- (void)homeDataWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    //    param[@"imei"] = @"imei";
    //    param[@"imsi"] = @"imsi";
    [self commonGetDataWithInterface:@"books/index" param:param success:^(id responseObject) {
        if (responseObject == nil) {
            if (failure) {
                failure(@"返回数据为空");
            }
        }else{
            ECRHomeMainModel *homeModel = [ECRHomeMainModel mj_objectWithKeyValues:[responseObject firstObject]];
            if (success) {
                success(homeModel);
            }
        }
    } failure:failure commenFailure:commenFailure];
}

- (NSString *)userId{
    return [NSString stringWithFormat:@"%ld",[UserRequest sharedInstance].user.userId];
}
+ (NSString *)userId{
    return [NSString stringWithFormat:@"%ld",[UserRequest sharedInstance].user.userId];
}

// 书架 测试id
- (NSString *)bookshelfTestId{
    return [self userId];
}

+ (instancetype)sharedDataHandler{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)parameterWithParameter:(id)parameter{
    return parameter ? parameter:@"";
}
- (NSString *)stringWithInteger:(NSInteger)integer{
    return [NSString stringWithFormat:@"%ld",integer];
}

// MARK: 通用请求
- (void)commonGetDataWithInterface:(NSString *)interface param:(id)param success:(void(^)(id responseObject))success failure:(ECRDataHandlerFailure)failure commenFailure:(void (^)(NSError *error))commenFailure{
    param[@"imei"] = @"imei";
    param[@"imsi"] = @"imsi";
    param[@"userId"] = [self userId];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    parameters[@"params"] = param;
    parameters[@"md5"] = @"md5";
    // MARK: 加密
    //    NSString *paramString = [ZAES AES128EncryptStrig:[parameters mj_JSONString]];
    //    NSString *paramString = [parameters mj_JSONString];
    //    NSLog(@"请求参数 -- %@",paramString);
    
    [[ECRHTTPSessionManager sharedManager] POSTWithInterface:interface param:parameters success:^(id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSString *en_msg = [responseObject objectForKey:@"en_msg"];
        NSNumber *result = [responseObject objectForKey:@"result"];
        
        NSLog(@"(interface: %@) (result:%@) (msg/en_msg:%@_%@)",interface,result,msg,en_msg);
        
        if (result.integerValue == 0) {
            // MARK: 解密
            //            NSString *jsonString = [ZAES AES128DecryptString:[responseObject objectForKey:@"returnJson"]];
            NSString *jsonString = [responseObject objectForKey:@"returnJson"];
            
            if (jsonString != nil && ![jsonString isKindOfClass:[NSNull class]]) {
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                id jsonObjc = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                //MARK: 异步写入缓存
                /// interface 一定要与 callBackCacheJsonObjWithInterFace 中的interface 一致
                [LGNetworkCache lg_save_asyncJsonToCacheFile:jsonObjc URLString:interface params:parameters];
                
                if (success) {
                    success(jsonObjc);
                }
            }else{
                [self callBackFailureInfoWithFailure:failure msg:msg en_msg:en_msg];
            }
        }else if(result.integerValue == 1){
            [self callBackFailureInfoWithFailure:failure msg:msg en_msg:en_msg];
        }else if(result.integerValue == 3 || result.integerValue == 4){
            // 3: token错误
            // 4: 密码被修改
            [[UserRequest sharedInstance] kickoutWithMessage:[LGPChangeLanguage currentLanguageIsEnglish] ? en_msg : msg];
            [self callBackFailureInfoWithFailure:failure msg:msg en_msg:en_msg];
        }else{
            [self callBackCacheJsonObjWithInterFace:interface parameters:parameters success:success failure:nil commenFailure:commenFailure];
        }
    } failure:^(NSError *error) {
        [self callBackCacheJsonObjWithInterFace:interface parameters:parameters success:success failure:nil commenFailure:commenFailure];
    }];
    
}
//MARK: 获取缓存数据
- (void)callBackCacheJsonObjWithInterFace:(NSString *)interface parameters:(id)parameters success:(void(^)(id responseObject))success failure:(ECRDataHandlerFailure)failure commenFailure:(void (^)(NSError *error))commenFailure{
    id cacheJson = [LGNetworkCache lg_cache_jsonWithURLString:interface params:parameters];
    if (cacheJson) {
        if (success) success(cacheJson);
    }else{
        if (commenFailure) {
            commenFailure(nil);
        }
    }
}
// MARK: 回调失败信息
- (void)callBackFailureInfoWithFailure:(ECRDataHandlerFailure)failure msg:(NSString *)msg en_msg:(NSString *)en_msg{
    if (failure) {
        if ([LGPChangeLanguage currentLanguageIsEnglish]) {
            failure(en_msg);
        }else{
            failure(msg);
        }
    }
}
@end
