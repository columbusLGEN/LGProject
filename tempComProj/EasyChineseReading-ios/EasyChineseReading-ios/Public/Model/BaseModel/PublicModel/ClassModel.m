//
//  ClassModel.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

- (id)copyWithZone:(NSZone *)zone
{
    ClassModel *classInfo = [[ClassModel allocWithZone:zone] init];
    
    classInfo.classId = self.classId;
    classInfo.teacherId = self.teacherId;
    classInfo.studentNum = self.studentNum;
    classInfo.className = self.className;
    classInfo.synopsis = self.synopsis;
    classInfo.iconUrl = self.iconUrl;
    classInfo.teacherName = self.teacherName;
    classInfo.students = self.students;
    
    return classInfo;
}

@end
