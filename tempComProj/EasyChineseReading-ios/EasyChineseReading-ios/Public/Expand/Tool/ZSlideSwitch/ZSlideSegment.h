//
//  ZSlideSegment.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSlideSegmentDelegate <NSObject>

- (void)slideSegmentDidSelectedAtIndex:(NSInteger)index;

@end

@interface ZSlideSegment : UIView

@property (assign, nonatomic) NSInteger selectedIndex;

@property (assign, nonatomic) NSInteger nextIndex;

@property (strong, nonatomic) NSArray *arrTitles;

@property (strong, nonatomic) UIColor *normalColor;

@property (strong, nonatomic) UIColor *selectedColor;

@property (strong, nonatomic) UIColor *cm_backgroundColor;

@property (assign, nonatomic) BOOL showTitlesInNavBar;

@property (assign, nonatomic) BOOL hideShadow;

@property (weak, nonatomic) id<ZSlideSegmentDelegate> delegate;

@property (assign, nonatomic) CGFloat progress;

@property (assign, nonatomic) BOOL canScroll; // 是否能滚动

@property (assign, nonatomic) BOOL needCenter; // 当标题少的时候 是否需要居中

@property (strong, nonatomic) UICollectionView *collectionView;

//忽略动画
@property (assign, nonatomic) BOOL ignoreAnimation;

@end
