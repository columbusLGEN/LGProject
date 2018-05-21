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

/** 此条评论发布者 */
@property (strong,nonatomic) NSString *sender;
@property (strong,nonatomic) NSString *content;

@end
