//
//  DCSubPartStateCommentModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/15.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface DCSubPartStateCommentModel : LGBaseModel

@property (strong,nonatomic) NSString *commentid;
/** ??? */
@property (assign,nonatomic) NSInteger commenttype;
/** 评论内容 */
@property (strong,nonatomic) NSString *comment;
/** ??? */
@property (assign,nonatomic) NSInteger userid;
/** 2018-05-31 10:55:01 */
@property (strong,nonatomic) NSString *createdtime;
/** ??? */
@property (strong,nonatomic) NSString *username;
- (CGFloat)cellHeight;

@end
