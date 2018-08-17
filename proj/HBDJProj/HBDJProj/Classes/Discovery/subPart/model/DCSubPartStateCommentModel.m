//
//  DCSubPartStateCommentModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/15.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateCommentModel.h"

@implementation DCSubPartStateCommentModel

- (CGFloat)cellHeight{
    return [self.comment sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 82, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height + 71;
}

@end
