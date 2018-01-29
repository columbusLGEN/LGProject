//
//  GuideFigureImageView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2018/1/10.
//  Copyright © 2018年 retech. All rights reserved.
//

#import "GuideFigureImageView.h"

@implementation GuideFigureImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    // 添加点击消失手势
    UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeGuideFigure)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapImageView];
    
    return self;
}

// 根据标签及设备型号设置引导图
- (void)setItemIndex:(NSInteger)itemIndex
{
    _itemIndex = itemIndex;
    BOOL iPhoneX = [IPhoneVersion deviceVersion] == iphoneX;
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_guide_figure_%ld_%@", _itemIndex, isPad ? @"pad" : (iPhoneX ? @"phoneX" : @"phone")]];
}

// 关闭引导图
- (void)closeGuideFigure
{
    if (0 == _itemIndex)
        [[CacheDataSource sharedInstance] setCache:@"YES" withCacheKey:CacheKey_NotFirstTimeBookStore];
    else if (1 == _itemIndex)
        [[CacheDataSource sharedInstance] setCache:@"YES" withCacheKey:CacheKey_NotFirstTimeBookShelf];
    else
        [[CacheDataSource sharedInstance] setCache:@"YES" withCacheKey:CacheKey_NotFirstTimeMe];
    
    [self removeFromSuperview];
}

@end
