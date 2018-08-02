//
//  HPAudioVideoInfoCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAudioVideoInfoCell.h"
#import "DJDataBaseModel.h"

@interface HPAudioVideoInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *playTimes;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UIButton *open;


@end

@implementation HPAudioVideoInfoCell

- (CGFloat)cellHeight{
    if (!(_model.lessonInfoCellShowAll)) {
        
        return 240;
    }else{
        CGFloat textHeight = [self.model.contentvalidity sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height;
        
        return textHeight + 144 + 50;
    }
}

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    [_title setText:model.title];
    [_content setText:model.contentvalidity];
    [_playTimes setText:[NSString stringWithFormat:@"%ld次查看",model.playcount]];
    [_time setText:[model.createdDate stringByAppendingString:@" 更新"]];
    [_source setText:[NSString stringWithFormat:@"来源: %@",model.source]];
    
}

- (IBAction)open:(UIButton *)sender {
    if (_model.lessonInfoCellShowAll) {
        _model.lessonInfoCellShowAll = NO;
        _content.numberOfLines = 3;
        sender.selected = NO;
    }else{
        _model.lessonInfoCellShowAll = YES;
        _content.numberOfLines = 0;
        sender.selected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(avInfoCellOpen:isOpen:)]) {
        [self.delegate avInfoCellOpen:self isOpen:_model.lessonInfoCellShowAll];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
