//
//  DJNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK: 党建项目专用请求管理者

#import <Foundation/Foundation.h>

typedef void(^DJNetworkSuccess)(id responseObj);
typedef void(^DJNetworkFailure)(id failureObj);

@interface DJNetworkManager : NSObject

/// MARK: 收藏/点赞接口
+ (void)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(NSInteger)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect;
/// MARK: 主席要闻列表,专辑列表
+ (void)homeChairmanPoineNewsClassid:(NSString *)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// MARK: 搜索接口
+ (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// MARK: 首页接口
+ (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

+ (instancetype)sharedInstance;
@end
