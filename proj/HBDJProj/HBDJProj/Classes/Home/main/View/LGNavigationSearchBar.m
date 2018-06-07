//
//  ECRHomeTitleView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LGNavigationSearchBar.h"

static CGFloat buttonHeight = 30;

@interface LGNavigationSearchBar ()

/** 导航栏左按钮 */
@property (strong,nonatomic) UIButton *leftButton;
/** 导航栏右按钮 */
@property (strong,nonatomic) UIButton *rightButton;
/** 搜搜框右按钮,例如:语音搜索按钮,放在fakesearch之上的 */
@property (strong,nonatomic) UIButton *searchRightBtn;

@end

@implementation LGNavigationSearchBar

#pragma mark - target
- (void)leftButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(leftButtonClick:)]) {
        [self.delegate leftButtonClick:self];
    }
}
/// MARK: 设置导航栏的背景色状态
- (void)setBgdsState:(NavState)bgdsState{
    _bgdsState = bgdsState;
    switch (bgdsState) {
        case NavStateDefault:{
        }
            break;
        case NavStateSolid:{
        }
            break;
    }
}
/// MARK: 点击搜索
- (void)searchClick:(UIButton *)bsender{
    if ([self.delegate respondsToSelector:@selector(navSearchClick:)]) {
        [self.delegate navSearchClick:self];
    }
}
/// MARK: 点击语音助手
- (void)voiceSearchClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(voiceButtonClick:)]) {
        [self.delegate voiceButtonClick:self];
    }
}
/// MARK: 点击右按钮
- (void)rightButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(navRightButtonClick:)]) {
        [self.delegate navRightButtonClick:self];
    }
}

#pragma mark - setter
- (void)setIsShowRightBtn:(BOOL)isShowRightBtn{
    _isShowRightBtn = isShowRightBtn;
    if (isShowRightBtn) {
        [self.fakeSearch mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-marginEight);
            make.left.equalTo(self.leftButton.mas_right).offset(marginEight);
            make.height.mas_equalTo(buttonHeight);
        }];
        if (_rightButton == nil) {
            [self addSubview:self.rightButton];
        }
        [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fakeSearch.mas_right).offset(marginFifteen);
            make.right.equalTo(self.mas_right).offset(-marginFifteen);
            make.centerY.equalTo(self.fakeSearch.mas_centerY);
            make.width.mas_equalTo(40);
        }];
    }else{
        /// 先移除 rightButton,再remake fakeSearch 的约束,否则报约束警告
        [self.rightButton removeFromSuperview];
        _rightButton = nil;
        [self.fakeSearch mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-marginEight);
            make.left.equalTo(self.leftButton.mas_right).offset(marginEight);
            make.right.equalTo(self.mas_right).offset(-marginTen);
            make.height.mas_equalTo(buttonHeight);
        }];
    }
}
- (void)setRightButtonTitle:(NSString *)rightButtonTitle{
    _rightButtonTitle = rightButtonTitle;
    [_rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor EDJGrayscale_33] forState:UIControlStateNormal];
}
- (void)setLeftImgName:(NSString *)leftImgName{
    [self.leftButton setImage:[UIImage imageNamed:leftImgName]
                     forState:UIControlStateNormal];
}
- (void)setIsEditing:(BOOL)isEditing{
    if (isEditing) {
        [self.fakeSearch setTitle:nil forState:UIControlStateNormal];
        [self.fakeSearch setImage:nil forState:UIControlStateNormal];
    }else{
        [self.fakeSearch setTitle:@"搜索你想要的" forState:UIControlStateNormal];
        [self.fakeSearch setImage:[UIImage imageNamed:@"home_nav_search"]
                         forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftButton];
        [self addSubview:self.fakeSearch];
        [self addSubview:self.searchRightBtn];
        [self addSubview:self.rightButton];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(marginFive);
            make.width.mas_equalTo(35);
            make.bottom.equalTo(self.fakeSearch.mas_bottom);
            make.height.mas_equalTo(35);
        }];
        [self.fakeSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-marginEight);
            make.left.equalTo(self.leftButton.mas_right).offset(marginEight);
            make.right.equalTo(self.mas_right).offset(-marginTen);
            make.height.mas_equalTo(buttonHeight);
        }];
        [self.searchRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.fakeSearch.mas_right).offset(-marginEight);
            make.centerY.equalTo(self.fakeSearch.mas_centerY);
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
        [_fakeSearch setTitleColor:[UIColor EDJGrayscale_88] forState:UIControlStateNormal];
        [_fakeSearch setTitle:@"搜索你想要的" forState:UIControlStateNormal];
        [_fakeSearch setBackgroundColor:[UIColor EDJGrayscale_F4]];
        [_fakeSearch setImage:[UIImage imageNamed:@"home_nav_search"]
                     forState:UIControlStateNormal];
        _fakeSearch.layer.cornerRadius = buttonHeight * 0.5;
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
- (UIButton *)searchRightBtn{
    if (_searchRightBtn == nil) {
        _searchRightBtn = [[UIButton alloc] init];
        [_searchRightBtn setBackgroundImage:[UIImage imageNamed:@"home_nav_voice"]
                                      forState:UIControlStateNormal];
        [_searchRightBtn addTarget:self action:@selector(voiceSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchRightBtn;
}
- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [UIButton new];
//        _rightButton.backgroundColor = [UIColor randomColor];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

CGFloat navHeight(){
    /// 判断 iPhone X,暂时用屏幕高度做设备唯一性判断,如果还有其他好的方法,则替换
    if (kScreenHeight == 812) {/// iPhone X 屏幕像素尺寸为 1125*2436
        return 88;
    }
    
    return 64;
}

@end



