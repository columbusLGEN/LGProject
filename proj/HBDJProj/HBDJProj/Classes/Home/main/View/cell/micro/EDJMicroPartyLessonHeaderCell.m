//
//  EDJMicroPartyLessonHeaderCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessonHeaderCell.h"
#import "EDJMicroLessionAlbumModel.h"

@interface EDJMicroPartyLessonHeaderCell ()
@property (weak, nonatomic) IBOutlet UIView *titleBgLeft;
@property (weak, nonatomic) IBOutlet UILabel *titleLeft;
@property (weak, nonatomic) IBOutlet UIView *titleBgRight;
@property (weak, nonatomic) IBOutlet UILabel *titleRight;

@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation EDJMicroPartyLessonHeaderCell

- (void)setModel:(EDJMicroLessionAlbumModel *)model{
    _model = model;
    
    _titleLeft.text = model.headerModel1.classname;
    _titleRight.text = model.headerModel2.classname;
    
    [_imgLeft sd_setImageWithURL:[NSURL URLWithString:model.headerModel1.imgUrl] placeholderImage:DJPlaceholderImage];
    [_imgRight sd_setImageWithURL:[NSURL URLWithString:model.headerModel2.imgUrl] placeholderImage:DJPlaceholderImage];
    
}

- (IBAction)leftClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerAlbumClick:index:)]) {
        [self.delegate headerAlbumClick:self index:0];
    }
}
- (IBAction)rightClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerAlbumClick:index:)]) {
        [self.delegate headerAlbumClick:self index:1];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLeft.textColor = [UIColor whiteColor];
    _titleRight.textColor = [UIColor whiteColor];
    
    _titleBgLeft.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _titleBgRight.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _titleBgLeft.hidden = YES;
    _titleBgRight.hidden = YES;
    
    _line.backgroundColor = UIColor.EDJGrayscale_F3;
    
}


@end
