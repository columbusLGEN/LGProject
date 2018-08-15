//
//  UCQuestionModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface UCQuestionModel : LGBaseModel

/** 问题 */
@property (strong,nonatomic) NSString *question;
/** 答案 */
@property (strong,nonatomic) NSString *answer;
/** 点赞次数 */
@property (assign,nonatomic) NSInteger praisecount;
/** 点赞id */
@property (assign,nonatomic) NSInteger praiseid;
/** 收藏数 */
@property (assign,nonatomic) NSInteger collectioncount;
/** 收藏id */
@property (assign,nonatomic) NSInteger collectionid;
/** 标签 */
@property (strong,nonatomic) NSString *label;

@property (strong,nonatomic) NSString *createdtime;
@property (assign,nonatomic) NSInteger creatorid;
/** ??? */
@property (assign,nonatomic) NSInteger auditstate;

//"sort":0,
//"userid":"4", -- > 貌似这里
//"status":1
@property (assign,nonatomic) BOOL showAll;

@end
