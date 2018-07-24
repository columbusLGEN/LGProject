//
//  DJThoughtReportDetailNineImageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoughtReportDetailNineImageCell.h"
#import "DJThoughtReportDetailModel.h"
#import "LGNineImgView.h"

@interface DJThoughtReportDetailNineImageCell ()


@end

@implementation DJThoughtReportDetailNineImageCell

- (void)setModel:(DJThoughtReportDetailModel *)model{
    [super setModel:model];
    
    CGFloat nineImageViewHeight = niImgWidth;
    
    /// 九宫格展示图片
    LGNineImgView *nine = LGNineImgView.new;
    [self.contentView addSubview:nine];
    nine.dataSource = [model.fileurl componentsSeparatedByString:@","];
    
    if (nine.dataSource.count < 4) {
    }else if (nine.dataSource.count < 7){
        nineImageViewHeight += (niImgWidth + niMargin);
    }else{
        nineImageViewHeight += (niImgWidth + niMargin) * 2;
    }
    
    [nine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        make.left.equalTo(self.contentView.mas_left).offset(30);
//        make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
        make.height.mas_equalTo(nineImageViewHeight);
    }];
    
    /// 九宫格点击回调
    nine.tapBlock = ^(NSInteger index, NSArray *dataSource) {
        NSLog(@"idnex -- %ld",(long)index);
    };
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
