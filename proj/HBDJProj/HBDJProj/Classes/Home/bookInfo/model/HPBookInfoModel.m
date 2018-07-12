//
//  HPBookInfoModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoModel.h"

@implementation HPBookInfoModel

- (CGFloat)cellHeight{
    if (_isHeader) {
        return (233 * kScreenHeight) / plusScreenHeight;
    }
    if (_showAll) {
        CGSize size = [self.content sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 36, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
        return 100 + size.height + 8;
    }else{
        return 140;
    }
}

@end
