//
//  LIGBaseModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

typedef NS_ENUM(NSUInteger, BaseClassesId) {
    BaseClassesIdXJPPointNews = 1,/// 习近平要闻列表
    BaseClassesIdMicroLessons,/// 微党课
    BaseClassesIdBuildPointNews,/// 党建要闻
    BaseClassesIdDigitals,/// 数字阅读
    BaseClassesIdNinteenBigReport,///十九大报告详解
    BaseClassesIdPartyHistoryStory,///党史故事100讲
    BaseClassesIdPartyThingsBigLesson,///党务工作大讲堂
    BaseClassesIdXJPOriginalVoice///习近平讲话原声解读
};

@interface LGBaseModel : NSObject

/** 绝大多数数据的主键 */
@property (strong,nonatomic) NSString *seqid;
/** cover */
@property (strong,nonatomic) NSString *cover;
/** sort */
@property (assign,nonatomic) NSInteger sort;

+ (NSArray *)arrayWithResponseObject:(id)object;
+ (instancetype)modelWithResponseObject:(id)object;
+ (NSArray *)loadLocalPlist;
+ (NSArray *)loadLocalPlistWithPlistName:(NSString *)plistName;

@end
