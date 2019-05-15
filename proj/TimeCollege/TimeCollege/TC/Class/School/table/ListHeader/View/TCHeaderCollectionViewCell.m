//
//  TCHeaderCollectionViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCHeaderCollectionViewCell.h"
#import "TCQuadrateModel.h"
#import "TCBookCatagoryLineModel.h"
#import "TCTriangleView.h"

static CGFloat bh = 28;

@interface TCHeaderCollectionViewCell ()
@property (strong,nonatomic) UIButton *button;
@property (strong,nonatomic) TCTriangleView *arrowDone;

@end

@implementation TCHeaderCollectionViewCell

- (void)setModel:(TCQuadrateModel *)model{
    _model = model;
    [_button setTitle:model.title forState:UIControlStateNormal];
//    NSLog(@"qmodel.title:%@",model.title);
    _button.selected = model.seleted;

    if (model.seleted) {
        [_button cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:bh * 0.5];
        [_button setBackgroundColor:UIColor.YBColor_E8F3FE];
        if (model.secondaryCata.count) {
            self.arrowDone.hidden = NO;
        }else{
            self.arrowDone.hidden = YES;
        }
    }else{
        if (model.lineModel.isSecondery) {
            [_button setBackgroundColor:UIColor.YBColor_E8F3FE];
        }else{
            [_button setBackgroundColor:UIColor.whiteColor];
        }
        self.arrowDone.hidden = YES;
    }
}

- (void)buttonClick:(UIButton *)sender{
    self.model.seleted = !self.model.seleted;
    
    /// 创建二级分类模型
    TCBookCatagoryLineModel *lineModel = TCBookCatagoryLineModel.new;
    lineModel.bookCata = self.model.secondaryCata;
    
    /// 通知时:
    
    /// 1.是否 是二级模型
    /// 1.1 是
        /// 1.1.2 展示 or 隐藏
    /// 1.2 不是二级模型
    
    if (self.model.secondaryCata.count) {
        lineModel.isSecondery = YES;
        if (self.model.seleted) {
            /// 需要 显示二级分类
            lineModel.showSeconndery = YES;
            
        }else{
            lineModel.showSeconndery = NO;
            
        }
    }else{
        /// 没有二级分类
        lineModel.isSecondery = NO;
        
    }
    
    [NSNotificationCenter.defaultCenter
     postNotificationName:kNotificationListFenleiClick
     object:nil
     userInfo:@{
                kNotificationListFenleiClickInfoOrigin:self.model,
                kNotificationListFenleiClickInfoSecondery:lineModel,
                kNotificationListFenleiClickInfoCurrenLine:self.model.lineModel
                }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-2);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(bh);
        }];
        
        [self.contentView addSubview:self.arrowDone];
        [self.arrowDone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button.mas_bottom);
            make.centerX.equalTo(self.button);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(5);
        }];
        self.arrowDone.hidden = YES;
    }
    return self;
}
- (UIButton *)button{
    if (!_button) {
        _button = UIButton.new;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        /// 选中
        [_button setTitleColor:UIColor.TCColor_mainColor forState:UIControlStateSelected];
        
        /// normal
        [_button setTitleColor:UIColor.YBColor_6A6A6A forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_button cutBorderWithBorderWidth:0 borderColor:UIColor.whiteColor cornerRadius:bh * 0.5];
        
        [_button setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    }
    return _button;
}

- (TCTriangleView *)arrowDone{
    if (!_arrowDone) {
        _arrowDone = [TCTriangleView.alloc init];
//        _arrowDone = [TCTriangleView.alloc initWithFrame:CGRectMake(0, 0, 10, 10)];
        _arrowDone.backgroundColor = UIColor.whiteColor;
    }
    return _arrowDone;
}

@end
