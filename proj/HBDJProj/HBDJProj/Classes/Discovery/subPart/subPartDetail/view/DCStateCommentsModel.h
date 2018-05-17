//
//  DCStateCommentsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface DCStateCommentsModel : LGBaseModel
@property (strong,nonatomic) NSString *nick;
@property (strong,nonatomic) NSString *imgUrl;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *content;
- (CGFloat)cellHeight;

@end
