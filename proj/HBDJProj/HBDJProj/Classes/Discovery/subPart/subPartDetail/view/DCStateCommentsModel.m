//
//  DCStateCommentsModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCStateCommentsModel.h"
#import "NSString+Extension.h"

@implementation DCStateCommentsModel

- (CGFloat)cellHeight{
    return [self.content sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 82, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height + 71;
}

@end
