//
//  ECRBookrackFlowLayout.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//


#import "ECRBookrackFlowLayout.h"
#import "ECRBookrackModel.h"

@implementation CADisplayLink (LX_userInfo)
- (void) setLX_userInfo:(NSDictionary *) LX_userInfo {
    objc_setAssociatedObject(self, "LX_userInfo", LX_userInfo, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *) LX_userInfo {
    return objc_getAssociatedObject(self, "LX_userInfo");
}
@end


@implementation UICollectionViewCell (LXReorderableCollectionViewFlowLayout)

- (UIView *)LX_snapshotView {
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return [self snapshotViewAfterScreenUpdates:YES];
    } else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return [[UIImageView alloc] initWithImage:image];
    }
}

@end

@interface ECRBookrackFlowLayout ()

@property (strong, nonatomic) ECRBookrackCollectionViewCell *previousCell;//
@property (strong, nonatomic) ECRBookrackCollectionViewCell *currentLocalCell;// 拖动中的书下方的cell
@property (assign, nonatomic) BOOL inTouchIsBook;

@property (strong,nonatomic) NSIndexPath *originIndexPath;//
@property (strong,nonatomic) NSIndexPath *destinationIndexPath;// 终点索引


@end

static NSString * const kLXScrollingDirectionKey = @"LXScrollingDirection";
static NSString *kLECollectionViewKeyPath = @"collectionView";

@implementation ECRBookrackFlowLayout

