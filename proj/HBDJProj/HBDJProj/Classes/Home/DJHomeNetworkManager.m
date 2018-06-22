//
//  DJHomeNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJHomeNetworkManager.h"

@implementation DJHomeNetworkManager

+ (void)homeDigitalListWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort  success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeDigitalListWithOffset:offset length:length sort:sort success:success failure:failure];
}

/// MARK: 数字阅读图书详情
+ (void)homeDigitalDetailWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeDigitalDetailWithId:id success:success failure:failure];
}

+ (void)homePointNewsDetailWithId:(NSInteger)id type:(DJDataPraisetype)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homePointNewsDetailWithId:id type:type success:success failure:failure];
}

+ (void)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect{
    [[self sharedInstance] homeLikeSeqid:seqid add:add praisetype:praisetype success:success failure:failure collect:collect];
}

+ (void)homeChairmanPoineNewsClassid:(NSInteger)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeChairmanPoineNewsClassid:classid offset:offset length:length sort:sort success:success failure:failure];
}

+ (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeSearchWithString:string type:type offset:offset length:length sort:sort success:success failure:failure];
}
/// MARK: 首页接口
+ (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeIndexWithSuccess:success failure:failure];
}

/// MARK: -----分割线-----
- (void)homeDigitalListWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontEbook/selectList" param:param success:success failure:failure];
}
- (void)homeDigitalDetailWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"seqid":id};
    [self sendPOSTRequestWithiName:@"/frontEbook/select" param:param success:success failure:failure];
}
- (void)homePointNewsDetailWithId:(NSInteger)id type:(DJDataPraisetype)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"seqid":[NSString stringWithFormat:@"%ld",id],
                            @"type":[NSString stringWithFormat:@"%ld",type]
                            };
    [self sendPOSTRequestWithiName:@"/frontNews/selectDetail" param:param success:success failure:failure];
}
- (void)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect{
    NSString *iName = nil;
    NSString *type = nil;
    if (collect) {
        NSLog(@"收藏接口 -- ");
        iName = @"/frontUserCollections/add";
        type = @"cellectiontype";
    }else{
        iName = @"/frontUserPraises/add";
        type = @"praisetype";
    }
    NSDictionary *dict = @{@"addordel":[NSString stringWithFormat:@"%d",add],
                           @"seqid":seqid,
                           type:[NSString stringWithFormat:@"%ld",praisetype]};
    [self sendPOSTRequestWithiName:iName param:dict success:success failure:failure];
}
- (void)homeChairmanPoineNewsClassid:(NSInteger)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *dict = @{@"classid":[NSString stringWithFormat:@"%ld",classid],
                           };
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontNews/selectList" param:dict success:success failure:failure];
}
- (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSString *type_string = [NSString stringWithFormat:@"%ld",type];
    NSDictionary *dict = @{@"type":type_string,
                           @"search":string};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontIndex/lectureSearch" param:dict success:success failure:failure];
}
- (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"test":@"home"};
    [self sendPOSTRequestWithiName:@"/frontIndex/index" param:param success:success failure:failure];
}

/// MARK: 分页接口统一调用此方法
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] commenPOSTWithOffset:offset length:length sort:sort iName:iName param:param success:success failure:failure];
}

/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendPOSTRequestWithiName:iName param:param success:success failure:failure];
}

CM_SINGLETON_IMPLEMENTION
@end
