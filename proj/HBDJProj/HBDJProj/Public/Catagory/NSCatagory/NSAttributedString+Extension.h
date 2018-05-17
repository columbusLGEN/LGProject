//
//  NSAttributedString+Extension.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Extension)
/**
 *  计算富文本字体高度
 *
 *  @param lineSpace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)heightForAttriibutedStringWithLineSpace:(CGFloat)lineSpace font:(UIFont*)font width:(CGFloat)width;

@end
