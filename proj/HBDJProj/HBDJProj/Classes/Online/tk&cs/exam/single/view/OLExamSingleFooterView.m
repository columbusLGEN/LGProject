//
//  OLExamSingleFooterView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleFooterView.h"

@interface OLExamSingleFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *last;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *next_mid;
@property (weak, nonatomic) IBOutlet UIButton *last_mid;

@end

@implementation OLExamSingleFooterView

- (IBAction)turnTo:(UIButton *)sender {
    
    BOOL canNext = NO;
    
    if (_selectSomeOption) {
        canNext = YES;
    }
    
    ExamTurnTo turnTo;
    if (sender.tag == 0) {
        /// 上一题
        turnTo = ExamTurnToLast;
    }else{
        turnTo = ExamTurnToNext;
    }
    /// 发送通知
    NSDictionary *userInfo = @{OLExamTurnQuestionNotificationIndexKey:@(self.currenIndex),
                               OLExamTurnQuestionNotificationTurnToKey:@(turnTo),
                               OLExamTurnQuestionNotificationCanNextKey:@(canNext)};
    [[NSNotificationCenter defaultCenter] postNotificationName:OLExamTurnQuestionNotification object:nil userInfo:userInfo];
}


- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    if (isFirst) {
        _last.hidden = YES;
        _next.hidden = YES;
        _next_mid.hidden = NO;
    }else{
        _last.hidden = NO;
        _next.hidden = NO;
        _next_mid.hidden = YES;
    }
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (_backLook) {
        if (!_isFirst) {
            if (isLast) {
                _last.hidden = YES;
                _next.hidden = YES;
                _last_mid.hidden = NO;
            }else{
                _last.hidden = NO;
                _next.hidden = NO;
                _last_mid.hidden = YES;
            }
        }else{
            _last_mid.hidden = YES;
        }
        
    }else{
        _last_mid.hidden = YES;
        if (isLast) {
            [_next setTitle:@"交卷" forState:UIControlStateNormal];
        }else{
            [_next setTitle:@"下一题" forState:UIControlStateNormal];
        }
        if (!_isFirst) {
            if (_tk && isLast) {
                /// 题库
                _last_mid.hidden = NO;
                _next.hidden = YES;
                _last.hidden = YES;
            }else{
                _last_mid.hidden = YES;
                _next.hidden = NO;
                _last.hidden = NO;
                
            }
        }
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cornerRadius = _last.height / 2;
    [_last cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:cornerRadius];
    [_last_mid cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:cornerRadius];
    [_next cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:cornerRadius];
    [_next_mid cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:cornerRadius];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_last setBackgroundColor:[UIColor whiteColor]];
    [_last setTitle:@"上一题" forState:UIControlStateNormal];
    [_last setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    
    [_last_mid setBackgroundColor:[UIColor whiteColor]];
    [_last_mid setTitle:@"上一题" forState:UIControlStateNormal];
    [_last_mid setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    
    [_next setBackgroundColor:[UIColor EDJMainColor]];
    [_next setTitle:@"下一题" forState:UIControlStateNormal];
    [_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_next_mid setBackgroundColor:[UIColor EDJMainColor]];
    [_next_mid setTitle:@"下一题" forState:UIControlStateNormal];
    [_next_mid setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _next_mid.hidden = YES;
}

+ (instancetype)examSingleFooter{
    return [[[NSBundle mainBundle] loadNibNamed:@"OLExamSingleFooterView" owner:nil options:nil] lastObject];
}

@end
