//
//  StudentModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface StudentModel : BaseModel

/* 学生 */

/* 班级id */
@property (assign, nonatomic) NSInteger classId;
/* 学生id */
@property (assign, nonatomic) NSInteger studentId;
/* 学生名称 */
@property (strong, nonatomic) NSString *name;
/* 年龄 */
@property (assign, nonatomic) NSInteger age;
/* 学生账户 */
@property (strong, nonatomic) NSString *user;
/* 密码 */
@property (strong, nonatomic) NSString *password;
/* 性别 */
@property (assign, nonatomic) NSInteger sex;

@end
