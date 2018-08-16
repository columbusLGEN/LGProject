//
//  DCSubPartStateModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateModel.h"

@implementation DCSubPartStateModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"frontComments":@"DCSubPartStateCommentModel"};
}

- (NSInteger)imgCount{
    if ([self.cover isEqualToString:@""] || self.cover == nil) {
        return 0;
    }
    return self.imgUrls.count;
}
- (NSArray *)imgUrls{
    return [self.cover componentsSeparatedByString:@","];
}

@end
