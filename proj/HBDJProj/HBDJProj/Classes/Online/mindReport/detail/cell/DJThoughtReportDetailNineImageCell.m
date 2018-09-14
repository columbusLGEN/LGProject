//
//  DJThoughtReportDetailNineImageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoughtReportDetailNineImageCell.h"
#import "DJThoughtReportDetailModel.h"
#import "HZPhotoGroup.h"

#import "LGNineImgView.h"

@interface DJThoughtReportDetailNineImageCell ()
@property (nonatomic,strong) HZPhotoGroup *groupView;

@end

@implementation DJThoughtReportDetailNineImageCell

- (void)setModel:(DJThoughtReportDetailModel *)model{
    [super setModel:model];
    
    CGFloat nineImageViewHeight = niImgWidth;
    
    if ([model.fileurl isEqualToString:@""] || model.fileurl == nil) {
        return;
    }
    
    NSArray *dataSource = [model.fileurl componentsSeparatedByString:@","];
    
    self.groupView.urlArray = dataSource;
    
    if (dataSource.count < 4) {
    }else if (dataSource.count < 7){ 
        nineImageViewHeight += (niImgWidth + niMargin);
    }else{
        nineImageViewHeight += (niImgWidth + niMargin) * 2;
    }
    [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        make.left.equalTo(self.contentView.mas_left).offset(marginTwenty);
        make.right.equalTo(self.contentView.mas_right).offset(-marginTwenty);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
        make.height.mas_equalTo(nineImageViewHeight);
    }];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.groupView];
    }
    return self;
}

- (HZPhotoGroup *)groupView{
    if (!_groupView) {
        _groupView = [[HZPhotoGroup alloc] init];
    }
    return _groupView;
}


@end
