//
//  DJThemeMeetingsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 备注!!：此类不能继承basemodel，也不能改变分割线上面属性的顺序
#import <Foundation/Foundation.h>

@class DJOnlineUploadTableModel;

@interface DJThemeMeetingsModel : NSObject

/** 会议标签 */
@property (strong,nonatomic) NSString *sessiontype;
/** 主题 */
@property (strong,nonatomic) NSString *title;
/** 时间,列表展示，精确到日 */
@property (strong,nonatomic) NSString *date;
/** 地点 */
@property (strong,nonatomic) NSString *address;
/** 主持人 */
@property (strong,nonatomic) NSString *organizer;
/** 到会人 */
@property (strong,nonatomic) NSString *attendusers;
/** 缺席人 */
@property (strong,nonatomic) NSString *absentusers;
/** 内容 */
@property (strong,nonatomic) NSString *introduction;
/** 图片链接 */
@property (strong,nonatomic) NSString *fileurl;

/// ------------------------------------------
@property (strong,nonatomic) NSString *cover;
/** 上传者 */
@property (strong,nonatomic) NSString *uploader;
@property (strong,nonatomic) NSString *creatorid;
@property (strong,nonatomic) NSString *createdtime;
@property (strong,nonatomic) NSString *issent;
@property (strong,nonatomic) NSString *mechanismid;
/**
 1: 党支部委员会，支部党员大会，党小组会， 党课
 2: 思想汇报，述职述廉
 3: 主题党日
 */
@property (assign,nonatomic) NSInteger searchtype;
@property (strong,nonatomic) NSString *content;
@property (assign,nonatomic) NSInteger seqid;

/**
 将服务器返回的单个数据转换成表单
 0: 主题党日，1: 三会一课
 */
- (NSArray<DJOnlineUploadTableModel *> *)tableModelsWithType:(NSInteger)type;

//- (void)setPropertyValueWithArray:(NSArray<DJOnlineUploadTableModel *> *)array;

@end
