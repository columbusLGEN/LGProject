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
@property (weak, nonatomic) IBOutlet UIView *line_icon_cell;
@property (weak, nonatomic) IBOutlet UIView *line_label_cell;


@end

@implementation UCPersonInfoTableViewCell

- (void)setModel:(UCPersonInfoModel *)model{
    _model = model;
    _itemIconCell.text = model.itemName;
    _item.text = [NSString stringWithFormat:@"%@:",model.itemName];
    if ([model.itemName isEqualToString:@"头像"]) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.content] placeholderImage:DJHeadIconPImage];
    }else{
        _content.text = model.content;
    }
    if (model.canChangePwd) {
        /// 安全显示密码
        NSMutableString *secureText = [NSMutableString new];
        for (NSInteger i = 0; i < model.content.length; i++) {
            [secureText appendString:@"*"];
        }
        _content.text = secureText;
    }
}

+ (NSString *)cellReuseIdWithModel:(UCPersonInfoModel *)model{
    if ([model.iconUrl isEqualToString:@""] || model.iconUrl == nil) {
        return @"UCPersonInfoTableViewNormalCell";
    }else{
        return @"UCPersonInfoTableViewIconCell";
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
