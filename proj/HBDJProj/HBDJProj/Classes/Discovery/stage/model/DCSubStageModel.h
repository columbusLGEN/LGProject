//
//  DCSubStageModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 党员舞台模型

#import "LGBaseModel.h"
@class DCSubStageCommentsModel;

typedef NS_ENUM(NSUInteger, StageModelType) {
    StageModelTypeDefault,/// 只有文字 --> 加载 MoreImg 的cell, imgs.count == 0
    StageModelTypeAudio,/// 音频 --> 按照 单图 横 的情况处理，图片上另外添加一个 播放按钮
    StageModelTypeVideo,/// 视频
    StageModelTypeAImg,/// 一张图 --> DCSubStageOneImgCell
    StageModelTypeMoreImg/// 多图 加载 DCSubStageThreeImgCell
};

typedef NS_ENUM(NSUInteger, StageModelTypeAImgType) {
    StageModelTypeAImgTypeVer,/// 竖图
    StageModelTypeAImgTypeHori,/// 横图
};
/** 单图，竖，高度 */
static const CGFloat aImgVerHeight = 177;
/** 单图，竖，宽度 */
static const CGFloat aImgVerWidth = 114;
/** 单图，横，高度 */
static const CGFloat aImgHoriHeight = 111;
/** 单图，横，宽度 */
static const CGFloat aImgHoriWidth = 177;
/** 评论单元格行高 */
static const CGFloat commentsCellHeight = 25;

@interface DCSubStageModel : LGBaseModel

@property (strong,nonatomic) NSString *nick;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSArray *imgs;

@property (assign,nonatomic) CGFloat nineImgViewHeight;
/** 评论tbv的高度 */
@property (assign,nonatomic) CGFloat commentsTbvHeight;

/** 区分 cell的类型，分为 纯文字，一图，多图，音频，视频 */
@property (assign,nonatomic) StageModelType modelType;
/** 横图，竖图 类型 */
@property (assign,nonatomic) StageModelTypeAImgType aImgType;
/** 是否视频 */
@property (assign,nonatomic) BOOL isVideo;

@property (assign,nonatomic) CGFloat heightForContent;
@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) UIImage *testIcon;
@property (strong,nonatomic) UIImage *aTestImg;

/** 评论数据 */
@property (strong,nonatomic) NSArray<DCSubStageCommentsModel *> *comments;

- (CGFloat)cellHeight;


//    "filetype":0,
//    "frontComments":[
//    
//    ],
//    "creatorid":1,
//    "praisecount":1,
//    "sort":0,
//    "title":"",
//    "auditstate":"1",
//    "mechanismid":"180607092010002",
//    "userid":"长孙无极",
//    "content":"小时候",
//    "createdtime":"2018-01-24 13:54:21",
//    "ugctype":"1",
//    "cover":"",
//    "uploader":"长孙无极",
//    "fileurl":"http://123.59.199.170/group1/M00/00/00/CgoKC1tAi_qAGpx7AV8r1CUcVnM424.mp4",
//    "praiseid":0,
//    "collectioncount":1,
//    "collectionid":0,
//    "seqid":1,
//    "status":1

@end
