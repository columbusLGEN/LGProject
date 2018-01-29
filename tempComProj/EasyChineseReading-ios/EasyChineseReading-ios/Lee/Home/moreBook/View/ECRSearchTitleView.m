//
//  ECRSearchTitleView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

static CGFloat txtFont = 16;// 搜索框字体size
static CGFloat txtH    = 35;

#import "ECRSearchTitleView.h"

@interface ECRSearchTitleView ()<UITextFieldDelegate>
@property (strong,nonatomic) UITextField *searchTField;// 搜索框
@property (strong,nonatomic) UIView      *conView;//
@property (strong,nonatomic) UIButton    *closeButton;// 关闭
@property (strong,nonatomic) UIView      *line;// 底部线条

@end

@implementation ECRSearchTitleView

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.charLength > cMaxSearchLength) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"搜索"), LOCALIZATION(@"字符长度为"), cMaxSearchLength]];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(stView:content:)]) {
            [self.delegate stView:self content:textField.text];
        }
    }
    return YES;
}

//- (void)searchTextChanged:(NSNotification *)notification{
//    UITextField *object = notification.object;
//    if ([self.delegate respondsToSelector:@selector(stView:content:)]) {
//        [self.delegate stView:self content:object.text];
//    }
//}

- (void)lg_becomResponser {
    [_searchTField becomeFirstResponder];
}

- (void)closeClick:(UIButton *)sender{
    // MARK 关闭搜索
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(stViewClose:)]) {
        [self.delegate stViewClose:self];
    }
}

- (void)setLg_placeHolder:(NSString *)lg_placeHolder{
    _lg_placeHolder               = lg_placeHolder;
    // 修改占位文字
    self.searchTField.placeholder = lg_placeHolder;
    
}

- (void)setWhiteLine
{
    _line.backgroundColor   = [UIColor whiteColor];
    _searchTField.textColor = [UIColor whiteColor];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"icon_search_close_white"]
                            forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.searchTField];
        [self addSubview:self.conView];
        [self.conView addSubview:self.closeButton];
        [self addSubview:self.line];
        
        CGFloat conViewW = 40;
        [_searchTField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left   .equalTo(self.mas_left).offset(0);
            make.centerY.equalTo(self.mas_centerY);
            make.width  .equalTo(@(self.width - conViewW - 10));
            make.height .equalTo(@(txtH));
        }];
        [_conView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_searchTField.mas_right);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(conViewW));
            make.height.equalTo(@(conViewW));
        }];
        [_closeButton  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_conView.mas_centerX);
            make.centerY.equalTo(_conView.mas_centerY);
//            make.right  .equalTo(self.mas_right).offset(-marginH);
//            make.height .equalTo(@(btnH));
        }];
        [_line         mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top   .equalTo(_searchTField.mas_bottom).offset(-5);
            make.left  .equalTo(_searchTField.mas_left);
            make.right .equalTo(_searchTField.mas_right);
            make.height.equalTo(@1);
//            make.bottom.equalTo(self.mas_bottom);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
//        NSLog(@"subviews: %@",self.subviews);
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
        [self setWhiteLine];
    }
    return self;
}

// MARK: lazy load
- (UITextField *)searchTField{
    if (_searchTField           == nil) {
        _searchTField           = [[UITextField alloc] init];
        _searchTField.textColor = [UIColor colorWithHexString:@"666666"];
        _searchTField.font      = [UIFont systemFontOfSize:txtFont];
        _searchTField.returnKeyType = UIReturnKeySearch;
        _searchTField.delegate = self;
//        _searchTField.backgroundColor = [UIColor orangeColor];
//        _searchTField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _searchTField;
}
- (UIView *)conView{
    if (_conView == nil) {
        _conView = [[UIView alloc] init];
//        _conView.userInteractionEnabled = YES;
//        _conView.backgroundColor = [UIColor orangeColor];
    }
    return _conView;
}
- (UIButton *)closeButton{
    if (_closeButton  == nil) {
        _closeButton  = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"icon_search_close"]
                                                     forState:UIControlStateNormal];
        
        [_closeButton addTarget:self
                         action:@selector(closeClick:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIView *)line{
    if (_line == nil) {
        _line                 = [[UIView alloc] init];
        _line.backgroundColor =  LGColor_78005e;//[UIColor colorR:0x78 g:00 b:0x5e a:1];// 78005E
    }
    return _line;
}



@end
