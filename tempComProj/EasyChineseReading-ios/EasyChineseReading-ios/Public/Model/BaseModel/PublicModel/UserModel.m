//
//  UserInfoModel.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)copyWithZone:(NSZone *)zone
{
    UserModel *user = [[UserModel allocWithZone:zone] init];

    user.userId = self.userId;
    user.userType = self.userType;
    user.name = self.name;
    user.iconUrl = self.iconUrl;
    user.address = self.address;
    user.sex = self.sex;
    user.motherTongue = self.motherTongue;
    user.country = self.country;
    user.learnYears = self.learnYears;
    user.school = self.school;
    user.interest = self.interest;
    user.birthday = self.birthday;
    user.age = self.age;
    user.phone = self.phone;
    user.email = self.email;
    user.skin = self.skin;
    user.organizationId = self.organizationId;
    user.score = self.score;
    user.virtualCurrency = self.virtualCurrency;
    user.readHistoryId = self.readHistoryId;
    user.sameDayWord = self.sameDayWord;
    user.readTime = self.readTime;
    user.wordCount = self.wordCount;
    user.averageWordCount = self.averageWordCount;
    user.ranking = self.ranking;
    user.readHave = self.readHave;
    user.readThrough = self.readThrough;
    user.canview = self.canview;
    user.allbooks = self.allbooks;
    user.studentNum = self.studentNum;
    user.schoolType = self.schoolType;
    user.remark = self.remark;
    user.classId = self.classId;
    user.message = self.message;
    user.unionid = self.unionid;
    user.areacode = self.areacode;
    user.isSelected = self.isSelected;
    user.giveVirtualCurrency = self.giveVirtualCurrency;
    user.messageTime = self.messageTime;
    user.endtime = self.endtime;
    user.countryName = self.countryName;
    
    return user;
}

- (void)setVirtualCurrency:(CGFloat)virtualCurrency
{
    _virtualCurrency = virtualCurrency + 0.001;// 取小数点后两位, 加.001 防止四舍五入, 数据错乱
}

// 防崩溃。。简直日了
- (ENUM_SexType)sex {
    if (_sex > 1) {
        _sex = ENUM_SexTypeMan;
    }
    return _sex;
}

- (NSInteger)motherTongue{
    if (_motherTongue > 1) {
        _motherTongue = 1;
    }
    return _motherTongue;
}

@end
