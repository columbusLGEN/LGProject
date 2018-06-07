//
//  DCRichTextTopInfoView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCRichTextTopInfoView.h"
#import "EDJMicroBuildModel.h"

@interface DCRichTextTopInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
/** 查看次数 */
@property (weak, nonatomic) IBOutlet UILabel *counts;


@end

@implementation DCRichTextTopInfoView

- (void)setModel:(EDJMicroBuildModel *)model{
    _model = model;
    _title.text = model.title;
    _time.text = model.createdtime;
    _source.text = [NSString stringWithFormat:@"来源: %@",model.source];
    _counts.text = [NSString stringWithFormat:@"查看次数: %ld",model.playcount];
}

- (void)setDisplayCounts:(BOOL)displayCounts{
    if (displayCounts) _counts.hidden = NO;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _counts.hidden = YES;
}

+ (instancetype)richTextTopInfoView{
    return [[[NSBundle mainBundle] loadNibNamed:@"DCRichTextTopInfoView" owner:nil options:nil] lastObject];
}

@end
