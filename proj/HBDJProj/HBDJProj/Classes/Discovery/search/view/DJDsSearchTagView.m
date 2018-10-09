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

@implementation DJDsSearchTagView{
    CGFloat oriConHeight;
}

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
        [_scrollView addSubview:self.hisConView];
        
        oriConHeight = 50;
        
        /// 热门标签容器视图
        [_conHot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_scrollView);
            make.bottom.equalTo(_hisConView.mas_top);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(oriConHeight);
        }];
        
        /// 热门标签
        UILabel *tagHot = UILabel.new;
        tagHot.tag = -1;
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
        [_hisConView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_scrollView);
            make.height.mas_equalTo(oriConHeight);
            make.width.equalTo(_conHot);
        }];
        
        /// 历史记录
        UILabel *tagHis = UILabel.new;
        tagHis.tag = -1;
        tagHis.text = @"历史记录";
        tagHis.textColor = UIColor.EDJGrayscale_11;
        tagHis.font = [UIFont systemFontOfSize:15];
        _tagHis = tagHis;
        [_hisConView addSubview:_tagHis];
        [_tagHis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_hisConView.mas_top).offset(marginFifteen);
            make.left.equalTo(_tagHot);
        }];
        
        /// 删除历史记录按钮
        UIButton *removeHis = UIButton.new;
        removeHis.tag = -1;
        [removeHis setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
        _removeHis = removeHis;
        [_tagHis addSubview:_removeHis];
        [_removeHis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tagHis);
            make.right.equalTo(_hisConView.mas_right).offset(-marginTen);
        }];
        
    }
    return self;
}

- (void)hideSelectLabelViewWithAllHeight:(CGFloat)allHeight{
    self.conHot.hidden = YES;
    [self.hisConView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(_scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(allHeight);
    }];
}
- (void)showFirstItemWith:(BOOL)show selectHeight:(CGFloat)selectHeight allHeight:(CGFloat)allHeight{
    self.conHot.hidden = !show;
    
    if (show) {
        /// 显示上容器视图
        [self.conHot mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_scrollView);
            make.bottom.equalTo(_hisConView.mas_top);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(selectHeight);
        }];
        [self.hisConView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_scrollView);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(allHeight);
        }];
        
    }else{
        /// 不显示 上容器视图
        [self.hisConView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_scrollView);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(allHeight);
        }];
    }
}

- (void)setFirstTitle:(NSString *)firstTitle{
    _tagHot.text = firstTitle;
}
- (void)setSecondTitle:(NSString *)secondTitle{
    _tagHis.text = secondTitle;
}
- (void)setFontOfFirstTitle:(NSInteger)fontOfFirstTitle{
    _tagHot.font = [UIFont systemFontOfSize:fontOfFirstTitle];
}
- (void)setFontOfSecondTitle:(NSInteger)fontOfSecondTitle{
    _tagHis.font = [UIFont systemFontOfSize:fontOfSecondTitle];
}
- (void)setTextColorFirstTitle:(UIColor *)textColorFirstTitle{
    _tagHot.textColor = textColorFirstTitle;
}
- (void)setTextColorSecondTitle:(UIColor *)textColorSecondTitle{
    _tagHis.textColor = textColorSecondTitle;
}
- (void)setSubTitleOfFirstItem:(UILabel *)subTitleOfFirstItem{
    _subTitleOfFirstItem = subTitleOfFirstItem;
    [_conHot addSubview:subTitleOfFirstItem];
    [subTitleOfFirstItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tagHot.mas_centerY);
        make.left.equalTo(_tagHot.mas_right).offset(marginFifteen);
    }];
}

- (UIView *)conHot{
    if (!_conHot) {
        _conHot = UIView.new;
    }
    return _conHot;
}
- (UIView *)hisConView{
    if (!_hisConView) {
        _hisConView = UIView.new;
    }
    return _hisConView;
}

@end
