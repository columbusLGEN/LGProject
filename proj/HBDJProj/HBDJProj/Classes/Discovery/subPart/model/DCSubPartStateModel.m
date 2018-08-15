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

//- (CGFloat)cellHeight{
//    CGFloat defaultHeight = 96 + 40;
//    switch (self.imgCount) {
//        case 0:
//            return defaultHeight;
//            break;
//        case 1:
//            return 144;
//            break;
//        case 3:
//            return 201 + 40;
//            break;
//        default:
//            return defaultHeight;
//            break;
//    }
//}

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
