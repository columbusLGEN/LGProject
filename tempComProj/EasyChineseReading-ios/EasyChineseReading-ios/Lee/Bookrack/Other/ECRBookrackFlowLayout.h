//
//  ECRBookrackFlowLayout.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseCollectionFlowLayout.h"
#import "ECRBookrackCollectionViewCell.h"

@class ECRBookrackFlowLayout,ECRBookrackModel;

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
LXS_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

typedef NS_ENUM(NSInteger, LXScrollingDirection) {
    LXScrollingDirectionUnknown = 0,
    LXScrollingDirectionUp,
    LXScrollingDirectionDown,
    LXScrollingDirectionLeft,
    LXScrollingDirectionRight
};


@protocol LXReorderableCollectionViewDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

// lee
- (void)collectionView:(UICollectionView *)collectionView deleteItemAndModelAtIndexPath:(NSIndexPath *)fromIndexPath insertModel:(ECRBookrackModel *)model toIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol LXReorderableCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ECRBookrackFlowLayoutSwitchStateDelegate <NSObject>

- (void)brflayout:(ECRBookrackFlowLayout *)flowLayout beginEditWithModel:(ECRBookrackModel *)model doneBlock:(void(^)())doneBlock;
- (void)brflayout:(ECRBookrackFlowLayout *)flowLayout outOfFloderWithModel:(ECRBookrackModel *)model currentView:(UIView *)currentView frame:(CGRect)frame;

@end

@interface CADisplayLink (LX_userInfo)
@property (nonatomic, copy) NSDictionary *LX_userInfo;
@end
@interface UICollectionViewCell (LXReorderableCollectionViewFlowLayout)
- (UIView *)LX_snapshotView;
@end

@interface ECRBookrackFlowLayout : ECRBaseCollectionFlowLayout<
UIGestureRecognizerDelegate
>

@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, nonatomic) UIEdgeInsets scrollingTriggerEdgeInsets;
@property (assign, nonatomic) CGFloat scrollingSpeed;

@property (weak,nonatomic) id<ECRBookrackFlowLayoutSwitchStateDelegate> flssDelegate;

- (CGSize)custemSize;

// 子类需要继承的方法 和 属性
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)invalidateLayoutIfNecessary;
- (id<LXReorderableCollectionViewDataSource>)dataSource;
- (id<LXReorderableCollectionViewDelegateFlowLayout>)delegate;
- (void)setupScrollTimerInDirection:(LXScrollingDirection)direction;
- (void)invalidatesScrollTimer;
- (void)tearDownCollectionView;
- (void)handleScroll:(CADisplayLink *)displayLink;

@property (assign,nonatomic) NSInteger currentPlace;// 1 = 全部图书，2 = 已购买
@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) BOOL isEdit;// 如果 == 1,表明处于编辑状态, 可以进行编辑

@end

