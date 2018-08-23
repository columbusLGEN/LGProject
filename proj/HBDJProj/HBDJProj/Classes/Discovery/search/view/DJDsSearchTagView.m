//
//  DJDsSearchTagView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDsSearchTagView.h"

@interface DJDsSearchTagView ()
@property (weak,nonatomic) UILabel *tagHot;/// 热门标签
@property (weak,nonatomic) UILabel *tagHis;/// 历史记录
@property (weak,nonatomic) UIButton *deleteRecord;

@end

@implementation DJDsSearchTagView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.whiteColor;
        
        UIScrollView *scrollView = UIScrollView.new;
        _scrollView = scrollView;
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_scrollView addSubview:self.conHot];
        [_scrollView addSubview:self.conHis];
        
        CGFloat oriConHeight = 600;//50;
        
        /// 热门标签容器视图
        [_conHot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_scrollView);
            
//            make.top.equalTo(_scrollView.mas_top);
//            make.left.equalTo(_scrollView.mas_left);
//            make.right.equalTo(_scrollView.mas_right);
            
            make.bottom.equalTo(_conHis.mas_top);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(oriConHeight);
        }];
        
        /// 热门标签
        UILabel *tagHot = UILabel.new;
        tagHot.text = @"热门标签";
        tagHot.textColor = UIColor.EDJGrayscale_11;
        tagHot.font = [UIFont systemFontOfSize:15];
        _tagHot = tagHot;
        [_conHot addSubview:tagHot];
        [tagHot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_conHot.mas_top).offset(marginFifteen);
            make.left.equalTo(_conHot.mas_left).offset(marginTen);
            
        }];
        
        
        /// 历史记录容器视图
        [_conHis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_scrollView);
            
//            make.left.equalTo(_scrollView.mas_left);
//            make.right.equalTo(_scrollView.mas_right);
//            make.bottom.equalTo(_scrollView.mas_bottom);
            
            make.height.mas_equalTo(oriConHeight);
            make.width.equalTo(_conHot);
        }];
        
        /// 历史记录
        UILabel *tagHis = UILabel.new;
        tagHis.text = @"历史记录";
        tagHis.textColor = UIColor.EDJGrayscale_11;
        tagHis.font = [UIFont systemFontOfSize:15];
        _tagHis = tagHis;
        [_conHis addSubview:_tagHis];
        [_tagHis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_conHis.mas_top).offset(marginFifteen);
            make.left.equalTo(_tagHot);
        }];
        
        /// 删除历史记录按钮
        UIButton *removeHis = UIButton.new;
        [removeHis setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
        _removeHis = removeHis;
        [_tagHis addSubview:_removeHis];
        [_removeHis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tagHis);
            make.right.equalTo(_conHis.mas_right).offset(-marginTen);
        }];
        
    }
    return self;
}

- (UIView *)conHot{
    if (!_conHot) {
        _conHot = UIView.new;
        _conHot.backgroundColor = UIColor.orangeColor;
    }
    return _conHot;
}
- (UIView *)conHis{
    if (!_conHis) {
        _conHis = UIView.new;
        _conHis.backgroundColor = UIColor.cyanColor;
    }
    return _conHis;
}

@end
