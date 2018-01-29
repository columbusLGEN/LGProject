//
//  ECRThematicModel.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRThematicModel.h"

@implementation ECRThematicModel

- (NSString *)thematicName{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        return _en_thematicName;
    }else{
        return _thematicName;
    }
}

@end
