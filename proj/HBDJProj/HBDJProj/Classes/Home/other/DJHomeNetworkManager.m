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

+ (NSURLSessionTask *)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect{
    return [[self sharedInstance] homeLikeSeqid:seqid add:add praisetype:praisetype success:success failure:failure collect:collect];
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

/// 后台任务记录
- (void)frontIntegralGrade_addReportInformationWithTaskid:(NSInteger)taskid completenum:(NSString *)completenum success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"taskid":[NSString stringWithFormat:@"%ld",taskid],
                            @"completenum":completenum};
    [self sendPOSTRequestWithiName:@"frontIntegralGrade/addReportInformation" param:param success:success failure:failure];
}

- (void)frontNews_selectClassIdWithClassid:(NSInteger)classid sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"classid":[NSString stringWithFormat:@"%ld",classid],
                            @"sort":[NSString stringWithFormat:@"%ld",sort]
                            };
    
    [self sendPOSTRequestWithiName:@"frontNews/selectClassId" param:param success:success failure:failure];
}

/// MARK: 请求电话号码
- (void)requestForServiceNumberSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontIndex/selectDefaultNum" param:@{} success:success failure:failure];
}

- (void)carouselfigure_selectCurriculumDetailWithClassid:(NSInteger)classid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"classid":@(classid).stringValue};
    [self sendPOSTRequestWithiName:@"carouselfigure/selectCurriculumDetail" param:param success:success failure:failure];
}

- (void)homeAddcountWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
//
    NSDictionary *param = @{seqid_key:id};
    [self sendPOSTRequestWithiName:@"/frontNews/addcount" param:param success:success failure:failure];
}
- (void)homeReadPorgressBookid:(NSString *)bookid progress:(CGFloat)progress success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"bookid":bookid,
                            @"progress":[NSString stringWithFormat:@"%f",progress]
                            };
    [self sendPOSTRequestWithiName:@"/frontEbook/addprogress" param:param success:success failure:failure];
}
- (void)homeAlbumListWithClassid:(NSInteger)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"classid":[NSString stringWithFormat:@"%ld",classid]};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontNews/selectList" param:param success:success failure:failure];
}
- (void)homeDigitalListWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontEbook/selectList" param:param success:success failure:failure];
}
- (void)homeDigitalDetailWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{seqid_key:id};
    [self sendPOSTRequestWithiName:@"/frontEbook/select" param:param success:success failure:failure];
}
- (void)homePointNewsDetailWithId:(NSInteger)id type:(DJDataPraisetype)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{seqid_key:[NSString stringWithFormat:@"%ld",id],
                            @"type":[NSString stringWithFormat:@"%ld",type]
                            };
    [self sendPOSTRequestWithiName:@"/frontNews/selectDetail" param:param success:success failure:failure];
}
- (NSURLSessionTask *)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect{
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
                           seqid_key:seqid,
                           type:[NSString stringWithFormat:@"%lu",(unsigned long)praisetype]};
    return [self taskForPOSTRequestWithiName:iName param:dict needUserid:YES success:success failure:failure];
}
- (void)homeChairmanPoineNewsClassid:(NSInteger)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *dict = @{@"classid":[NSString stringWithFormat:@"%ld",(long)classid],
                           };
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontNews/selectList" param:dict success:success failure:failure];
}
- (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSString *type_string = [NSString stringWithFormat:@"%ld",(long)type];
    NSDictionary *dict = @{@"type":type_string,
                           @"search":string?string:@""};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontIndex/lectureSearch" param:dict success:success failure:failure];
}
- (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    /// 首页额外传递 mechanismid 机构id
    NSString *mechanismid = [DJUser sharedInstance].mechanismid?[DJUser sharedInstance].mechanismid:@"";
    NSDictionary *param = @{mechanismid_key:mechanismid};
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
/// MARK: 发送post请求并返回task实例
- (NSURLSessionTask *)taskForPOSTRequestWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    return [[DJNetworkManager sharedInstance] taskForPOSTRequestWithiName:iName param:param needUserid:needUserid success:success failure:failure];
}

CM_SINGLETON_IMPLEMENTION
@end
