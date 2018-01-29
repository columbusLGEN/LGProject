//
//  ClassRequest.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseNetRequest.h"

@interface ClassRequest : BaseNetRequest

#pragma mark ========== 班级管理相关网络请求 ==========

CM_SINGLETON_INTERFACE(ClassRequest)

#pragma mark - 查看班级接口

/**
 查看班级接口
 
 @param completion 回调
 */
- (void)getClassesWithUserType:(NSInteger)userType
                    Completion:(CompleteBlock)completion;

#pragma mark - 班级管理

/**
 添加或修改班级信息
 
 @param type        修改类型：1:新增 2:修改 3:删除
 @param classId     班级id
 @param teacherId   教师id
 @param className   班级名
 @param synopsis    简介
 @param studentNum  学生人数
 @param completion  回调
 */
- (void)updateClassInfoWithType:(NSInteger )type
                        classId:(NSInteger )classId
                      teacherId:(NSInteger )teacherId
                     studentNum:(NSInteger )studentNum
                      className:(NSString *)className
                      synopsis:(NSString *)synopsis
                     completion:(CompleteBlock)completion;

/**
 删除班级

 @param classId    班级 id
 @param completion  回调
 */
- (void)deleteClassWithClassId:(NSInteger)classId
                    completion:(CompleteBlock)completion;

#pragma mark - 教师管理

/**
 获取教师列表

 @param completion 回调
 */
- (void)getTeachersWithCompletion:(CompleteBlock)completion;

/**
 创建教师
 
 @param phone      手机号
 @param email      邮箱
 @param areacode   国家码
 @param password   密码
 @param name       教师名
 @param sex        性别
 @param age        年龄
 @param remark     备注
 @param completion 回调
 */
- (void)addTeacherInfoWithPhone:(NSString *)phone
                          email:(NSString *)email
                       password:(NSString *)password
                       areacode:(NSString *)areacode
                           name:(NSString *)name
                            sex:(NSInteger)sex
                            age:(NSString *)age
                         remark:(NSString *)remark
                     completion:(CompleteBlock)completion;

/**
 修改教师
 
 @param type        类型
 @param teacherId   教师 id
 @param password    密码
 @param name        昵称
 @param sex         性别
 @param age         年龄
 @param remark      备注
 @param completion  回调
 */
- (void)updateTeacherWithType:(NSInteger )type
                    teacherId:(NSInteger )teacherId
                     password:(NSString *)password
                         name:(NSString *)name
                          sex:(NSInteger )sex
                          age:(NSInteger )age
                       remark:(NSString *)remark
                   completion:(CompleteBlock)completion;


/**
 删除教师信息

 @param teacherId  教师 id
 @param completion  回调
 */
- (void)deleteTeacherWithTeacherId:(NSInteger)teacherId
                        completion:(CompleteBlock)completion;


#pragma mark - 获取学生列表接口

/**
 获取学生列表
 
 @param classId    班级id
 @param completion 回调
 */
- (void)getStudentsWithClassId:(NSString *)classId
                    completion:(CompleteBlock)completion;

/**
 获取单个学生信息
 
 @param studentId  学生id
 @param completion 回调
 */
- (void)getStudentInfoWithStudentId:(NSString *)studentId
                         completion:(CompleteBlock)completion;

/**
 新建学生
 
 @param classId     班级id
 @param name        学生姓名
 @param age         年龄
 @param phone       手机）
 @param password    密码
 @param sex         性别
 @param areacode    国家码
 @param email       邮箱
 @param remark      备注
 @param type        账号类型
 @param completion  回调
 */

- (void)addStudentInfoWithClassId:(NSInteger )classId
                             name:(NSString *)name
                              age:(NSInteger )age
                            Phone:(NSString *)phone
                         areacode:(NSString *)areacode
                            email:(NSString *)email
                         password:(NSString *)password
                              sex:(NSInteger )sex
                           remark:(NSString *)remark
                       completion:(CompleteBlock)completion;

/**
 修改学生
 
 @param classId     班级id
 @param userId      学生 id
 @param name        学生姓名
 @param age         年龄
 @param password    密码
 @param sex         性别
 @param remark      备注
 @param completion  回调
 */
- (void)updateStudentInfoWithClassId:(NSInteger )classId
                              userId:(NSInteger )userId
                                name:(NSString *)name
                                 age:(NSInteger )age
                            password:(NSString *)password
                                 sex:(NSInteger )sex
                              remark:(NSString *)remark
                          completion:(CompleteBlock)completion;

