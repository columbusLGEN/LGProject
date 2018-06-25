//
//  HPAudioVideoContentCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAudioVideoContentCell.h"
#import "DJDataBaseModel.h"

@interface HPAudioVideoContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *guys;


@end

@implementation HPAudioVideoContentCell

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    _content.text = model.content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
