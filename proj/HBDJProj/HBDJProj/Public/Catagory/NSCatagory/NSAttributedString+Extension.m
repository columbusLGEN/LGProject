//
//  NSAttributedString+Extension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

/**
 *  计算富文本字体高度
 *
 *  @param lineSpace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
- (CGFloat)heightForAttriibutedStringWithLineSpace:(CGFloat)lineSpace font:(UIFont*)font width:(CGFloat)width {
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    /** 行高 */
//    paraStyle.lineSpacing = lineSpace;
////     NSKernAttributeName字体间距
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//                          };
    
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

@end
