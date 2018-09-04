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
        /**
         0: image -- 头像链接
         1: name
         2: phone
         3: gender
         4: hometown
         5: nation
         6: birthda
         7: degree
         8: jiontime
         9: formaltime
         10: post
         11: partyproperty
         12: developparty
         13: crowdtype
         14: workunit
         */
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
