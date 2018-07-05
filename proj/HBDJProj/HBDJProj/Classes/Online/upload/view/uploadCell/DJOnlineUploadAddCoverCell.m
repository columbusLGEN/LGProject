//
//  DJOnlineUploadAddCoverCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUploadAddCoverCell.h"
#import "DJOnlineUploadTableModel.h"

@interface DJOnlineUploadAddCoverCell ()
@property (weak,nonatomic) UIButton *imageButton;

@end

@implementation DJOnlineUploadAddCoverCell

- (void)selectImageClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addCoverClick:)]) {
        [self.delegate addCoverClick:self];
    }
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        }];
        
        UIButton *button = UIButton.new;
        _imageButton = button;
        [self.contentView addSubview:_imageButton];
        
        [_imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginTen);
            make.top.equalTo(self.item.mas_top);
            make.width.mas_equalTo(133);
            make.height.mas_equalTo(133 * 9 / 16);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
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
