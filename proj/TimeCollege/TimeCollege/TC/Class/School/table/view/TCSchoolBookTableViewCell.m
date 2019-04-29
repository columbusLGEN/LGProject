//
//  TCSchoolBookTableViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSchoolBookTableViewCell.h"

@interface TCSchoolBookTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *puhlish;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIView *starView;

@end

@implementation TCSchoolBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.puhlish.textColor = UIColor.YBColor_6A6A6A;
    self.info.textColor = UIColor.YBColor_6A6A6A;
    
    self.bookName.font = [UIFont systemFontOfSize:18];
    self.puhlish.font = [UIFont systemFontOfSize:14];
    self.info.font = [UIFont systemFontOfSize:14];
    
}


@end
