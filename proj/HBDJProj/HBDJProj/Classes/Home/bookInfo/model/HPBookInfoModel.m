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
        if ([LGDevice isiPad]) {
            return (244 * kScreenHeight) / plusScreenHeight;
        }else{
            return 244;
        }
    }
    if (_showAll) {
        CGSize size = [self.content sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 36, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
        return 75 + size.height + 8;
    }else{
        return 140;
    }
}

@end
