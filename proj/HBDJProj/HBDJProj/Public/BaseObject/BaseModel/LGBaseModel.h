//
//  LIGBaseModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGBaseModel : NSObject

/** 绝大多数数据的主键 */
@property (assign,nonatomic) NSInteger seqid;
/** cover */
@property (strong,nonatomic) NSString *cover;
/** sort */
@property (assign,nonatomic) NSInteger sort;

+ (NSArray *)arrayWithResponseObject:(id)object;
+ (instancetype)modelWithResponseObject:(id)object;
+ (NSArray *)loadLocalPlist;
+ (NSArray *)loadLocalPlistWithPlistName:(NSString *)plistName;

/** 用户头像 */
@property (strong,nonatomic) NSString *headpic;
@property (strong,nonatomic) NSString *timestamp;
@property (strong,nonatomic) NSString *createdtime;

@end
