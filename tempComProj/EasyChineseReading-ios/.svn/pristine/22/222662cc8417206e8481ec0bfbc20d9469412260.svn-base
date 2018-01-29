//
//  ECRDataHandler.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//
@class ECRHomeMainModel;

typedef void(^ECRDataHandlerSuccess)(id object);
typedef void(^ECRDataHandlerFailure)(NSString *msg);
typedef void(^ECRDataHandlerCommenFailure)(NSError *error);

#import <Foundation/Foundation.h>
@class ECRHomeMainModel;

@interface ECRDataHandler : NSObject

/**
 上传阅读进度
 
 @param bookId NSInteger 书籍id
 @param progress NSNumber 进度(百分比)
 @param readTime NSString 本次阅读时间 (单位 小时)
 @param totalWord NSNumber 阅读字数
 @param success 成功回调
 @param failure 失败回调
 @param commenFailure 通用失败回调
 */
+ (void)uploadReadProgressBookId:(NSInteger)bookId progress:(NSNumber *)progress readTime:(NSString *)readTime totalWord:(NSNumber *)totalWord success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 虚拟币兑换比例
+ (void)selectCoinrateSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

/**
 // MARK: 余额支付

 @param bookIds 购买书id
 @param juanIds 使用的满减卷id
 @param totalMoney 总价
 @param finalTotalMoney 支付价
 @param score 抵扣积分
 @param success 成功回调
 @param failure 失败回调
 @param commenFailure 通用失败回调
 */
+ (void)yuePayWithBookIds:(NSArray *)bookIds juanIds:(NSArray *)juanIds totalMoney:(CGFloat)totalMoney finalTotalMoney:(CGFloat)finalTotalMoney score:(CGFloat)score orderId:(NSString *)orderId success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 购买系列请求列表
+ (void)selectBuySeriesWithSeries:(NSInteger)series success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

/**
 // 记录笔记,id 传空为新增笔记，传值为修改此id笔记。
 
 @param id 笔记id
 @param bookId 图书id
 @param chapterindex 章节索引
 @param chaptername 章节名
 @param position 笔记坐标
 @param positionoffset 笔记坐标偏移
 @param summarycontent 摘要内容
 @param notecontent 笔记内容
 @param summaryunderlinecolor 摘要下划线颜色
 @param success 成功回调
 @param failure 失败回调
 @param commenFailure 自定义失败回调
 */
- (void)saveMyNoteWithId:(NSNumber *)noteId bookId:(NSInteger)bookId chapterindex:(NSNumber *)chapterindex chaptername:(NSString *)chaptername position:(id)position positionoffset:(id)positionoffset summarycontent:(NSString *)summarycontent notecontent:(NSString *)notecontent summaryunderlinecolor:(NSString *)summaryunderlinecolor success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;
// MARK: 删除笔记
- (void)removeMyNoteWithNoteId:(NSNumber *)noteId success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;


/**
 收藏管理

 @param bookId 书籍id
 @param type 1:添加收藏; 0:移除收藏
 @param success 成功回调
 @param failure 失败回调
 @param commenFailure 通用失败回调
 */
- (void)bookCollectWithBookId:(NSInteger)bookId type:(NSInteger)type success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 管理书架
- (void)bookShelfManagementWithType:(NSInteger)type bookIds:(id)bookIds groupIds:(id)groupIds groupName:(NSString *)groupName success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 修改分组名
- (void)bookShelfWithGroupId:(NSInteger)groupId groupName:(NSString *)groupName success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 书架全部图书
- (void)bookShelfListWithSort:(NSInteger)sort success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 查询用户所有满减卷
- (void)fullminusListWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 专题
// 该方法仅用于 iPad 显示两列时请求，如果正常显示1列，使用下面的方法
- (void)subjectDataWithSpecial:(id)special series:(id)series classify:(id)classify length:(NSInteger)length page:(NSUInteger)page sort:(NSInteger)sort success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 图书分类列表
// MARK: 搜索 接口
/**
 图书分类列表
 
 @param special 专题 id
 @param series 系列 id
 @param classify 分类 id
 @param length 返回数据条数
 @param page 请求起始索引
 @param sort 排序方式
 @param searchName 搜索内容
 @param success 成功回调
 @param failure 失败回调
 @param commenFailure 通用失败回调
 */
- (void)bmListDataWithInterface:(NSString *)interface special:(id)special series:(id)series classify:(id)classify length:(NSInteger)length page:(NSUInteger)page sort:(NSInteger)sort searchName:(NSString *)searchName success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 管理购物车
- (void)manageShopCarDataWithDict:(NSDictionary *)dict success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;
// MARK: 购物车列表
- (void)shopCarDataWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 图书分类
- (void)bmDataWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 图书详情
- (void)biDataWithBookId:(NSInteger)bookId success:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

// MARK: 首页
- (void)homeDataWithSuccess:(ECRDataHandlerSuccess)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

+ (instancetype)sharedDataHandler;
@end
