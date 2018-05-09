//
//  UCUploadCollectionCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadCollectionCell.h"
#import "UCUploadModel.h"

@interface UCUploadCollectionCell ()
@property (weak,nonatomic) UIImageView *img;
@property (weak,nonatomic) UIButton *addImg;

@end

@implementation UCUploadCollectionCell

- (void)setModel:(UCUploadModel *)model{
    _model = model;
    if (model.additional) {
        [_img setImage:[UIImage imageNamed:@"uc_icon_upload_add"]];
    }

}

- (void)setupUI{
    UIImageView *img = [UIImageView new];
    _img = img;
    img.clipsToBounds = YES;
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image = [UIImage imageNamed:testImg];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(marginTen);
        make.left.equalTo(self.mas_left).offset(marginTen);
        make.right.equalTo(self.mas_right).offset(-marginTen);
        make.bottom.equalTo(self.mas_bottom).offset(-marginTen);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


@end
