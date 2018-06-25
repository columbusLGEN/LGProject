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


@end

@implementation HPAlbumHeaderCell

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    _text.text = model.classdescription;
//    NSLog(@"专辑列表.cover: %@",model.cover);
//    NSLog(@"专辑列表.info: %@",model.classdescription);
}

- (IBAction)timeSort:(id)sender {
    if ([self.delegate respondsToSelector:@selector(albumListHeaderTimeSort)]) {
        [self.delegate albumListHeaderTimeSort];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
