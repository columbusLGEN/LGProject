//
//  ClassRequest.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ClassRequest.h"

@implementation ClassRequest

CM_SINGLETON_IMPLEMENTION(ClassRequest)


#pragma mark - 班级管理

/**
 查看班级接口
 
 @param completion 回调
 */
- (void)getClassesWithUserType:(NSInteger)userType
                    Completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"userType": [NSString stringWithFormat:@"%ld", userType]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectClass"
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
                     completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"type"      : [NSString stringWithFormat:@"%ld", type],
                                       @"classId"   : classId > 0 ? [NSString stringWithFormat:@"%ld", classId] : @"",
                                       @"teacherId" : teacherId > 0 ? [NSString stringWithFormat:@"%ld", teacherId] : @"",
                                       @"studentNum": studentNum > 0 ? [NSString stringWithFormat:@"%ld", studentNum] : @"",
                                       @"className" : className.length > 0 ? className : @"",
                                       @"synopsis"  : synopsis.length > 0 ? synopsis : @"",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/classInformation"
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

// 删除班级
- (void)deleteClassWithClassId:(NSInteger)classId
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"type"      : [NSString stringWithFormat:@"%ld", ENUM_UpdateTypeDelete],
                                       @"classId"   : [NSString stringWithFormat:@"%ld", classId]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/classInformation"
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

#pragma mark - 教师管理

/**
 获取教师列表
 
 @param completion 回调
 */
