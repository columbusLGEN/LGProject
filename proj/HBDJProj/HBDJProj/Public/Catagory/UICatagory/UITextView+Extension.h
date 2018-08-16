//
//  UITextView+Extension.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)

/** UITextView 添加占位文字 */
- (void)lg_setplaceHolderTextWithText:(NSString *)text textColor:(UIColor *)color font:(NSInteger)font;

@end
