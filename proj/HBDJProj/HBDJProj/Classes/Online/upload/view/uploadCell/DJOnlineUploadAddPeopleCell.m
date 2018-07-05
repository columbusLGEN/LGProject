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
        _content.text = self.model.content;
    }
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    _content.text = [model.itemName stringByAppendingString:@"内容"];
    
    if (model.itemClass == OLUploadTableModelClassSelectTime) {
        [model addObserver:self forKeyPath:olupTimeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *lbl = UILabel.new;
        [self.contentView addSubview:lbl];
        _content = lbl;
        _content.textColor = [UIColor EDJGrayscale_11];
        _content.font = [UIFont systemFontOfSize:14];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginTen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.centerY.equalTo(self.contentView.mas_centerY);
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
