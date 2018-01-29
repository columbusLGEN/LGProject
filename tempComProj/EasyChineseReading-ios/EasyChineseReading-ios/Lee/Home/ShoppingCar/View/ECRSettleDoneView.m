//
//  ECRSettleDoneView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRSettleDoneView.h"
#import "UIView+Extension.h"

@interface ECRSettleDoneView ()

// 勾选按钮
@property (strong,nonatomic) UIButton *allSelect;
@property (strong,nonatomic) UIButton *allSelectText;//
@property (strong,nonatomic) UIButton *btn;
// 删除按钮
@property (strong,nonatomic) UIButton *rmFromCar;// <##>
// 合并结算按钮
@property (strong,nonatomic) UIButton *done;// 结算

@end

@implementation ECRSettleDoneView

- (void)removeFromCar:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(sdViewAllRemoveFormCar:)]) {
        [self.delegate sdViewAllRemoveFormCar:self];
    }
}

- (void)allSelectedCanceled{
    // 取消全选
    _allSelect.selected = NO;
}
- (void)allSelected{
    _allSelect.selected = YES;
}
- (void)allSelected:(UIButton *)sender{
    
    if (_allSelect.selected) {
        _allSelect.selected = NO;
    }else{
        _allSelect.selected = YES;
    }
    if ([self.delegate respondsToSelector:@selector(sdViewAllSelected:)]) {
        [self.delegate sdViewAllSelected:self];
    }
}

- (void)setPrice:(CGFloat)price{
    _price = price;
//    [_done setTitle:[NSString stringWithFormat:@"结算(%.2f)",price] forState:UIControlStateNormal];
}

- (void)doneClick:(UIButton *)sender{
    // MARK: 点击 结算
    if ([self.delegate respondsToSelector:@selector(sdView:)]) {
        [self.delegate sdView:self];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat doneTFont = 14;
        UIColor *white = [UIColor whiteColor];
        UIColor *currentThemeColor = [LGSkinSwitchManager currentThemeColor];
        // 全选
        _allSelect = [[UIButton alloc] init];
        
        _allSelectText = [[UIButton alloc] init];
        [_allSelect setImage:[UIImage imageNamed:@"icon_selected_no"] forState:UIControlStateNormal];
        [_allSelect setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
        
        [self addSubview:_allSelect];
        [_allSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(9);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
        }];
        [self addSubview:_allSelectText];
        [_allSelectText setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _allSelectText.titleLabel.font = [UIFont systemFontOfSize:doneTFont];
        [_allSelectText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_allSelect.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        _btn = [[UIButton alloc] init];
        [self addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(_allSelect.mas_left);
            make.right.equalTo(_allSelectText.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [_btn addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        _rmFromCar = [[UIButton alloc] init];
        [self addSubview:_rmFromCar];
        _done = [[UIButton alloc] init];
        [self addSubview:_done];
        
        CGFloat cnr = 16;
        [_done sizeToFit];// 计算宽高

        [_rmFromCar setContentEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [_rmFromCar setTitleColor:currentThemeColor forState:UIControlStateNormal];
        _rmFromCar.layer.borderColor = currentThemeColor.CGColor;
        _rmFromCar.layer.borderWidth = 1;
        _rmFromCar.layer.cornerRadius = cnr;
        _rmFromCar.layer.masksToBounds = YES;
        _rmFromCar.titleLabel.font = [UIFont systemFontOfSize:doneTFont];
        [_rmFromCar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_done.mas_left).offset(-8);
            make.centerY.equalTo(_done.mas_centerY);
//            make.width.equalTo(@(_done.width));
        }];
        [_rmFromCar addTarget:self action:@selector(removeFromCar:) forControlEvents:UIControlEventTouchUpInside];
        
        [_done setTitleColor:white forState:UIControlStateNormal];
        [_done setContentEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [_done setBackgroundColor:currentThemeColor];
        _done.layer.cornerRadius = cnr;
        _done.layer.masksToBounds = YES;
        _done.titleLabel.font = [UIFont systemFontOfSize:doneTFont];
        [_done addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
        [_done mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-8);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self textDependsLauguage];
    }
    return self;
}
- (void)textDependsLauguage{
    [_allSelectText setTitle:[LGPChangeLanguage localizedStringForKey:@"全选"] forState:UIControlStateNormal];
    [_rmFromCar setTitle:[LGPChangeLanguage localizedStringForKey:@"删除"] forState:UIControlStateNormal];
    [_rmFromCar sizeToFit];
    [_done setTitle:[LGPChangeLanguage localizedStringForKey:@"合并结算"] forState:UIControlStateNormal];
}

@end
