//
//  ECRBookFloderLayout.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/9.
//  Copyright © 2017年 lee. All rights reserved.
//

//static CGFloat bookMargin = 10;
//static CGFloat bookSpace = 40;
static NSString * const kLXScrollingDirectionKey = @"LXScrollingDirection";

#import "ECRBookFloderLayout.h"
#import "ECRBookrackModel.h"

CG_INLINE CGPoint CGPointOffset(CGPoint point,CGFloat dx, CGFloat dy){
    return CGPointMake(point.x + dx, point.y + dy);
}

@interface ECRBookFloderLayout ()
@property (strong,nonatomic) UILongPressGestureRecognizer *sonLongPressGestureRecognizer;
@property (strong,nonatomic) UIPanGestureRecognizer *sonPanGestureRecognizer;
@property (assign,nonatomic) BOOL isOutOfFloder;//
@property (strong,nonatomic) ECRBookrackModel *currentModel;//
@property (assign,nonatomic) BOOL guardRepeat;//

@end

@implementation ECRBookFloderLayout

static NSString *kLECollectionViewKeyPath = @"collectionView";

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    UIWindow *kw = [UIApplication sharedApplication].keyWindow;
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
                ![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
            }
            
            self.selectedItemIndexPath = currentIndexPath;
            ECRBookrackCollectionViewCell *collectionViewCell = (ECRBookrackCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];
            self.currentModel = collectionViewCell.model;
            // MARK: 通知代理,进入编辑状态
            if ([self.flssDelegate respondsToSelector:@selector(brflayout:beginEditWithModel:doneBlock:)]) {
                if (self.isEdit) {
                }else{
                    self.isEdit = YES;
                }
                __weak ECRBookFloderLayout *weakSelf = self;
                [self.flssDelegate brflayout:self beginEditWithModel:collectionViewCell.model doneBlock:^{
                    // 用户退出编辑状态,执行此回调
                    weakSelf.isEdit = NO;
                }];
            }
            // MARK: 转换cell 至 uiwindow 的 frame
            CGRect deRect = [self.collectionView convertRect:collectionViewCell.frame toView:kw];
            self.currentView = [[UIView alloc] initWithFrame:deRect];
//            NSLog(@" ---- %@",NSStringFromCGRect(collectionViewCell.frame));
//            NSLog(@" ++++ %@",NSStringFromCGRect(deRect));
            /**
             deRect.x = collectionViewCell.frame.x + 10;
             deRect.y = collectionViewCell.frame.y + 136;
             */
            
            collectionViewCell.highlighted = YES;
            UIView *highlightedImageView = [collectionViewCell LX_snapshotView];
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            highlightedImageView.alpha = 1.0f;
            
            collectionViewCell.highlighted = NO;
            UIView *imageView = [collectionViewCell LX_snapshotView];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.alpha = 0.0f;
            
            [self.currentView addSubview:imageView];
            [self.currentView addSubview:highlightedImageView];
//            [self.collectionView addSubview:self.currentView];
            [kw addSubview:self.currentView];// 添加到window上才可以 “移出”collectionview
            
            self.currentViewCenter = self.currentView.center;
            
            __weak typeof(self) weakSelf = self;
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionBeginFromCurrentState
             animations:^{
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     strongSelf.currentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     highlightedImageView.alpha = 0.0f;
                     imageView.alpha = 1.0f;
                 }
             }
             completion:^(BOOL finished) {
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     [highlightedImageView removeFromSuperview];
                     
                     if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                         [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didBeginDraggingItemAtIndexPath:strongSelf.selectedItemIndexPath];
                     }
                 }
             }];
            
            [self invalidateLayout];
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *currentIndexPath = self.selectedItemIndexPath;
            
            if (currentIndexPath) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
                }
                
                self.selectedItemIndexPath = nil;
                self.currentViewCenter = CGPointZero;
                
                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];
                
                self.longPressGestureRecognizer.enabled = NO;
                
                __weak typeof(self) weakSelf = self;
                [UIView
                 animateWithDuration:0.3
                 delay:0.0
                 options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//                         strongSelf.currentView.center = layoutAttributes.center;
                         
                         CGPoint dePoint = [self.collectionView convertPoint:layoutAttributes.center toView:kw];
                         strongSelf.currentView.center = dePoint;
                     }
                 }
                 completion:^(BOOL finished) {
                     
                     self.longPressGestureRecognizer.enabled = YES;
                     
                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         [strongSelf.currentView removeFromSuperview];
                         strongSelf.currentView = nil;
                         [strongSelf invalidateLayout];
                         
                         if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                             [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didEndDraggingItemAtIndexPath:currentIndexPath];
                         }
                     }
                 }];
            }
        } break;
            
        default: break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
//    UIWindow *kw = [UIApplication sharedApplication].keyWindow;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            
            self.panTranslationInCollectionView = [gestureRecognizer translationInView:self.collectionView];
            CGPoint viewCenter = self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);

            [self panChanged:gestureRecognizer];
            [self invalidateLayoutIfNecessary];
            
