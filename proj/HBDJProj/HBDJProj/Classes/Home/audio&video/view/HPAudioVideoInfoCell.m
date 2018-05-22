//
//  HPAudioVideoInfoCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAudioVideoInfoCell.h"

@interface HPAudioVideoInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *playTimes;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UIButton *open;


@end

@implementation HPAudioVideoInfoCell


- (IBAction)open:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        _content.numberOfLines = 3;
    }else{
        sender.selected = YES;
        _content.numberOfLines = 0;
    }
    if ([self.delegate respondsToSelector:@selector(avInfoCellOpen:isOpen:)]) {
        [self.delegate avInfoCellOpen:self isOpen:sender.isSelected];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
