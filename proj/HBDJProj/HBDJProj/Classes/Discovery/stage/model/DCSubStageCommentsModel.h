//
//  DCSubStageCommentsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 党建 党员舞台 的评论只能恢复朋友圈，不能恢复其他人的评论

#import "LGBaseModel.h"

@interface DCSubStageCommentsModel : LGBaseModel

/** 评论内容 */
@property (strong,nonatomic) NSString *comment;

/** 此条评论属于的数据的id */
@property (assign,nonatomic) NSInteger commentid;
/**
 1党员舞台
 2支部动态 */
@property (assign,nonatomic) NSInteger commenttype;
/** 发出该条评论的 用户名 */
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *userid;


@end
