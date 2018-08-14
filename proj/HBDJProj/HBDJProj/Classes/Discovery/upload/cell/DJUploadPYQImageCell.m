//
//  DJUploadPYQImageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadPYQImageCell.h"
#import <HXWeiboPhotoPicker/HXPhotoView.h>

@implementation DJUploadPYQImageCell

- (void)setPhotoView:(HXPhotoView *)photoView{
    _photoView = photoView;
    [self.contentView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        make.left.equalTo(self.colorLump.mas_left);
        if ([LGDevice isiPad]) {
            make.width.mas_equalTo(280);
        }else{
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
        }
        make.height.mas_equalTo(300);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.colorLump.hidden = YES;
        self.title.hidden = YES;
    }
    return self;
}

@end
