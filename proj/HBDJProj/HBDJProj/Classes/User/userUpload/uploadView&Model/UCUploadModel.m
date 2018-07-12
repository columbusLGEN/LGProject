//
//  UCUploadModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadModel.h"

@implementation UCUploadModel
- (CGFloat)cellHeight {
    _cellHeight = self.photoViewHeight;
    return _cellHeight;
}
- (CGFloat)photoViewHeight {
    if (_photoViewHeight == 0) {
        _photoViewHeight = (([UIScreen mainScreen].bounds.size.width - 24) - 3 * (3 - 1)) / 3;
    }
    return _photoViewHeight;
}
@end
