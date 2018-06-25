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


@end

@implementation EDJMicroPartyLessonHeaderCell

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

+ (CGFloat)cellHeight{
    return 128;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
