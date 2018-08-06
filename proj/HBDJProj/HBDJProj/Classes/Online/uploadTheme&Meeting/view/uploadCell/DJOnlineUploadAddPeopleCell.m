//
//  DJOnlineUplaodAddPeopleCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUploadAddPeopleCell.h"
#import "DJOnlineUploadTableModel.h"

static NSString * const olupTimeKeyPath = @"content";

@interface DJOnlineUploadAddPeopleCell ()
@property (weak,nonatomic) UILabel *content;

@end

@implementation DJOnlineUploadAddPeopleCell

#pragma mark - KVO
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    if ([keyPath isEqualToString:olupTimeKeyPath] && object == self.model) {
        NSString *timeString;
        if (self.model.content.length > length_timeString) {
            timeString = [self.model.content substringToIndex:(length_timeString + 1)];
        }
        _content.text = timeString;
        _content.textColor = [UIColor EDJGrayscale_11];
    }
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    if (model.content) {
        _content.text = model.content;
        _content.textColor = [UIColor EDJGrayscale_11];
    }
    
    if (model.itemClass == OLUploadTableModelClassSelectTime) {
        /// 选择时间单元格，监听模型的conent属性，在用户改变了时间之后，在不刷新tablView 的情况下 更新单元格时间label的值
        [model addObserver:self forKeyPath:olupTimeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *lbl = UILabel.new;
        [self.contentView addSubview:lbl];
        _content = lbl;
        _content.numberOfLines = 0;
        _content.text = @"请点击进行选择";
        _content.textColor = [UIColor EDJGrayscale_F3];
        _content.font = [UIFont systemFontOfSize:14];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.item.mas_top);
            make.left.equalTo(self.item.mas_right).offset(marginTen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginFifteen);
        }];
        
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
        }];
        
    }
    return self;
}
- (void)dealloc{
    if (self.model.itemClass == OLUploadTableModelClassSelectTime) {
        [self.model removeObserver:self forKeyPath:olupTimeKeyPath];
    }
}

@end
