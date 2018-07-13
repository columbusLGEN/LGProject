//
//  HPAlbumHeaderCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAlbumHeaderCell.h"
#import "DJDataBaseModel.h"

@interface HPAlbumHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *sotrAcce;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;


@end

@implementation HPAlbumHeaderCell

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    _text.text = model.classdescription;

}

- (IBAction)timeSort:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        _sotrAcce.transform = CGAffineTransformIdentity;
    }else{
        sender.selected = YES;
        _sotrAcce.transform = CGAffineTransformMakeRotation(M_PI);
    }
    if ([self.delegate respondsToSelector:@selector(albumListHeaderTimeSort)]) {
        [self.delegate albumListHeaderTimeSort];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _imgHeightConstraint.constant = homeImageLoopHeight * rateForMicroLessonCellHeight();
}

- (CGFloat)headerHeight{
    CGFloat textHeight = [_model.classdescription sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:17]].height;
    return homeImageLoopHeight * rateForMicroLessonCellHeight() + 19 * 2 + textHeight + 8 + 44;
}

@end
