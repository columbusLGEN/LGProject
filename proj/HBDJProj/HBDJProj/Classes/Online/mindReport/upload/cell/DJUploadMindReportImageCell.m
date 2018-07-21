//
//  DJUploadMindReportImageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadMindReportImageCell.h"
#import "DJUploadMindReportLineModel.h"
#import <HXWeiboPhotoPicker/HXPhotoView.h>

@implementation DJUploadMindReportImageCell

- (void)setPhotoView:(HXPhotoView *)photoView{
    _photoView = photoView;
    [self.contentView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(marginTen);
        make.top.equalTo(self.title.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
        make.height.mas_equalTo(280);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
    }];
    
}

- (void)setModel:(DJUploadMindReportLineModel *)model{
    [super setModel:model];
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.colorLump mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.contentView.mas_left).offset(marginTwelve);
            make.height.mas_equalTo(marginFifteen);
            make.width.mas_equalTo(3);
        }];
    }
    return self;
}

@end
