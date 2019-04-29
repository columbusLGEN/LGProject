//
//  TCMyCollectionViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyCollectionViewCell.h"
#import "TCMyBookrackModel.h"

@implementation TCMyCollectionViewCell

- (void)setModel:(TCMyBookrackModel *)model{
    _model = model;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
//    self.contentView.backgroundColor = UIColor.whiteColor;
    
}

@end
