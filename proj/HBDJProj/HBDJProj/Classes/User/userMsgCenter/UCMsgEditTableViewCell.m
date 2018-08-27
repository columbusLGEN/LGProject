//
//  UCMsgEditTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMsgEditTableViewCell.h"
#import "UCMsgModel.h"

@interface UCMsgEditTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *seBtn;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyRead;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comtent;


@end

@implementation UCMsgEditTableViewCell

- (void)setModel:(UCMsgModel *)model{
    [super setModel:model];
    _comtent.text = model.content;
    _seBtn.selected = model.select;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _seBtn.userInteractionEnabled = NO;
}



@end
