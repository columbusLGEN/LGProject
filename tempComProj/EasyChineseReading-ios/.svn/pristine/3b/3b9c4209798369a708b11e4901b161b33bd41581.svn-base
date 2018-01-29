//
//  UCRecommendMaskingView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendMaskingView.h"

#import "UCRBooksShopCarView.h"

@implementation UCRecommendMaskingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        // 添加下滑关闭手势
        UISwipeGestureRecognizer *downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        downGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:downGestureRecognizer];
    }
    return self;
}

- (void)dismissView
{
    [self.shoppingCarView dismissWithAnimated:YES];

}

@end
