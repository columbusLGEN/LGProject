//
//  UCMsgTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMsgTableViewCell.h"
#import "UCMsgModel.h"

@interface UCMsgTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyReadIcon;


@end

@implementation UCMsgTableViewCell

+ (NSString *)cellReuseIdWithModel:(UCMsgModel *)model{
    if (model.isEdit) {
        return msgEditCell;
    }else{
        return msgCell;
    }
}

- (void)setModel:(UCMsgModel *)model{
    _model = model;
    _content.text = model.content;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


@end
