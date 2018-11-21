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
    // TODO: Zup_项目经理要求文本高度不超过三行时不要固定高度
    CGFloat textHeight = [self.model.contentvalidity sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height;
    CGFloat defaultHeight = 5 + 65 + 15 + 15 + 22 + 50 + 10 + 5;
    if (textHeight < 55) {
        return defaultHeight + textHeight;
    } else {
        if (_model.lessonInfoCellShowAll) {
            return defaultHeight + textHeight;
        } else {
            return defaultHeight + 23 * 3;
        }
    }
//    if (!(_model.lessonInfoCellShowAll)) {
//
//        return 240;
//    }else{
//        CGFloat textHeight = [self.model.contentvalidity sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height;
//        return textHeight + 144 + 50;
//    }
}

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    [_title setText:model.title];
    [_content setText:model.contentvalidity];
    [_playTimes setText:[NSString stringWithFormat:@"%ld次查看",model.playcount]];
    [_time setText:[model.createdDate stringByAppendingString:@" 更新"]];
    [_source setText:[NSString stringWithFormat:@"来源: %@",model.source]];
    
     // TODO: Zup_文本少于三行时，不显示更多
     CGFloat contentHeight = [_content.text sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) font:[UIFont systemFontOfSize:15]].height;
     if (contentHeight < 55) { // 三行文本高度 53.7
         _open.hidden = YES;
     }
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
