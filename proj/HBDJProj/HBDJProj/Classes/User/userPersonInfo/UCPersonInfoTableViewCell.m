//
//  UCPersonInfoTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPersonInfoTableViewCell.h"
#import "UCPersonInfoModel.h"

@interface UCPersonInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemIconCell;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end

@implementation UCPersonInfoTableViewCell

- (void)setModel:(UCPersonInfoModel *)model{
    _model = model;
    if (model.iconUrl) {
        _itemIconCell.text = @"头像";
    }else{
        _item.text = model.itemName;
        _content.text = @"孙悟空";
    }
}

+ (NSString *)cellReuseIdWithModel:(UCPersonInfoModel *)model{
    if (model.iconUrl) {
        return @"UCPersonInfoTableViewIconCell";
    }else{
        return @"UCPersonInfoTableViewNormalCell";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_iconBg cutToCycle];
    [_icon cutToCycle];
    CGFloat shadowOffset = 2;
    [_iconBg setShadowWithShadowColor:[UIColor EDJGrayscale_F4] shadowOffset:CGSizeMake(shadowOffset, shadowOffset) shadowOpacity:1 shadowRadius:shadowOffset];
}

@end
