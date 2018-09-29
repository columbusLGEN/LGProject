//
//  DCRichTextTopInfoView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCRichTextTopInfoView.h"
#import "DJDataBaseModel.h"

@interface DCRichTextTopInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
/** 查看次数 */
@property (weak, nonatomic) IBOutlet UILabel *counts;


@end

@implementation DCRichTextTopInfoView

- (void)reloadPlayCount:(NSInteger)count{
    _counts.text = [NSString stringWithFormat:@"查看次数: %ld",(long)count];
}

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    
    /// 冲突：支部动态详情 & 党建要闻、微党课图文详情
    
    _title.text = model.title;
    
    if (_tabIndex == 0) {
        /// 讲习 & 消息详情
//        _time.text = model.createdDate;
        _time.text = [model.createdtime timestampToMin];
        
        _source.hidden = NO;
        _source.text = [NSString stringWithFormat:@"来源: %@",model.source];
    }else{
        /// 发现
        _time.text = [model.timestamp timestampToMin];/// 支部动态
    }
    
    if (_isMsgTrans) {/// 自定义消息详情
        [_source removeFromSuperview];
        [_counts removeFromSuperview];
    }
    

}

- (void)setDisplayCounts:(BOOL)displayCounts{
    if (displayCounts) _counts.hidden = NO;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _counts.hidden = YES;
    _source.hidden = YES;
}

+ (instancetype)richTextTopInfoView{
    return [[[NSBundle mainBundle] loadNibNamed:@"DCRichTextTopInfoView" owner:nil options:nil] lastObject];
}

@end
