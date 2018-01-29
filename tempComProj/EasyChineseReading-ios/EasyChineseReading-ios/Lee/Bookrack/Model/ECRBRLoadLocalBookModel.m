//
//  ECRBRLoadLocalBookModel.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBRLoadLocalBookModel.h"

@implementation ECRBRLoadLocalBookModel

- (NSString *)cellInfo{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_cellInfo;
    }else{
        return _cellInfo;
    }
}
- (NSString *)cellTitle{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_cellTitle;
    }else{
        return _cellTitle;
    }
}
- (NSString *)cellImageName{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_cellImageName;
    }else{
        return _cellImageName;
    }
}

+ (NSArray *)modelArray{
    NSMutableArray *arrm = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BookrackLoadLocalBook" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    NSLog(@"array -- %@",array);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ECRBRLoadLocalBookModel *model = [ECRBRLoadLocalBookModel mj_objectWithKeyValues:obj];
        [arrm addObject:model];
    }];
    return arrm.copy;
}

@end