/**
 删除学生
 
 @param studentId  学生 id
 @param completion 回调
 */
- (void)deleteStudentWithStudentId:(NSInteger)studentId Completion:(CompleteBlock)completion;

#pragma mark - 查看阅读进度

/**
 查看班级阅读进度
 
 @param classId     班级id
 @param completion  回调
 */
- (void)getReadingProgressWithClassId:(NSInteger)classId
                           completion:(CompleteBlock)completion;

/**
 查询学生的阅读进度
 
 @param studentId  学生id
 @param completion 回调
 */
- (void)getReadingProgressWithStudentId:(NSInteger)studentId
                             completion:(CompleteBlock)completion;

#pragma mark - 站内信

/**
 发送站内信
 
 @param type        ？
 @param name        发送者姓名
 @param message     信息内容
 @param studentId   学生id 数组
 @param completion  回调
 */
- (void)sendMessageWithType:(NSString *)type
                       name:(NSString *)name
                    message:(NSString *)message
                  studentId:(NSString *)studentId
                 completion:(CompleteBlock)completion;


/**
 查看发送的站内信

 @param page       页码
 @param length     每页数据量
 @param completion 回调
 */
- (void)getMessagesWithPage:(NSInteger)page
                     length:(NSInteger)length
                 completion:(CompleteBlock)completion;


#pragma mark - 图书推荐

/**
 获取班级班级展示的推荐给我的书籍

 @param completion 回调
 */
- (void)getRecommedToMeCompletion:(CompleteBlock)completion;

/**
 获取推荐列表

 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getRecommendListWithPage:(NSInteger)page
                          length:(NSInteger)length
                      completion:(CompleteBlock)completion;

/**
 获取推荐详情

 @param shareBatchId 推荐 id
 @param completion   回调
 */
- (void)getRecommendDetailWithShareBatchId:(NSInteger)shareBatchId
                                completion:(CompleteBlock)completion;

#pragma mark - 授权

/**
 获取可授权的图书
 
 @param sort        排序 (时间->销量 价格 评分)
 @param classify    分类 id
 @param series      系列 id
 @param page        页码
 @param length      每页数量
 @param completion  回调
 */
- (void)getCanImpowerBooksWithSort:(ENUM_FavouriteSortType)sort
                          classify:(NSInteger)classify
                            series:(NSInteger)series
                              page:(NSInteger)page
                            length:(NSInteger)length
                        completion:(CompleteBlock)completion;

/**
 获取授权列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getImpowerListWithPage:(NSInteger)page
                        length:(NSInteger)length
                    completion:(CompleteBlock)completion;

/**
 获取授权详情
 
 @param grantBatchId 推荐 id
 @param completion   回调
 */
- (void)getImpowerDetailWithGrantBatchId:(NSInteger)grantBatchId
                              completion:(CompleteBlock)completion;

/**
 教师推荐图书给学生(好友推荐图书给好友)
 
 @param shareTitle 分享的标题
 @param bookIds    图书 id 数组
 @param studentIds 学生 id 数组
 @param type       类型(0 推荐给好友 1 推荐给学生)
 @param completion 回调
 */
- (void)recommendBooksWithShareTitle:(NSString *)shareTitle
                             bookIds:(NSString *)bookIds
                          studentIds:(NSString *)studentIds
                                type:(NSInteger )type
                          completion:(CompleteBlock)completion;


/**
 授权(机构授权给教师或学生, 教师授权给学生)
 
 @param content       分享标题
 @param bookIds       图书 id 数组
 @param studentIds    教师或学生 id 数组
 @param startTime     授权开始时间
 @param endTime       授权截止时间
 @param completion    回调
 */
- (void)impowerBookWithContent:(NSString *)content
                       bookIds:(NSString *)bookIds
                    studentIds:(NSString *)studentIds
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                    completion:(CompleteBlock)completion;

/**
 取消授权

 @param grantBatchId 授权 id
 @param type         类型
 @param completion   回调
 */
- (void)cancelImpowerWithGrantBatchId:(NSInteger)grantBatchId
                                 type:(NSInteger)type
                           completion:(CompleteBlock)completion;


/**
 验证选中的图书的授权时间

 @param ownIds 图书在拥有书籍表中ids "1,2,3"
 @param completion 回调
 */
- (void)verifyImpowerBookTimeRangeWithOwnIds:(NSString *)ownIds
                                  completion:(CompleteBlock)completion;

@end
