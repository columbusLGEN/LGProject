//
//  TCBookInfoCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookInfoCell.h"
#import "TCBIRecoCell.h"
#import "TCBIContentCell.h"
#import "TCBIMessageCell.h"

@implementation TCBookInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *rect = UIView.new;
        rect.backgroundColor = UIColor.TCColor_mainColor;
        [self.contentView addSubview:rect];
        [rect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(14);
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }];
        
        [self.contentView addSubview:self.itemName];
        
        [self.itemName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(12);
            make.left.equalTo(rect.mas_right).offset(5);
            make.centerY.equalTo(rect);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(19);
            
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(2);
        }];
        
    }
    return self;
}

- (UILabel *)itemName{
    if (!_itemName) {
        _itemName = UILabel.new;
        _itemName.font = [UIFont systemFontOfSize:16];
        _itemName.textColor = UIColor.blackColor;
    }
    return _itemName;
}
- (UIView *)line{
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = UIColor.YBColor_F3F3F3;
    }
    return _line;
}

+ (NSString *)cellReuseIdWith:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return BIMSGcell;
        }
            break;
        case 1:{
            return BICTTcell;
        }
            break;
        case 2:{
            return BIRCcell;
        }
            break;
        default:
            return BIMSGcell;
    }
}


@end
