//
//  ECRClassSortModel.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRClassSortModel.h"

@implementation ECRClassSortModel


- (NSString *)name{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_name;
    }else{
        return _name;
    }
}

- (NSString *)btnTitle{
    return self.name;
}

+ (instancetype)defaultModel{
    ECRClassSortModel *model = [ECRClassSortModel new];
    model.id = 425;// 汉语读物
    model.type = 1;
    model.name = @"汉语读物";
    model.en_name = @"Chinese books";
    return model;
}

@end
