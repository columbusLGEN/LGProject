//
//  DCSubPartStateBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateBaseCell.h"
#import "model/DCSubPartStateModel.h"
#import "LGThreeRightButtonView.h"

@interface DCSubPartStateBaseCell ()
@property (strong, nonatomic) LGThreeRightButtonView *boInterView;

@end

@implementation DCSubPartStateBaseCell

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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *rect = [UIView new];
    rect.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:rect];
    
    [self.contentView addSubview:self.boInterView];
    [self.boInterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rect.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(45);
    }];
    [rect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(5);
    }];
}

- (LGThreeRightButtonView *)boInterView{
    if (_boInterView == nil) {
        _boInterView = [LGThreeRightButtonView new];
        [_boInterView setBtnConfigs:@[@{TRConfigTitleKey:@"收藏",
                                        TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                        TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow"
                                        },
                                      @{TRConfigTitleKey:@"点赞",
                                        TRConfigImgNameKey:@"dc_like_normal",
                                        TRConfigSelectedImgNameKey:@"dc_like_selected"
                                        },
                                      @{TRConfigTitleKey:@"评论",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected"
                                        }]];
    }
    return _boInterView;
}





@end
