//
//  EDJMicroPartyLessionSonModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// MARK: 党建 单条数据模型，微党课、要闻等
#import "LGBaseModel.h"

/** 微党课、要闻、数据模板类型 */
typedef NS_ENUM(NSUInteger, ModelMediaType) {
    /** 音频 */
    ModelMediaTypeAudio,
    /** 视频 */
    ModelMediaTypeVideo,
    /** 图文 */
    ModelMediaTypeRichText,
    /** 自由 */
    ModelMediaTypeCustom
};

/** 现有的classid */
typedef NS_ENUM(NSUInteger, BaseClassesId) {
    /** 习近平要闻列表 */
    BaseClassesIdXJPPointNews           = 1,
    /** 党建要闻 */
    BaseClassesIdBuildPointNews         = 2,
    /** 微党课 */
    BaseClassesIdMicroLessons           = 3,
    /** 习近平讲话原声解读 */
    BaseClassesIdXJPOriginalVoice       = 4,
    /** 党务工作大讲堂 */
    BaseClassesIdPartyThingsBigLesson   = 5,
    /** 党史故事100讲 */
    BaseClassesIdPartyHistoryStory      = 6,
    /** 十九大解读 */
    BaseClassesIdNinteenBigReport       = 7
    
};

@interface DJDataBaseModel : LGBaseModel

@property (strong,nonatomic) NSNumber *peopleCount;
@property (strong,nonatomic) NSNumber *time;
@property (copy,nonatomic) NSString *imgUrl;

/** 专辑id */
@property (assign,nonatomic) NSInteger classid;
/** audio */
@property (strong,nonatomic) NSString *audio;
/** vedio */
@property (strong,nonatomic) NSString *vedio;
/** status */
@property (assign,nonatomic) NSInteger status;
/** resourcestate */
@property (strong,nonatomic) NSString *resourcestate;
/** label */
@property (strong,nonatomic) NSString *label;
/** playcount */
@property (assign,nonatomic) NSInteger playcount;
/** 富文本字符串 */
@property (strong,nonatomic) NSString *content;
/** title */
@property (strong,nonatomic) NSString *title;
/** creatorid */
@property (assign,nonatomic) NSInteger creatorid;
/** source */
@property (strong,nonatomic) NSString *source;
/** createdtime */
@property (strong,nonatomic) NSString *createdtime;
/** praisecount */
@property (assign,nonatomic) NSInteger praisecount;
/** collectioncount */
@property (assign,nonatomic) NSInteger collectioncount;
/** 模板类型：1音频模板，2视频模板，3图文模板，4自由模板（包含音频、视频、图文） */
@property (assign,nonatomic) ModelMediaType modaltype;
/** contentvalidity */
@property (strong,nonatomic) NSString *contentvalidity;


/** parentclassid */
@property (strong,nonatomic) NSString *parentclassid;
/** classname */
@property (strong,nonatomic) NSString *classname;
/** classdescription */
@property (strong,nonatomic) NSString *classdescription;

/** 收藏id，0表示未收藏 */
@property (assign,nonatomic) NSInteger collectionid;
/** 点赞id，0表示未点赞 */
@property (assign,nonatomic) NSInteger praiseid;
/** 分享缩略图 */
@property (strong,nonatomic) NSString *thumbnail;

@end
