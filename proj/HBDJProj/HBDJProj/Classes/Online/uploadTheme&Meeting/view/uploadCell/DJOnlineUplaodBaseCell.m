//
//  DJOnlineUplaodBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUplaodBaseCell.h"
#import "DJOnlineUploadTableModel.h"

#import "DJOnlineUploadCell.h"
#import "DJOnlineUploadAddPeopleCell.h"
#import "DJOnlineUploadAddCoverCell.h"
#import "DJOnlineUploadAddImgCell.h"
#import "DJOnlineUploadSelectMeetingTag.h"

@implementation DJOnlineUplaodBaseCell

+ (NSString *)cellReuseIdWithModel:(DJOnlineUploadTableModel *)model{
    switch (model.itemClass) {
        case OLUploadTableModelClassTextInput:
            return inputTextCell;
            break;
        case OLUploadTableModelClassSelectTime:
        case OLUploadTableModelClassSelectPeople:
            case OLUploadTableModelClassSelectHost:
            case OLUploadTableModelClassSelectPeopleNotCome:
            return addPeopleCell;
            break;
        case OLUploadTableModelClassSelectCover:
            return addCoverCell;
            break;
        case OLUploadTableModelClassSelectImage:
            return addImgCell;
            break;
        case OLUploadTableModelClassSelectMeetingTag:
            return selectMeetingTagCell;
            break;
    }
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    _model = model;
    _item.text = [model.itemName stringByAppendingString:@":"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *item = UILabel.new;
        [self.contentView addSubview:item];
        _item = item;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        item.font = [UIFont systemFontOfSize:15];
        item.textColor = [UIColor EDJGrayscale_11];
        
        UIView *line_sep = UIView.new;
        line_sep.backgroundColor = [UIColor EDJGrayscale_F3];
        [self.contentView addSubview:line_sep];
        [line_sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        _line_sep = line_sep;
        
        [self layoutIfNeeded];
    }
    return self;
}

@end
