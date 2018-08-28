//
//  LGThreeRightButtonView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGThreeRightButtonView.h"
#import "LGButton.h"

static CGFloat buttonH = 30;

@interface LGThreeRightButtonView ()
@property (strong,nonatomic) UIView *line;
@property (strong, nonatomic) LGButton *leftBtn;
@property (strong, nonatomic) LGButton *midBtn;
@property (strong, nonatomic) LGButton *rightBtn;


@end

@implementation LGThreeRightButtonView

- (void)setLeftIsSelected:(BOOL)leftIsSelected{
    _leftIsSelected = leftIsSelected;
    self.leftBtn.selected = leftIsSelected;
}
- (void)setMiddleIsSelected:(BOOL)middleIsSelected{
    _middleIsSelected = middleIsSelected;
    self.midBtn.selected = middleIsSelected;
}
- (void)setRightIsSelected:(BOOL)rightIsSelected{
    _rightIsSelected = rightIsSelected;
    self.rightBtn.selected = rightIsSelected;
}
- (void)setLikeCount:(NSInteger)likeCount{
    _likeCount = likeCount;
    [self.leftBtn setTitle:[self formatterWithCount:likeCount] forState:UIControlStateNormal];
}
- (void)setCollectionCount:(NSInteger)collectionCount{
    _collectionCount = collectionCount;
    [self.midBtn setTitle:[self formatterWithCount:collectionCount] forState:UIControlStateNormal];
}
- (void)setCommentCount:(NSInteger)commentCount{
    _commentCount = commentCount;
    [self.rightBtn setTitle:[self formatterWithCount:commentCount] forState:UIControlStateNormal];
}

- (NSString *)formatterWithCount:(NSInteger)count{
    NSString *string = @"";
    if (count <= 99) {
        if (count != 0) {
            string = [NSString stringWithFormat:@"%ld",count];        
        }
    }else{
        string = @"99+";
    }
    return string;
}

- (void)setHideTopLine:(BOOL)hideTopLine{
    if (hideTopLine) {
        [self.line removeFromSuperview];
    }
}

- (void)setBothSidesClose:(BOOL)bothSidesClose{
    _bothSidesClose = bothSidesClose;
    if (bothSidesClose) {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];
    }
}

- (void)leftClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(leftClick:sender:success:failure:)]) {
        [self.delegate leftClick:self sender:sender success:^(NSInteger id,NSInteger count){
            NSLog(@"left刷新UI -- id: %ld",id);
            if (sender.isSelected) {
                sender.selected = NO;
            }else{
                sender.selected = YES;
            }
            [self.leftBtn setTitle:[self formatterWithCount:count] forState:UIControlStateNormal];
        } failure:^{
            
        }];
    }
}
- (void)midClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(middleClick:sender:success:failure:)]) {
        [self.delegate middleClick:self sender:sender success:^(NSInteger id,NSInteger count){
//            NSLog(@"mid刷新UI -- id: %ld",id);
            [self.midBtn setTitle:[self formatterWithCount:count] forState:UIControlStateNormal];
            if (sender.isSelected) {
                sender.selected = NO;
            }else{
                sender.selected = YES;
            }
        } failure:^{
            
        }];
    }
}
- (void)rightClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(rightClick:sender:success:failure:)]) {
        [self.delegate rightClick:self sender:sender success:^(NSInteger id,NSInteger count){
            if (sender.isSelected) {
                sender.selected = NO;
            }else{
                sender.selected = YES;
            }
        } failure:^{
            
        }];
    }
}

- (void)setBtnConfigs:(NSArray<NSDictionary *> *)btnConfigs{
    _btnConfigs = btnConfigs;
    if (btnConfigs.count == 2) {
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(marginEight);
            make.left.equalTo(self.mas_left).offset(marginEight);
            make.centerY.equalTo(self.rightBtn.mas_centerY);
            make.width.mas_equalTo(kScreenWidth * 0.5);
            make.height.mas_equalTo(buttonH);
        }];
        [self.midBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-marginEight);
            make.centerY.equalTo(self.leftBtn.mas_centerY);
            make.width.mas_equalTo(self.leftBtn.mas_width);
            make.height.mas_equalTo(buttonH);
        }];
        [self.rightBtn removeFromSuperview];
        _rightBtn = nil;
    }
    [btnConfigs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[TRConfigTitleKey];
        NSString *imgName = obj[TRConfigImgNameKey];
        NSString *selectedImgName = obj[TRConfigSelectedImgNameKey];
        UIColor *textColorNormal = obj[TRConfigTitleColorNormalKey];
        UIColor *textColorSelected = obj[TRConfigTitleColorSelectedKey];
        switch (idx) {
            case 0:{
                [_leftBtn setTitle:title forState:UIControlStateNormal];
                [_leftBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_leftBtn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
                [_leftBtn setTitleColor:textColorNormal forState:UIControlStateNormal];
                [_leftBtn setTitleColor:textColorSelected forState:UIControlStateSelected];
            }
                break;
            case 1:{
                [_midBtn setTitle:title forState:UIControlStateNormal];
                [_midBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_midBtn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
                [_midBtn setTitleColor:textColorNormal forState:UIControlStateNormal];
                [_midBtn setTitleColor:textColorSelected forState:UIControlStateSelected];
            }
                break;
            case 2:{
                [_rightBtn setTitle:title forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
                [_rightBtn setTitleColor:textColorNormal forState:UIControlStateNormal];
                [_rightBtn setTitleColor:textColorSelected forState:UIControlStateSelected];
            }
                break;
            
        }
    }];
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.line];
    [self addSubview:self.leftBtn];
    [self addSubview:self.midBtn];
    [self addSubview:self.rightBtn];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(marginFifteen);
        make.right.equalTo(self.mas_right).offset(-marginFifteen);
        make.height.mas_equalTo(1);
    }];
//    CGFloat buttonW = 60;
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginEight);
        make.right.equalTo(self.midBtn.mas_left).offset(-marginEight);
        make.centerY.equalTo(self.rightBtn.mas_centerY);
        make.height.mas_equalTo(buttonH);
    }];
    [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBtn.mas_left).offset(-marginEight);
        make.centerY.equalTo(self.rightBtn.mas_centerY);
        make.width.mas_equalTo(self.leftBtn.mas_width);
        make.height.mas_equalTo(buttonH);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(marginEight);
        make.right.equalTo(self.mas_right).offset(-marginFifteen);
//        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.leftBtn.mas_width);
        make.height.mas_equalTo(buttonH);
    }];
}
- (UIView *)line{
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor EDJGrayscale_F3];
    }
    return _line;
}
- (LGButton *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [LGButton new];
        [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (LGButton *)midBtn{
    if (_midBtn == nil) {
        _midBtn = [LGButton new];
        [_midBtn addTarget:self action:@selector(midClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _midBtn;
}
- (LGButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [LGButton new];
        [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

@end
