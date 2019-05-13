//
//  ECRHomeTitleView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LGNavigationSearchBar.h"

#define noticeWord @"搜索你想要的"
#define searchImgName @"icon_search_gray"

@interface LGNavigationSearchBar ()

/** 导航栏左按钮 */
@property (strong,nonatomic) UIButton *leftButton;

@end

@implementation LGNavigationSearchBar

#pragma mark - target
- (void)leftButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(leftButtonClick:)]) {
        [self.delegate leftButtonClick:self];
    }
}
/// MARK: 点击搜索
- (void)searchClick:(UIButton *)bsender{
    if ([self.delegate respondsToSelector:@selector(navSearchClick:)]) {
        [self.delegate navSearchClick:self];
    }
}

#pragma mark - setter

- (void)setLeftTitle:(NSString *)leftTitle{
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
}
- (void)setLeftImgName:(NSString *)leftImgName{
    [self.leftButton setImage:[UIImage imageNamed:leftImgName]
                     forState:UIControlStateNormal];
}
- (void)setRightButton:(UIButton *)rightButton{
    _rightButton = rightButton;
    [self addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-marginFive);
        make.width.mas_equalTo(50);
        make.bottom.equalTo(self.fakeSearch.mas_bottom);
        make.height.mas_equalTo(35);
    }];
}

- (void)setIsEditing:(BOOL)isEditing{
    if (isEditing) {
        [self.fakeSearch setTitle:nil forState:UIControlStateNormal];
        [self.fakeSearch setImage:nil forState:UIControlStateNormal];
    }else{
        [self.fakeSearch setTitle:noticeWord forState:UIControlStateNormal];
        [self.fakeSearch setImage:[UIImage imageNamed:searchImgName]
                         forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor TCColor_mainColor];
        [self addSubview:self.leftButton];
        [self addSubview:self.fakeSearch];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(marginFive);
            make.width.mas_equalTo(50);
            make.bottom.equalTo(self.fakeSearch.mas_bottom);
            make.height.mas_equalTo(35);
        }];
        [self.fakeSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-marginEight);
            make.left.equalTo(self.leftButton.mas_right).offset(marginEight);
            make.right.equalTo(self.mas_right).offset(-marginTen);
            make.height.mas_equalTo(LGNavBarButtonHeight);
        }];
    
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - getter
- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setImage:[UIImage imageNamed:@"home_nav_logo"] forState:UIControlStateNormal];
        _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)fakeSearch{
    if (_fakeSearch == nil) {
        _fakeSearch = [[UIButton alloc] init];
        _fakeSearch.highlighted = NO;
        _fakeSearch.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fakeSearch setTitleColor:[UIColor YBColor_6A6A6A] forState:UIControlStateNormal];
        [_fakeSearch setTitle:noticeWord forState:UIControlStateNormal];
        [_fakeSearch setBackgroundColor:[UIColor YBColor_F3F3F3]];
        [_fakeSearch setImage:[UIImage imageNamed:searchImgName]
                     forState:UIControlStateNormal];
        _fakeSearch.layer.cornerRadius = LGNavBarButtonHeight * 0.5;
        _fakeSearch.layer.masksToBounds = YES;
        /// 控制器文字内容位置
//        [_fakeSearch setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        /// 控制器图标位置
        [_fakeSearch setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_fakeSearch addTarget:self
                        action:@selector(searchClick:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _fakeSearch;
}


CGFloat navHeight(){
    /// 判断 iPhone X,暂时用屏幕高度做设备唯一性判断,如果还有其他好的方法,则替换
    if (kLGScreenHeight >= 812) {/// iPhone X 屏幕像素尺寸为 1125*2436
        return 88;
    }
    
    return 64;
}

@end



