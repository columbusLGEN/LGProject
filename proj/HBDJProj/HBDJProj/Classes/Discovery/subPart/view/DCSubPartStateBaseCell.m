//
//  DCSubPartStateBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateBaseCell.h"
#import "DCSubPartStateModel.h"
#import "LGThreeRightButtonView.h"

@interface DCSubPartStateBaseCell ()

@end

@implementation DCSubPartStateBaseCell

- (void)setModel:(DCSubPartStateModel *)model{
    _model = model;
    _timeLabel.text = [model.timestamp timestampToDate_nyr];;
}

+ (NSString *)cellReuseIdWithModel:(DCSubPartStateModel *)model{
    switch (model.imgCount) {
        case 0:
            return withoutImgCell;
            break;
        case 1:
            return oneImgCell;
            break;
        case 3:
            return threeImgCell;
            break;
        default:
            return withoutImgCell;
            break;
    }
    return withoutImgCell;
}

- (void)setupUI{
    UIView *rect = [UIView new];
    rect.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:rect];
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.boInterView];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        make.bottom.equalTo(self.boInterView.mas_top).offset(-marginFifteen);
        make.height.mas_equalTo(17);
    }];
    [self.boInterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rect.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(45);
    }];
    [rect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(5);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];

}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = UILabel.new;
        _timeLabel.textColor = UIColor.EDJGrayscale_A4;
    }
    return _timeLabel;
}

- (LGThreeRightButtonView *)boInterView{
    if (_boInterView == nil) {
        _boInterView = [LGThreeRightButtonView new];
        [_boInterView setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_like_normal",
                                        TRConfigSelectedImgNameKey:@"dc_like_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                        TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_CEB0E7]
                                        }]];
    }
    return _boInterView;
}

@end
