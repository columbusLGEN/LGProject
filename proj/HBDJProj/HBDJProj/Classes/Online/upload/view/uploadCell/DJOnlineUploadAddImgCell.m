//
//  DJOnlineUplaodAddImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUploadAddImgCell.h"
#import "DJOnlineUploadTableModel.h"

#import "LGSelectImgManager.h"

@interface DJOnlineUploadAddImgCell ()

@end

@implementation DJOnlineUploadAddImgCell

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        }];
        
        HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectZero manager:[LGSelectImgManager sharedInstance].hxPhotoManager];
        photoView.backgroundColor = [UIColor redColor];
        photoView.delegate = [LGSelectImgManager sharedInstance];
        photoView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:photoView];
        
        [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginTen);
            make.top.equalTo(self.item.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.height.mas_equalTo(280);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
        }];
        
    }
    return self;
}



@end
