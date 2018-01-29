//
//  ECRBookInfoModel.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBookInfoModel.h"

@implementation ECRBookInfoModel
@synthesize publicationTime = _publicationTime;

- (NSString *)publicationTime{
    NSString *cutString;
    if (_publicationTime != nil) {
        // 2017-09-27 00:00:00
        // cutString = 2017-09
        // substringToIndex 截取时，不包含 index
        cutString = [_publicationTime substringToIndex:7];
    }
    return cutString;
}

//- (NSString *)downloadURL{
//    if (self.) {
//        <#statements#>
//    }
//}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"classifyBook":@"ECRClassfyBookModel",
             @"recommend":@"ECRRecoBook",
             @"scores":@"ECRScoreUserModel"
             };
}

@end
