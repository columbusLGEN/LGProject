//
//  ECRTopupFieldView.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//
// 充值框封装

#import "ECRBaseView.h"

@interface ECRTopupFieldView : ECRBaseView

@property (strong,nonatomic) UITextField *textField;        //
@property (copy,nonatomic) NSString *textFieldTitle_test;//
@property (copy,nonatomic) NSString *buttonTitle;        //
@property (assign,nonatomic) CGFloat textFontSize;           //

@end
