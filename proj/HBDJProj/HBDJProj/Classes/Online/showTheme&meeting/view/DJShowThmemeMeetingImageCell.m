//
//  DJShowThmemeMeetingImageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJShowThmemeMeetingImageCell.h"
#import "DJOnlineUploadTableModel.h"
#import "HZPhotoGroup.h"

#import "LGNineImgView.h"

@interface DJShowThmemeMeetingImageCell ()
@property (nonatomic,strong) HZPhotoGroup *groupView;


@end

@implementation DJShowThmemeMeetingImageCell

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    
    self.groupView.urlArray = [model.content componentsSeparatedByString:@","];
    CGFloat nineImageViewHeight = niImgWidth;
    
    if (self.groupView.urlArray.count < 4) {
    }else if (self.groupView.urlArray.count < 7){
        nineImageViewHeight += (niImgWidth + niMargin);
    }else{
        nineImageViewHeight += (niImgWidth + niMargin) * 2;
    }
    
    if (kScreenWidth < 375) {
        [_groupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.item.mas_bottom).offset(marginFive);
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
            make.height.mas_equalTo(nineImageViewHeight);
        }];
        
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(self.contentView.mas_top).offset(marginEight);
        }];
        
    }else{
        [_groupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.item.mas_right).offset(marginEight);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
            make.height.mas_equalTo(nineImageViewHeight);
        }];
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(_groupView.mas_top);
        }];
    }
    
    
    
    
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
