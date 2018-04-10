//
//  EDJMicroLessonHeaderView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDJMicroLessonHeaderView;

@protocol EDJMicroLessonHeaderViewDelegate <NSObject>

- (void)mlHeaderClick:(EDJMicroLessonHeaderView *)header segment:(NSInteger)segment;

@end

@interface EDJMicroLessonHeaderView : UIView

+ (instancetype)mlHeaderViewWithDelegate:(id<EDJMicroLessonHeaderViewDelegate>) delegat frame:(CGRect)frame;
@property (weak,nonatomic) id<EDJMicroLessonHeaderViewDelegate> delegate;

@end
