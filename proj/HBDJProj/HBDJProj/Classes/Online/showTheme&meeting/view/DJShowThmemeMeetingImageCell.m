//
//  DJShowThmemeMeetingImageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJShowThmemeMeetingImageCell.h"
#import "DJOnlineUploadTableModel.h"
#import "LGNineImgView.h"

@implementation DJShowThmemeMeetingImageCell

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    
    CGFloat nineImageViewHeight = niImgWidth;

    LGNineImgView *nine = LGNineImgView.new;
    [self.contentView addSubview:nine];
    nine.dataSource = [model.content componentsSeparatedByString:@","];
    
    if (nine.dataSource.count < 4) {
    }else if (nine.dataSource.count < 7){
        nineImageViewHeight += (niImgWidth + niMargin);
    }else{
        nineImageViewHeight += (niImgWidth + niMargin) * 2;
    }
    
    [nine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        make.left.equalTo(self.item.mas_right).offset(marginEight);
        make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
        make.height.mas_equalTo(nineImageViewHeight);
    }];
    
    [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(marginTen);
        make.top.equalTo(nine.mas_top);
    }];
    
    /// 九宫格点击回调
    nine.tapBlock = ^(NSInteger index, NSArray *dataSource) {
        NSLog(@"idnex -- %ld",index);
    };
}


@end