//            switch (self.scrollDirection) {
//                case UICollectionViewScrollDirectionVertical: {
//                    if (viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
//                        [self setupScrollTimerInDirection:LXScrollingDirectionUp];
//                    } else {
//                        if (viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
//                            [self setupScrollTimerInDirection:LXScrollingDirectionDown];
//                        } else {
//                            [self invalidatesScrollTimer];
//                        }
//                    }
//                } break;
//                case UICollectionViewScrollDirectionHorizontal: {
//                    if (viewCenter.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.left)) {
//                        [self setupScrollTimerInDirection:LXScrollingDirectionLeft];
//                    } else {
//                        if (viewCenter.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.right)) {
//                            [self setupScrollTimerInDirection:LXScrollingDirectionRight];
//                        } else {
//                            [self invalidatesScrollTimer];
//                        }
//                    }
//                } break;
//            }
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self invalidatesScrollTimer];
        } break;
        default: {
            // Do nothing...
        } break;
    }
}

- (void)panChanged:(UIPanGestureRecognizer *)pan{
    
    // 当前view的center
    CGPoint point = [[UIApplication sharedApplication].keyWindow convertPoint:self.currentView.center toView:self.collectionView];
//    NSLog(@"%@",NSStringFromCGPoint(point));
    if (point.x < 0 ||
        point.y < 0 ||
        point.x > self.collectionView.width ||
        point.y > self.collectionView.height) {
        // 将书籍移出 文件夹范围
        /**
          通知控制器
             1.移除floder view
             2.向书架中添加该模型，并刷新UI
         */
        self.isOutOfFloder = YES;
        // MARK: 通知代理，删除文件夹内的书籍
        if (!self.guardRepeat) {// guardRepeat 确保只通知代理 一次
            if ([self.flssDelegate respondsToSelector:@selector(brflayout:outOfFloderWithModel:currentView:frame:)]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.flssDelegate brflayout:self outOfFloderWithModel:self.currentModel currentView:[self.currentView snapshotViewAfterScreenUpdates:YES] frame:self.currentView.frame];
                });
                self.guardRepeat = YES;
            }
        }
        
    }else{
        self.guardRepeat = NO;
        self.isOutOfFloder = NO;
    }
    
}

- (void)invalidateLayoutIfNecessary {
    if (!self.isOutOfFloder) {
        UIWindow *kw = [UIApplication sharedApplication].keyWindow;
        CGPoint oriPoint = [kw convertPoint:self.currentView.center toView:self.collectionView];
        NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:oriPoint];
        
        //    NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
        NSIndexPath *previousIndexPath = self.selectedItemIndexPath;
        
        if ((newIndexPath == nil) || [newIndexPath isEqual:previousIndexPath]) {
            return;
        }
        
        if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)] &&
            ![self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath canMoveToIndexPath:newIndexPath]) {
            return;
        }
        
        self.selectedItemIndexPath = newIndexPath;
        
        if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
            [self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath willMoveToIndexPath:newIndexPath];
        }
        
        __weak typeof(self) weakSelf = self;
        [self.collectionView performBatchUpdates:^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.collectionView deleteItemsAtIndexPaths:@[ previousIndexPath ]];
                [strongSelf.collectionView insertItemsAtIndexPaths:@[ newIndexPath ]];
            }
        } completion:^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
                [strongSelf.dataSource collectionView:strongSelf.collectionView itemAtIndexPath:previousIndexPath didMoveToIndexPath:newIndexPath];
            }
        }];
    }
}

- (void)handleScroll:(CADisplayLink *)displayLink {
    LXScrollingDirection direction = (LXScrollingDirection)[displayLink.LX_userInfo[kLXScrollingDirectionKey] integerValue];
    if (direction == LXScrollingDirectionUnknown) {
        return;
    }
    
    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    // Important to have an integer `distance` as the `contentOffset` property automatically gets rounded
    // and it would diverge from the view's center resulting in a "cell is slipping away under finger"-bug.
    CGFloat distance = rint(self.scrollingSpeed * displayLink.duration);
    CGPoint translation = CGPointZero;
    
    switch(direction) {
        case LXScrollingDirectionUp: {
            distance = -distance;
            CGFloat minY = 0.0f - contentInset.top;
            
            if ((contentOffset.y + distance) <= minY) {
                distance = -contentOffset.y - contentInset.top;
            }
            
            translation = CGPointMake(0.0f, distance);
        } break;
        case LXScrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;
            
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            
            translation = CGPointMake(0.0f, distance);
        } break;
        case LXScrollingDirectionLeft: {
            distance = -distance;
            CGFloat minX = 0.0f - contentInset.left;
            
            if ((contentOffset.x + distance) <= minX) {
                distance = -contentOffset.x - contentInset.left;
            }
            
            translation = CGPointMake(distance, 0.0f);
        } break;
        case LXScrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width + contentInset.right;
            
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            
            translation = CGPointMake(distance, 0.0f);
        } break;
        default: {
            // Do nothing...
        } break;
    }
    
//    self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, translation);
//    self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
    self.collectionView.contentOffset = LXS_CGPointAdd(contentOffset, translation);
}

- (CGSize)itemSize{
    CGSize custemSize;
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // pad
//        custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 3) / 4, 228);//
//        custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 3) / 4, 228);//
        custemSize = CGSizeMake(137, 228);//
    }else{
        // phone
        if (Screen_Width < 375) {
            custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace) / 3, 150);//
        }else if(Screen_Width == 375){
            custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 2) / 3, 150);//
        }else{//  if(Screen_Width == 414)
            custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 2) / 3, 180);//
        }
    }
    return custemSize;
}


@end


/** 坐标系转换代码改变
  code change line
         58
         73
         130
         163
         228
         324
 */
