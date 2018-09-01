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

@interface UCMsgTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyReadIcon;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;


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
    _content.text = model.content;
    _showAllButton.selected = model.showAll;
    if (model.showAll) {
        _content.numberOfLines = 0;
    }else{
        _content.numberOfLines = 2;
    }
}


@end