// 拖动手势
- (void)panChange:(UIPanGestureRecognizer *)pan{
    if (_inTouchIsBook) {// 此时需要判断 底下cell的model类型
        NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
        ECRBookrackCollectionViewCell *newIndexPathCell = (ECRBookrackCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:newIndexPath];
        self.currentLocalCell = newIndexPathCell;
        
//        NSLog(@"%ld",newIndexPath.item);// 此处的newindex正确
        
    }else{// 当前拖动的是文件夹,一切默认
        [self invalidateLayoutIfNecessary];
    }
}
- (void)panEnded:(UIPanGestureRecognizer *)pan{
    if (self.currentLocalCell == nil) {// 没有移动
        
    }else{
        if (_inTouchIsBook) {// 此时需要判断 底下cell的model类型
            // 获取底下的cell
            NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
            NSIndexPath *previousIndexPath = self.selectedItemIndexPath;
            
            if ((newIndexPath == nil) || [newIndexPath isEqual:previousIndexPath]) {
                return;// 移动回到了自己的初始位置
            }
            self.destinationIndexPath = newIndexPath;
            // 合并数据
            ECRBookrackModel *floder;
            if (self.currentPlace == 1) {// 全部图书
                if (self.currentLocalCell.model.books.count != 0) {// 文件夹
                    [self.currentLocalCell.model addBooksWithFromModel:self.previousCell.model currentPlace:self.currentPlace];
                }else{
                    // 创建一个新的对象,使用代理将其传给控制器
                    floder = [[ECRBookrackModel alloc] init];
                    floder.owendType = self.previousCell.model.owendType;
                    floder.currentPlace = self.currentPlace;
                    floder.name = @"分组";// TODO: 文件夹默认名字根据已有文件夹数量变化
                    [floder createGroupWithFromModel:self.previousCell.model toModel:self.currentLocalCell.model currentPlace:self.currentPlace];
                }
            }
            if (self.currentPlace == 2) {// 已购买
                if (self.currentLocalCell.model.alreadyBuyBooks.count != 0) {// 文件夹
                    [self.currentLocalCell.model addBooksWithFromModel:self.previousCell.model currentPlace:self.currentPlace];
                }else{
                    // 创建一个新的对象,使用代理将其传给控制器
                    floder = [[ECRBookrackModel alloc] init];
                    floder.owendType = self.previousCell.model.owendType;
                    floder.currentPlace = self.currentPlace;
                    floder.name = @"分组";// TODO: 文件夹默认名字根据已有文件夹数量变化
                    [floder createGroupWithFromModel:self.previousCell.model toModel:self.currentLocalCell.model currentPlace:self.currentPlace];
                }
            }
            
            // 更新UI
            // 删除previous cell and 模型, 刷新页面
            if ([self.dataSource respondsToSelector:@selector(collectionView:deleteItemAndModelAtIndexPath:insertModel:toIndexPath:)]) {
                [self.dataSource collectionView:self.collectionView deleteItemAndModelAtIndexPath:self.previousCell.inx insertModel:floder toIndexPath:self.currentLocalCell.inx];
            }
            
            // MARK: 替代 reloadData
            __weak typeof(self) weakSelf = self;
            [UIView setAnimationsEnabled:NO];
            [self.collectionView performBatchUpdates:^{// 执行 finalLayoutAttributesForDisappearingItemAtIndexPath
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
//                    [strongSelf.collectionView deleteItemsAtIndexPaths:@[ previousIndexPath ]];
//                    [strongSelf.collectionView insertItemsAtIndexPaths:@[ newIndexPath ]];
                    [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                }
            } completion:^(BOOL finished) {
//                __strong typeof(self) strongSelf = weakSelf;
//                if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
//                    [strongSelf.dataSource collectionView:strongSelf.collectionView itemAtIndexPath:previousIndexPath didMoveToIndexPath:newIndexPath];
//                }
                [UIView setAnimationsEnabled:YES];
            }];
            
        }else{
            // 当前拖动的是文件夹,一切默认, 结束时 不执行任何操作
            
        }
    }
    self.currentLocalCell = nil;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {// MARK: 移动执行顺序1 long press begin
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
                ![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
            }
            
            self.selectedItemIndexPath = currentIndexPath;
            self.originIndexPath = currentIndexPath;
            
            ECRBookrackCollectionViewCell *collectionViewCell = (ECRBookrackCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];
            
            self.previousCell = collectionViewCell;
            
            // 判断 当前模型是 书还是 文件夹
            if (self.currentPlace == 1) {// 全部图书
                if (collectionViewCell.model.books.count != 0) {// 文件夹
                    _inTouchIsBook = NO;
                }else{
                    _inTouchIsBook = YES;
                }
            }
            if (self.currentPlace == 2) {// 已购买
                if (collectionViewCell.model.alreadyBuyBooks.count != 0) {// 文件夹
                    _inTouchIsBook = NO;
                }else{
                    _inTouchIsBook = YES;
                }
            }
            
            
            // MARK: 通知代理,进入编辑状态
            if ([self.flssDelegate respondsToSelector:@selector(brflayout:beginEditWithModel:doneBlock:)]) {
                if (self.isEdit) {
                }else{
                    self.isEdit = YES;
                }
                __weak ECRBookrackFlowLayout *weakSelf = self;
                [self.flssDelegate brflayout:self beginEditWithModel:collectionViewCell.model doneBlock:^{
                    // 用户退出编辑状态,执行此回调
                    weakSelf.isEdit = NO;
                }];
            }
            
            self.currentView = [[UIView alloc] initWithFrame:collectionViewCell.frame];
            
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
            [self.collectionView addSubview:self.currentView];
            
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
        case UIGestureRecognizerStateEnded: {// MARK: 移动执行顺序3 long press end
            NSIndexPath *currentIndexPath = self.selectedItemIndexPath;
            if (currentIndexPath) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
                }

                self.selectedItemIndexPath = nil;// 此处为什么要将 self.selectedItemIndexPath 至为nil
                self.currentViewCenter = CGPointZero;
                
                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];
                
                self.longPressGestureRecognizer.enabled = NO;
                
                __weak typeof(self) weakSelf = self;
                
                BOOL localCellIsCurrentCell = (self.currentLocalCell.inx.item == currentIndexPath.item);
                
                [UIView
                 animateWithDuration:0.3
                 delay:0.0
                 options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         if (!_inTouchIsBook || localCellIsCurrentCell || self.currentLocalCell == nil) {
                             strongSelf.currentView.center = layoutAttributes.center;
                         }else{
                             if (strongSelf.originIndexPath.item < strongSelf.currentLocalCell.inx.item) {// 向后合并
                                 // 获取前一个cell 的 indexpath
                                 NSInteger poccItem = strongSelf.currentLocalCell.inx.item - 1;
                                 NSIndexPath *poccIndex = [NSIndexPath indexPathForItem:poccItem inSection:0];
                                 // 获取前一个cell
                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                     UICollectionViewCell *pocCell = [strongSelf.collectionView cellForItemAtIndexPath:poccIndex];// 一定要在主线程获取
                                     //                                     NSLog(@"cell -- %@",pocCell);
                                     strongSelf.currentView.center = pocCell.center;
                                 }];
                                 
                             }else{// 向前合并
                                 strongSelf.currentView.center = strongSelf.currentLocalCell.center;//
                             }
                             strongSelf.currentView.alpha = 0;
                         }
                         
