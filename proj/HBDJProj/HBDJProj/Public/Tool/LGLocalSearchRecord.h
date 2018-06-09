//
//  LGLocalSearchRecord.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SearchRecordExePart) {
    SearchRecordExePartHome,
    SearchRecordExePartDiscovery,
    
};

@interface LGLocalSearchRecord : NSObject


/**
 获取当前用户 当前模块用户的搜索记录

 @param userid 当前用户id
 @param part 当前操作模块
 @return 目标数组(元素为字符串)
 */
+ (NSArray *)getLocalRecordWithUserid:(NSString *)userid part:(SearchRecordExePart)part;
/**
 添加新的历史记录（向本地文件中）
 
 @param content 用户输入的内容
 @param part 当前模块，首页：home
 */
+ (void)addNewRecordWithContent:(NSString *)content part:(SearchRecordExePart)part userid:(NSString *)userid;
+ (instancetype)sharedInstance;
@end
