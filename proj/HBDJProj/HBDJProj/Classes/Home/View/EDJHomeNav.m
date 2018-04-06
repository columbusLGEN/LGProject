//
//  ECRHomeTitleView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EDJHomeNav.h"

@interface EDJHomeNav ()
/** 导航栏左按钮 */
@property (strong,nonatomic) UIButton *leftButton;
/** 导航栏右按钮 */
//@property (strong,nonatomic) UIButton *rightButton;
/** 搜索按钮 */
@property (strong,nonatomic) UIButton *fakeSearch;
/** 搜搜框右按钮 */
@property (strong,nonatomic) UIButton *searchRightButton;

@end

@implementation EDJHomeNav

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
    if ([self.delegate respondsToSelector:@selector(hnViewBeginSearch:)]) {
        [self.delegate hnViewBeginSearch:self];
    }
}
/// MARK: 点击语音助手
//- (void)

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor randomColor];
        [self addSubview:self.leftButton];
        [self addSubview:self.fakeSearch];
        [self addSubview:self.searchRightButton];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(marginFive);
            make.width.equalTo(@(widthFifty));
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(frame.size.height * 0.8));
        }];
        [self.fakeSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftButton.mas_centerY);
            make.left.equalTo(self.leftButton.mas_right).offset(marginEight);
            make.right.equalTo(self.mas_right).offset(-marginTen);
            make.height.equalTo(@(frame.size.height * 0.7));
        }];
        [self.searchRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    
    }
    return self;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _leftButton;
}
- (UIButton *)fakeSearch{
    if (_fakeSearch == nil) {
        _fakeSearch = [[UIButton alloc] init];
        _fakeSearch.highlighted = NO;
        _fakeSearch.titleLabel.font = [UIFont systemFontOfSize:14];
        /// TODO:搜索框文字按钮颜色,左边 图标,背景色
        [_fakeSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fakeSearch setTitle:@"搜索你想要的" forState:UIControlStateNormal];
        [_fakeSearch setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_fakeSearch setBackgroundColor:[UIColor whiteColor]];
        _fakeSearch.layer.cornerRadius = 16;
        _fakeSearch.layer.masksToBounds = YES;
        [_fakeSearch setContentEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
        [_fakeSearch addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fakeSearch;
}
- (UIButton *)searchRightButton{
    if (_searchRightButton) {
        _searchRightButton = [[UIButton alloc] init];
        [_searchRightButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _searchRightButton;
}

CGFloat navHeight(){
    /// 判断 iPhone X,暂时用屏幕高度做设备唯一性判断,如果还有其他好的方法,则替换
    if (kScreenHeight == 812) {/// iPhone X 屏幕像素尺寸为 1125*2436
        return 88;
    }
    
    return 64;
}

@end



