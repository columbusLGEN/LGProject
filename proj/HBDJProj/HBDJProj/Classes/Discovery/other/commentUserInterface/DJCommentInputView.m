//
//  DJCommentInputView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJCommentInputView.h"
#import "UITextView+Extension.h"

@interface DJCommentInputView ()
@property (weak,nonatomic) UITextView *input;
@property (weak,nonatomic) UIButton *cancel;
@property (weak,nonatomic) UIButton *done;

@end

@implementation DJCommentInputView

- (void)layoutSubviews{
    [super layoutSubviews];
    [_cancel cutBorderWithBorderWidth:1 borderColor:UIColor.EDJGrayscale_F3 cornerRadius:0];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UITextView *input = UITextView.new;
        _input = input;
        NSInteger font = 17;
        _input.font = [UIFont systemFontOfSize:font];
        [_input lg_setplaceHolderTextWithText:@"请输入您要评论的内容" textColor:UIColor.EDJGrayscale_A4 font:font];
        _input.backgroundColor = UIColor.EDJColor_FFF5F5;
        [self addSubview:_input];
        
        UIButton *cancel = UIButton.new;
        _cancel = cancel;
        [_cancel setTitleColor:UIColor.EDJGrayscale_11 forState:UIControlStateNormal];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        [self addSubview:_cancel];
        
        UIButton *done = UIButton.new;
        _done = done;
        [_done setBackgroundColor:UIColor.EDJMainColor];
        [_done setTitle:@"发送" forState:UIControlStateNormal];
        [self addSubview:_done];
        
        [_input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(marginTwenty);
            make.left.equalTo(self.mas_left).offset(marginTwenty);
            make.right.equalTo(self.mas_right).offset(-marginTwenty);
            make.bottom.equalTo(_cancel.mas_top).offset(-marginTwenty);
        }];
        
        [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(_done.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(50);
            make.width.equalTo(_done.mas_width);
        }];
        
        [_done mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(_cancel.mas_height);
            make.width.equalTo(_done.mas_width);
        }];
        
    }
    return self;
}

@end
