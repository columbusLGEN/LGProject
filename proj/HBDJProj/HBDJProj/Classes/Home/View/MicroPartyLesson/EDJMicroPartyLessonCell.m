//
//  EDJMicroPartyLessonCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessonCell.h"
#import "EDJMicroPSCellHeader.h"
#import "EDJMicroPSCellFooter.h"

@interface EDJMicroPartyLessonCell ()
@property (strong,nonatomic) EDJMicroPSCellHeader *header;
@property (strong,nonatomic) EDJMicroPSCellFooter *footer;

@end

@implementation EDJMicroPartyLessonCell

- (EDJMicroPSCellHeader *)header{
    if (_header == nil) {
        _header = [EDJMicroPSCellHeader new];
    }
    return _header;
}
- (EDJMicroPSCellFooter *)footer{
    if (_footer == nil) {
        _footer = [EDJMicroPSCellFooter new];
    }
    return _footer;
}


- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(53);
    }];
    
    /// content 每个 高度 90
    
    /// footer 高度 与 header 相同
    [self.contentView addSubview:self.footer];
    [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.header.mas_height);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
@end
