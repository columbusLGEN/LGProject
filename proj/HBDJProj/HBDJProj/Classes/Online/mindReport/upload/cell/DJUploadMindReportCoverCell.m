//
//  DJUploadMindReportCoverCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadMindReportCoverCell.h"
#import "DJUploadMindReportLineModel.h"

@interface DJUploadMindReportCoverCell ()
@property (weak,nonatomic) UIButton *imageButton;

@end

@implementation DJUploadMindReportCoverCell

- (void)selectImageClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addCoverClick:)]) {
        [self.delegate addCoverClick:self];
    }
}

- (void)setModel:(DJUploadMindReportLineModel *)model{
    [super setModel:model];
    if (model.coverBackUrl) {
        [_imageButton setImage:[UIImage imageWithContentsOfFile:model.coverBackUrl.relativePath] forState:UIControlStateNormal];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.colorLump mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.contentView.mas_left).offset(marginTwelve);
            make.height.mas_equalTo(marginFifteen);
            make.width.mas_equalTo(3);
        }];
        
        UIButton *button = UIButton.new;
        _imageButton = button;
        [self.contentView addSubview:_imageButton];
        
        [_imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(marginTen);
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.width.mas_equalTo(133);
            make.height.mas_equalTo(133 * 9 / 16);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginEight);
        }];
        
        _imageButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [[_imageButton imageView] setContentMode:UIViewContentModeScaleToFill];
        _imageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        _imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        [_imageButton setImage:[UIImage imageNamed:@"uc_icon_upload_add"] forState:UIControlStateNormal];
        
        [_imageButton addTarget:self action:@selector(selectImageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