//                         if (_inTouchIsBook && strongSelf.currentLocalCell != nil) {
//                             if (strongSelf.originIndexPath.item < strongSelf.currentLocalCell.inx.item) {// 向后合并
//                                 // 获取前一个cell 的 indexpath
//                                 NSInteger poccItem = strongSelf.currentLocalCell.inx.item - 1;
//                                 NSIndexPath *poccIndex = [NSIndexPath indexPathForItem:poccItem inSection:0];
//                                 // 获取前一个cell
//                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                                     UICollectionViewCell *pocCell = [strongSelf.collectionView cellForItemAtIndexPath:poccIndex];// 一定要在主线程获取
////                                     NSLog(@"cell -- %@",pocCell);
//                                     strongSelf.currentView.center = pocCell.center;
//                                 }];
//
//                             }else{// 向前合并
//                                 strongSelf.currentView.center = strongSelf.currentLocalCell.center;//
//                             }
//                             strongSelf.currentView.alpha = 0;
//                         }else{
//                             strongSelf.currentView.center = layoutAttributes.center;
//                         }
                         
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
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {// MARK: 移动执行顺序2 pan change
            self.panTranslationInCollectionView = [gestureRecognizer translationInView:self.collectionView];
            CGPoint viewCenter = self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
            
//            [self invalidateLayoutIfNecessary];
            [self panChange:gestureRecognizer];
            
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    if (viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
                        [self setupScrollTimerInDirection:LXScrollingDirectionUp];
                    } else {
                        if (viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
                            [self setupScrollTimerInDirection:LXScrollingDirectionDown];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
                case UICollectionViewScrollDirectionHorizontal: {
                    if (viewCenter.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.left)) {
                        [self setupScrollTimerInDirection:LXScrollingDirectionLeft];
                    } else {
                        if (viewCenter.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.right)) {
                            [self setupScrollTimerInDirection:LXScrollingDirectionRight];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
            }
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {// MARK: 移动执行顺序4 pan end
            [self panEnded:gestureRecognizer];// 结束pan
            [self invalidatesScrollTimer];
        } break;
        default: {
            // Do nothing...
        } break;
    }
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return (self.selectedItemIndexPath != nil);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.longPressGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.panGestureRecognizer isEqual:otherGestureRecognizer];
    }
    
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.longPressGestureRecognizer isEqual:otherGestureRecognizer];
    }
    
    return NO;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
        layoutAttributes.hidden = YES;
    }
}

- (void)invalidateLayoutIfNecessary {
    NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
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

- (void)setupScrollTimerInDirection:(LXScrollingDirection)direction {
    if (!self.displayLink.paused) {
        LXScrollingDirection oldDirection = [self.displayLink.LX_userInfo[kLXScrollingDirectionKey] integerValue];
        
        if (direction == oldDirection) {
            return;
        }
    }
    
    [self invalidatesScrollTimer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
    self.displayLink.LX_userInfo = @{ kLXScrollingDirectionKey : @(direction) };
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invalidatesScrollTimer {
    if (!self.displayLink.paused) {
        [self.displayLink invalidate];
    }
    self.displayLink = nil;
}

- (id<LXReorderableCollectionViewDataSource>)dataSource {
    return (id<LXReorderableCollectionViewDataSource>)self.collectionView.dataSource;
}

- (id<LXReorderableCollectionViewDelegateFlowLayout>)delegate {
    return (id<LXReorderableCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
}

#pragma mark - UICollectionViewLayout overridden methods

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        switch (layoutAttributes.representedElementCategory) {
            case UICollectionElementCategoryCell: {
                [self applyLayoutAttributes:layoutAttributes];
            } break;
            default: {
                // Do nothing...
            } break;
        }
    }
    
    return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    switch (layoutAttributes.representedElementCategory) {
        case UICollectionElementCategoryCell: {
            [self applyLayoutAttributes:layoutAttributes];
        } break;
        default: {
            // Do nothing...
        } break;
    }
    
    return layoutAttributes;
}

#pragma mark - Key-Value Observing methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kLECollectionViewKeyPath]) {
        if (self.collectionView != nil) {
            // 给collectionview 添加手势
            [self setupCollectionView];
        }else{
            //
            [self invalidatesScrollTimer];
            [self tearDownCollectionView];
        }
    }
}

- (void)tearDownCollectionView {
    // Tear down long press gesture
    if (_longPressGestureRecognizer) {
        UIView *view = _longPressGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer.delegate = nil;
        _longPressGestureRecognizer = nil;
    }
    
    // Tear down pan gesture
    if (_panGestureRecognizer) {
        UIView *view = _panGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer.delegate = nil;
        _panGestureRecognizer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}
CGFloat scSpeed = 300.0f;
- (instancetype)init{
    if (self = [super init]) {
        _scrollingSpeed = scSpeed;
        self.isEdit = NO;
        [self addObserver:self forKeyPath:kLECollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _scrollingSpeed = scSpeed;
        self.isEdit = NO;
        [self addObserver:self forKeyPath:kLECollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:kLECollectionViewKeyPath];
}

- (void)handleApplicationWillResignActive:(NSNotification *)notification {
    self.panGestureRecognizer.enabled = NO;
    self.panGestureRecognizer.enabled = YES;
}

- (void)setupCollectionView{
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    _longPressGestureRecognizer.delegate = self;
    
    // Links the default long press gesture recognizer to the custom long press gesture recognizer we are creating now
    // by enforcing failure dependency so that they doesn't clash.
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handlePanGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
    
    // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name: UIApplicationWillResignActiveNotification object:nil];
}

// Tight loop, allocate memory sparely, even if they are stack allocation.
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
    
    self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, translation);
    self.currentView.center = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
    self.collectionView.contentOffset = LXS_CGPointAdd(contentOffset, translation);
}

@end
