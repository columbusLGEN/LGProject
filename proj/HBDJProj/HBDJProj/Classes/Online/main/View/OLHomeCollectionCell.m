//
//  OLHomeCollectionCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLHomeCollectionCell.h"
#import "OLHomeModel.h"

@interface OLHomeCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation OLHomeCollectionCell

- (void)setModel:(OLHomeModel *)model{
    _model = model;
    _title.text = model.toolname;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:DJPlaceholderImage];
    if (model.locaImage) {
        _img.image = [UIImage imageNamed:model.locaImage];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];

}

@end
