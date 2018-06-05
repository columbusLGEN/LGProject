//
//  HPAlbumHeaderCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAlbumHeaderCell.h"

@interface HPAlbumHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;


@end

@implementation HPAlbumHeaderCell

- (IBAction)timeSort:(id)sender {
    
}

- (void)setModel:(EDJMicroPartyLessionSubModel *)model{
    _model = model;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
