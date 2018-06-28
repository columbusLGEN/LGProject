//
//  UCPersonInfoModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPersonInfoModel.h"
#import "DJUser.h"

@implementation UCPersonInfoModel

+ (NSArray *)userInfoArray{
    
    DJUser *user = [DJUser new];
    [user getLocalUserInfo];
    
    NSArray *propertyNameArray = [user propertyArray];
    
    NSMutableArray *destine = [NSMutableArray arrayWithCapacity:10];
    
    NSArray *modelArray = [self userInfoArrayFotItemTitle];
    
    for (int i = 0; i < 15; i++) {
        UCPersonInfoModel *model = modelArray[i];
        model.content = [user valueForKey:propertyNameArray[i]];
        
        [destine addObject:model];
    }
    
    return destine.copy;
}

+ (NSArray *)userInfoArrayFotItemTitle{
    /// 获取项目名 例如: "头像","姓名"
    return [self loadLocalPlistWithPlistName:@"userInfoConfig"];
}

- (BOOL)canChangePwd{
    if ([_itemName isEqualToString:@"密码"]) {
        _canChangePwd = YES;
    }else{
        _canChangePwd = NO;
    }
    return _canChangePwd;
}

@end
