//
//  EDJMicroPartyLessonSubCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessonSubCell.h"
#import "DJDataBaseModel.h"

@interface EDJMicroPartyLessonSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation EDJMicroPartyLessonSubCell
- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    _title.text = model.title;
    _time.text = model.createdDate;
    _peopleCount.text = [NSString stringWithFormat:@"%ld",model.playcount];
    
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
