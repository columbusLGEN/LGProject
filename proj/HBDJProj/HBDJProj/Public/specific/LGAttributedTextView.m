//
//  LGAttributedTextView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGAttributedTextView.h"

@implementation LGAttributedTextView


//- (BOOL)canBecomeFirstResponder{
//    return YES;
//}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    NSArray* methodNameArr = @[@"copy:",@"cut:",@"select:",@"selectAll:",@"paste:"];
//    if ([methodNameArr containsObject:NSStringFromSelector(action)]) {
//        return YES;
//    }
//    return [super canPerformAction:action withSender:sender];
//}
//-(void)copy:(id)sender{
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//
//    
//}
//
//-(void)paste:(id)sender{
//    //    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
//    
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
////    UIMenuController *menuController = [UIMenuController sharedMenuController];
////
////    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyBtnPressed:)];
////
////    menuController.menuItems = @[copyItem];
////
////    [menuController setTargetRect:CGRectMake(0, 100, 20, 100) inView:self];
////
////    [menuController setMenuVisible:YES animated:YES];
////
////    [UIMenuController sharedMenuController].menuItems=nil;
//    UIMenuController * menu = [UIMenuController sharedMenuController];
//    //尺寸和添加到哪里
//    [menu setTargetRect: [self frame] inView: self];
//    [menu setMenuVisible: YES animated: YES];
//
//
//}
//
//- (void)longPress:(UILongPressGestureRecognizer *)reco{
//    
//    CGPoint touchPoint = [reco locationOfTouch:0 inView:reco.view];
//    NSLog(@"touchPoint: %@",NSStringFromCGPoint(touchPoint));
//
////    NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>)
////    [[NSString alloc] init] substringWithRange:<#(NSRange)#>
//}
//
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer.alloc initWithTarget:self action:@selector(longPress:)];
//        [self addGestureRecognizer:longPress];
//    }
//    return self;
//}

@end
