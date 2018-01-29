//
//  ECRBrebAlertView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/26.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat cdHeight = 40;// cancel delete button高度
static CGFloat conHeight = 130;// 底部视图整体高度

#import "ECRBrebAlertView.h"

@interface ECRBrebAlertView ()
@property (strong,nonatomic) UIButton *closeButton;//
@property (strong,nonatomic) UIView *conView;//
@property (strong,nonatomic) UIImageView *icon;//
@property (strong,nonatomic) UILabel *infoText;//
@property (strong,nonatomic) UIButton *cancelBtn;//
@property (strong,nonatomic) UIButton *deleteBtn;//

@end

@implementation ECRBrebAlertView

- (void)setCountForRemove:(NSInteger)countForRemove{
    _countForRemove = countForRemove;
    // Are you sure you want to delete the selected %ld book?
    // 确定要删除选中的                                %ld 本书吗
    NSString *string_start = LOCALIZATION(@"确定要删除选中的");
    NSString *string_end = LOCALIZATION(@"本书吗?");
    self.infoText.text = [NSString stringWithFormat:@"%@%ld%@",string_start,countForRemove,string_end];
}

- (void)al_cancel:(UIButton *)sender{
    [self alClickEvent:NO];
}
- (void)al_delete:(UIButton *)sender{
    [self alClickEvent:YES];
}
- (void)alClickEvent:(BOOL)isDelete{
    if ([self.delegate respondsToSelector:@selector(brebAlert:clickEvent:)]) {
        [self.delegate brebAlert:self clickEvent:isDelete];
    }
}
- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.closeButton];
    [self addSubview:self.conView];
    [self.conView addSubview:self.icon];
    [self.conView addSubview:self.infoText];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.deleteBtn];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    [self.conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeButton.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(conHeight));
        make.bottom.equalTo(self.deleteBtn.mas_top);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conView.mas_top).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.infoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom);
//        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(self.width * 0.5));
        make.height.equalTo(@(cdHeight));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(self.width * 0.5));
        make.height.equalTo(@(cdHeight));
    }];
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

- (UIView *)conView{
    if (_conView == nil) {
        _conView = [[UIView alloc] init];
        _conView.backgroundColor = [UIColor colorWithRGB:0 alpha:0.45];
//        _conView.alpha = 0.45;
    }
    return _conView;
}
- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_trash_bookrack_white"]];
        
    }
    return _icon;
}
- (UILabel *)infoText{
    if (_infoText == nil) {
        _infoText = [[UILabel alloc] init];
        _infoText.textColor = [UIColor whiteColor];
        _infoText.textAlignment = NSTextAlignmentCenter;
        _infoText.numberOfLines = 0;
        _infoText.font = [UIFont systemFontOfSize:18];
    }
    return _infoText;
}
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"383838"]];
        [_cancelBtn setTitle:LOCALIZATION(@"取消") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(al_cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundColor:[UIColor colorWithHexString:@"b7292f"]];
        [_deleteBtn setTitle:LOCALIZATION(@"删除") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(al_delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [UIButton new];
//        _closeButton.alpha = 0.5;
//        _closeButton.backgroundColor = [UIColor orangeColor];
        [_closeButton addTarget:self action:@selector(al_cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
