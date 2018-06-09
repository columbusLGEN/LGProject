//
//  LGRecordButtonLoader.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRecordButtonLoader : NSObject

+ (UIButton *)buttonWith:(NSString *)text frame:(CGRect)frame;
+ (void)addButtonTo:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action;

@end
