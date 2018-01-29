//
//  LGCartIcon.h
//  RGTestPorject
//
//  Created by Peanut Lee on 2017/12/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGCartIcon : UIView
/** 购物车数量 */
@property (assign,nonatomic) NSInteger cartCount;
/** 购物车按钮 */
@property (strong,nonatomic) UIButton *button;
/** 图标imageName */
@property (copy,nonatomic) NSString *iconImgName;

@end
