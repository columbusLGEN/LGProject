//
//  HPBookInfoModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoModel.h"
#import "NSString+Extension.h"

@implementation HPBookInfoModel

- (CGFloat)cellHeight{
    if (_showAll) {
        CGSize size = [self.content sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 36, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
        return 100 + size.height + 8;
    }else{
        return 120;
    }
}

@end
