//
//  UCMsgTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMsgTableViewCell.h"
#import "UCMsgModel.h"

static NSString * const showAll_keyPath = @"showAll";
static NSString * const isread_key = @"isread";

@interface UCMsgTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyReadIcon;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sabTopCons;


@end

@implementation UCMsgTableViewCell

- (IBAction)showAll:(UIButton *)sender {
    self.model.showAll = !self.model.showAll;
    if ([self.delegate respondsToSelector:@selector(ucmsgCellShowAllWithIndexPath:)]) {
        [self.delegate ucmsgCellShowAllWithIndexPath:self.model.indexPath];
    }
}

+ (NSString *)cellReuseIdWithModel:(UCMsgModel *)model{
    if (model.isEdit) {
        return msgEditCell;
    }else{
        return msgCell;
    }
}

- (void)setModel:(UCMsgModel *)model{
    _model = model;
    
    NSString *contentText = model.content;
    if (model.noticetype == UCMsgModelResourceTypeCustom) {
        contentText = model.title;
    }
    
    NSLog(@"type_%ld\ntitle: %@\ncontent:%@",model.noticetype,model.title,model.content);

    _showAllButton.selected = model.showAll;
    if (model.createdtime.length > length_timeString_1) {
        _time.text = [model.createdtime substringToIndex:length_timeString_1];
    }
    if (model.showAll) {
        _content.numberOfLines = 0;
    }else{
        _content.numberOfLines = 2;
    }
    
    _content.text = contentText;
    /// 已读，不显示小红点
    /// 未读，显示小红点
    _alreadyReadIcon.hidden = model.isread;
    
    [model addObserver:self forKeyPath:isread_key options:NSKeyValueObservingOptionNew context:nil];
     
    /// 计算文本高度
    CGFloat textHeight = [contentText sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 81, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height;
    
    NSInteger lines = textHeight / 19;
    /// 如果行数小于等于2 则 不显示更多按钮
    if (lines <= 2) {
        _showAllButton.hidden = YES;
        _sabTopCons.constant = -20;
    }else{
        _showAllButton.hidden = NO;
        _sabTopCons.constant = 10;
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:isread_key] && object == self.model) {
        _alreadyReadIcon.hidden = self.model.isread;
    }
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:isread_key];
}

@end
