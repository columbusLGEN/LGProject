//
//  TCBookInfoRecoCollectionViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/28.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookInfoRecoCollectionViewCell.h"

@interface TCBookInfoRecoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *bookname;


@end

@implementation TCBookInfoRecoCollectionViewCell

- (void)setModel:(id)model{
    
//    self.cover
//    self.bookname.text
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bookname.textColor = UIColor.YBColor_6A6A6A;
    
}

@end
