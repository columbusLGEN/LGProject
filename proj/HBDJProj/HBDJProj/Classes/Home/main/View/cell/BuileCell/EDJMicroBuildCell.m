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
//    NSLog(@"model.cover -- %@",model.cover);
    if ([model.cover isEqualToString:@""] || model.cover == nil) {
        /// 没有图
        return @"EDJMicroBuildNoImgCell";
    }
    if (model.imgs.count == 0) {
        return @"EDJMicroBuildNoImgCell";
    }else if (model.imgs.count == 1){/// 有一张图
        return @"EDJMicroBuildOneImgCell";
    }else if (model.imgs.count == 3){/// 有三张图
        return @"EDJMicroBuildThreeImgCell";
    }
    return @"EDJMicroBuildNoImgCell";/// 默认返回无图,防止崩溃
}

+ (CGFloat)cellHeightWithModel:(EDJMicroBuildModel *)model{
    CGFloat rate = rateForMicroLessonCellHeight();
    CGFloat height;
    if (model.imgs.count == 0) {/// 没有图
        height = 85;
    }else if (model.imgs.count == 1){/// 有一张图
        height = 90;
    }else{/// 有三张图
        height = 140;
    }
    return height * rate;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginTen);
        make.right.equalTo(self.mas_right).offset(-marginTen);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

@end
