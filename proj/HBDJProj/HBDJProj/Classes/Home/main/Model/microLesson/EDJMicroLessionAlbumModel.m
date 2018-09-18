//
//  EDJMicroLessionAlbumModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroLessionAlbumModel.h"

@implementation EDJMicroLessionAlbumModel

@synthesize imgUrl = _imgUrl;

- (NSString *)imgUrl{
    if (!_imgUrl) {
//        _imgUrl = [NSURL URLWithString:self.classimg];
        _imgUrl = self.classimg;
    }
    return _imgUrl;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"classlist":@"DJDataBaseModel"};
}

@end
