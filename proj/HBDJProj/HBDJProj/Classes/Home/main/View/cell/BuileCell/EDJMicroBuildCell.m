//
//  EDJMicroBuildCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"

@implementation EDJMicroBuildCell

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(EDJMicroBuildModel *)model{
    return [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierWithModel:model]];
}

+ (NSString *)cellIdentifierWithModel:(EDJMicroBuildModel *)model{
    if (model.imgs.count == 0) {/// 没有图
        return @"EDJMicroBuildNoImgCell";
    }else if (model.imgs.count == 1){/// 有一张图
        return @"EDJMicroBuildOneImgCell";
    }else if (model.imgs.count == 3){/// 有三张图
        return @"EDJMicroBuildThreeImgCell";
    }
    return @"EDJMicroBuildNoImgCell";/// 默认返回无图,防止崩溃
}

+ (CGFloat)cellHeightWithModel:(EDJMicroBuildModel *)model{
    return 100;
}

@end
