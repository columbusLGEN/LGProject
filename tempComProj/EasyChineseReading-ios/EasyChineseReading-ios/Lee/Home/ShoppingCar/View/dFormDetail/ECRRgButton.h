//
//  ECRRgButton.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECRRgButton : UIView

@property (strong,nonatomic) UIButton *btn;//

@property (assign,nonatomic,getter = isSelected) BOOL selected;//
@property (copy,nonatomic) NSString *icNameNormal;//
@property (copy,nonatomic) NSString *icNameSelected;//
@property (copy,nonatomic) NSString *rgtlText;//
@property (strong,nonatomic) UIColor *rgtlTextColor;// 
@property (assign,nonatomic) CGFloat rgtlFont;//

@property (strong,nonatomic) UILabel *rgtLable;// 仅用于 外部字体对齐
/** 是否可以点击,YES:可以 NO:不可以 */
@property (assign,nonatomic) BOOL userCanCLick;//

@end