- (void)getTeachersWithCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId" : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectTeacher"
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
                     completion:(CompleteBlock)completion
{
    if ([areacode hasPrefix:@"+"]) {
        areacode = [areacode substringFromIndex:1];
    }
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"phone"     : phone,
                                       @"email"     : email,
                                       @"areacode"  : areacode,
                                       @"password"  : password,
                                       @"name"      : name,
                                       @"sex"       : [NSString stringWithFormat:@"%ld", sex],
                                       @"age"       : age,
                                       @"remark"    : remark,
                                       @"type"      : [NSString stringWithFormat:@"%ld", phone.length > 0 ? ENUM_AccountTypePhone : ENUM_AccountTypeEmail]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/addTeacher"
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
                          sex:(NSInteger)sex
                          age:(NSInteger)age
                       remark:(NSString *)remark
                   completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"type"      : [NSString stringWithFormat:@"%ld", type],
                                       @"teacherId" : [NSString stringWithFormat:@"%ld", teacherId],
                                       @"password"  : password,
                                       @"name"      : name,
                                       @"sex"       : [NSString stringWithFormat:@"%ld", sex],
                                       @"age"       : [NSString stringWithFormat:@"%ld", age],
                                       @"remark"    : remark,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/updateTeacher"
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
 删除教师信息
 
 @param teacherId  教师 id
 @param completion  回调
 */
- (void)deleteTeacherWithTeacherId:(NSInteger)teacherId
                        completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"type"      : [NSString stringWithFormat:@"%ld", ENUM_UpdateTypeDelete],
                                       @"teacherId" : [NSString stringWithFormat:@"%ld", teacherId],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/updateTeacher"
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

#pragma mark - 学生管理

/**
 获取学生列表
 
 @param classId    班级id
 @param completion 回调
 */
- (void)getStudentsWithClassId:(NSString *)classId
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"classId"   : classId,
                                       @"studentId" : @"",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectStudents"
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
 获取单个学生信息
 
 @param studentId  学生id
 @param completion 回调
 */
- (void)getStudentInfoWithStudentId:(NSString *)studentId
                         completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"classId"  : @"",
                                       @"studentId": studentId,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectStudents"
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
                       completion:(CompleteBlock)completion
{
    if ([areacode hasPrefix:@"+"]) {
        areacode = [areacode substringFromIndex:1];
    }
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"classId" : [NSString stringWithFormat:@"%ld", classId],
                                       @"name"    : name,
                                       @"age"     : [NSString stringWithFormat:@"%ld", age],
                                       @"phone"   : phone,
                                       @"password": password,
                                       @"sex"     : [NSString stringWithFormat:@"%ld", sex],
                                       @"areacode": areacode,
                                       @"email"   : email,
                                       @"remark"  : remark,
                                       @"type"    : [NSString stringWithFormat:@"%ld", ENUM_UpdateTypeAdd],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/studentManagement"
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
                          completion:(CompleteBlock)completion
{
                                    // userId --> studentId
    NSDictionary *dic = @{@"params": @{@"studentId"  : [NSString stringWithFormat:@"%ld", userId],
                                       @"classId" : [NSString stringWithFormat:@"%ld", classId],
                                       @"type"    : [NSString stringWithFormat:@"%ld", ENUM_UpdateTypeUp],
                                       @"name"    : name.length > 0 ? name : @"",
                                       @"age"     : [NSString stringWithFormat:@"%ld", age],
                                       @"password": password.length > 0 ? password : @"",
                                       @"sex"     : [NSString stringWithFormat:@"%ld", sex],
                                       @"remark"  : remark
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/studentManagement"
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
 删除学生
 
 @param studentId  学生 id
 @param completion 回调
 */
- (void)deleteStudentWithStudentId:(NSInteger)studentId Completion:(CompleteBlock)completion
{
                                    // userId --> studentId
    NSDictionary *dic = @{@"params": @{@"studentId"  : [NSString stringWithFormat:@"%ld", studentId],
                                       @"classId" : @"0",
                                       @"type"    : [NSString stringWithFormat:@"%ld", ENUM_UpdateTypeDelete],
                                       @"remark"  : @""
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/studentManagement"
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

#pragma mark - 查看阅读进度

/**
 查看班级阅读进度
 
 @param classId     班级id
 @param completion  回调
 */
- (void)getReadingProgressWithClassId:(NSInteger)classId
                           completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"classId"   : [NSString stringWithFormat:@"%ld", classId],
                                       @"studentId" : @"",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/readingProgress"
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
 查询学生的阅读进度
 
 @param studentId  学生id
 @param completion 回调
 */
- (void)getReadingProgressWithStudentId:(NSInteger)studentId
                             completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"studentId" : [NSString stringWithFormat:@"%ld", studentId],
                                       @"classId"   : @"",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/readingProgress"
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
                 completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"type"     : type,
                                       @"message"  : message,
                                       @"studentId": studentId,
                                       @"name"     : name
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/message"
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
 查看发送的站内信
 
 @param page       页码
 @param length     每页数据量
 @param completion 回调
 */
- (void)getMessagesWithPage:(NSInteger)page
                     length:(NSInteger)length
                 completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"     : [NSString stringWithFormat:@"%ld", page],
                                       @"length"   : [NSString stringWithFormat:@"%ld", length],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"message/selectTeacherSendMessage"
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

#pragma mark - 教师推荐

/**
 获取班级班级展示的推荐给我的书籍
 
 @param completion 回调
 */
- (void)getRecommedToMeCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"type"     : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userType],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectClassRecomBooks"
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
 获取推荐列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getRecommendListWithPage:(NSInteger)page
                          length:(NSInteger)length
                      completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : [NSString stringWithFormat:@"%ld", page],
                                       @"length"        : [NSString stringWithFormat:@"%ld", length],
                                       @"shareBatchId"  : @"",
                                       @"type"          : @"0", // 0 列表 1 详情
                                       @"userType"      : @"0", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectshareBook"
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
 获取推荐详情
 
 @param shareBatchId 推荐 id
 @param completion   回调
 */
- (void)getRecommendDetailWithShareBatchId:(NSInteger)shareBatchId
                                completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : @"0",
                                       @"length"        : @"0",
                                       @"shareBatchId"  : [NSString stringWithFormat:@"%ld", shareBatchId],
                                       @"type"          : @"1", // 0 列表 1 详情
                                       @"userType"      : @"0", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectshareBook"
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
                        completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : [NSString stringWithFormat:@"%ld", page],
                                       @"length"        : [NSString stringWithFormat:@"%ld", length],
                                       @"sort"          : [NSString stringWithFormat:@"%ld", sort],
                                       @"classify"      : [NSString stringWithFormat:@"%ld", classify],
                                       @"series"        : series == 0 ? @"" : [NSString stringWithFormat:@"%ld", series],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectOwendGrantBooks"
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
 获取授权列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getImpowerListWithPage:(NSInteger)page
                        length:(NSInteger)length
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : [NSString stringWithFormat:@"%ld", page],
                                       @"length"        : [NSString stringWithFormat:@"%ld", length],
                                       @"shareBatchId"  : @"",
                                       @"type"          : @"0", // 0 列表 1 详情
                                       @"userType"      : @"0", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectGrantBooks"
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
 获取授权详情
 
 @param grantBatchId 推荐 id
 @param completion   回调
 */
- (void)getImpowerDetailWithGrantBatchId:(NSInteger)grantBatchId
                              completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : @"0",
                                       @"length"        : @"0",
                                       @"grantBatchId"  : [NSString stringWithFormat:@"%ld", grantBatchId],
                                       @"type"          : @"1", // 0 列表 1 详情
                                       @"userType"      : @"0", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectGrantBooks"
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
 教师推荐图书给学生
 
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
                          completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"shareTitle": shareTitle,
                                       @"bookId"    : bookIds,
                                       @"studentId" : studentIds,
                                       @"type"      : [NSString stringWithFormat:@"%ld", type],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/shareBook"
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
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"    : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"content"   : [content notEmpty] ? content : @"",
                                       @"bookId"    : bookIds,
                                       @"studentId" : studentIds,
                                       @"startTime" : startTime,
                                       @"endTime"   : endTime,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/grantBooks"
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
 取消授权
 
 @param grantBatchId 授权 id
 @param type         类型
 @param completion   回调
 */
- (void)cancelImpowerWithGrantBatchId:(NSInteger)grantBatchId
                                 type:(NSInteger)type
                           completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"grantBatchId"  : [NSString stringWithFormat:@"%ld", grantBatchId],
                                       @"type"          : [NSString stringWithFormat:@"%ld", type],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/removeGrantBooks"
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
 验证选中的图书的授权时间
 
 @param ownIds 图书在拥有书籍表中ids "1,2,3"
 @param completion 回调
 */
- (void)verifyImpowerBookTimeRangeWithOwnIds:(NSString *)ownIds
                                  completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId" : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"ownIds" : ownIds
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/isLegalToPower"
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
