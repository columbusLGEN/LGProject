//
//  TCBookDiscussTableViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDiscussTableViewCell.h"

@interface TCBookDiscussTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *iconCon;
@property (weak, nonatomic) IBOutlet UIImageView *iconAva;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *disContent;
@property (weak, nonatomic) IBOutlet UILabel *disTime;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation TCBookDiscussTableViewCell

- (void)setModel:(id)model{
    _model = model;
    [self.iconAva sd_setImageWithURL:[NSURL URLWithString:@"http://img3.duitang.com/uploads/item/201503/23/20150323195819_N3TxS.thumb.700_0.jpeg"] placeholderImage:TCPlaceHolderImage];
    
    self.nick.text = @"奇遇";
    self.disContent.text = @"考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我考试网我我我我";
//    self.disTime;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconCon.backgroundColor = UIColor.whiteColor;
    [self.iconCon cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:25];
    [self.iconCon setShadowWithShadowColor:UIColor.YBColor_6A6A6A shadowOffset:CGSizeMake(2, 2) shadowOpacity:0.5 shadowRadius:2];
    [self.iconAva cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:20];
    
    self.nick.textColor = UIColor.blackColor;
    self.nick.font = [UIFont systemFontOfSize:15];
    self.disContent.textColor = UIColor.YBColor_6A6A6A;
    self.disContent.font = [UIFont systemFontOfSize:12];
    self.disTime.textColor = UIColor.blackColor;
    self.disTime.font = [UIFont systemFontOfSize:15];
    
    self.line.backgroundColor = UIColor.YBColor_F3F3F3;
    
}



@end
