//
//  ZSlideSegment.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ZSlideSegment.h"
#import "ZSlideSegmentCollectionViewCell.h"

//item间隔
static const CGFloat kItemSpace = 30.f;
//button标题选中大小
static const CGFloat kItemFontSize = 16.f;
//最大放大倍数
static const CGFloat kItemMaxScale = 1.0f;

static const CGFloat kShadowHeight = 2.f;

@interface ZSlideSegment ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIView *_bottomLine;
    UIView *_shadow;
}

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSString *selectedTitle;

@end

@implementation ZSlideSegment

- (instancetype)init {
    if (self = [super init]) {
        [self configSegmentView];
    }
    return self;
}

- (void)configSegmentView {
    
    self.backgroundColor = [UIColor redColor] ? _cm_backgroundColor : nil;
    [self addSubview:[UIView new]];
    [self addSubview:self.collectionView];
    _selectedIndex = 0;
    _shadow = [[UIView alloc] init];
    [_collectionView addSubview:_shadow];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    _bottomLine.frame = CGRectMake(0, _collectionView.height - 0.5, self.width, 0.5);
    [self addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    
    if (_needCenter) {
        //如果标题过少 自动居中
        [_collectionView performBatchUpdates:nil completion:^(BOOL finished) {
            if (_collectionView.contentSize.width < _collectionView.bounds.size.width) {
                CGFloat insetX = (_collectionView.bounds.size.width - _collectionView.contentSize.width)/2.0f;
                _collectionView.contentInset = UIEdgeInsetsMake(0, insetX, 0, insetX);
            }
        }];
    }
    //设置阴影
    _shadow.backgroundColor = _selectedColor;
    self.selectedIndex = _selectedIndex;
    _shadow.hidden = _hideShadow;
}

#pragma mark -
#pragma mark Setter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    _selectedTitle = _arrTitles[_selectedIndex];
    //更新阴影位置（延迟是为了避免cell不在屏幕上显示时，造成的获取frame失败问题）
    CGFloat rectX = [self shadowRectOfIndex:_selectedIndex].origin.x;
    if (rectX <= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            _shadow.frame = [self shadowRectOfIndex:_selectedIndex];
        });
    }else{
        _shadow.frame = [self shadowRectOfIndex:_selectedIndex];
    }
    if (_canScroll) {
        //居中滚动标题
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    //更新字体大小
    [_collectionView reloadData];
    
    //执行代理方法
    if ([_delegate respondsToSelector:@selector(slideSegmentDidSelectedAtIndex:)]) {
        [_delegate slideSegmentDidSelectedAtIndex:_selectedIndex];
    }
}

- (void)setShowTitlesInNavBar:(BOOL)showTitlesInNavBar {
    _showTitlesInNavBar = showTitlesInNavBar;
    self.backgroundColor = [UIColor whiteColor];
    _bottomLine.hidden = true;
    _shadow.hidden = true;
}

//更新阴影位置
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    //如果手动点击则不执行以下动画
    if (_ignoreAnimation) {return;}
    //更新阴影位置
    [self updateShadowPosition:progress];
    //更新标题颜色、大小
    [self updateItem:progress];
}

#pragma mark - 执行阴影过渡动画
//更新阴影位置
- (void)updateShadowPosition:(CGFloat)progress {
    
    //progress > 1 向左滑动表格反之向右滑动表格
    NSInteger nextIndex = progress > 1 ? _selectedIndex + 1 : _selectedIndex - 1;
    if (nextIndex < 0 || nextIndex == _arrTitles.count) {return;}
    //获取当前阴影位置
    CGRect currentRect = [self shadowRectOfIndex:_selectedIndex];
    CGRect nextRect = [self shadowRectOfIndex:nextIndex];
    //如果在此时cell不在屏幕上 则不显示动画
    if (CGRectGetMinX(currentRect) <= 0 || CGRectGetMinX(nextRect) <= 0) {return;}
    
    progress = progress > 1 ? progress - 1 : 1 - progress;
    
    //更新宽度
    CGFloat width = currentRect.size.width + progress*(nextRect.size.width - currentRect.size.width);
    CGRect bounds = _shadow.bounds;
    bounds.size.width = width;
    _shadow.bounds = bounds;
    
    //更新位置
    CGFloat distance = CGRectGetMidX(nextRect) - CGRectGetMidX(currentRect);
    _shadow.center = CGPointMake(CGRectGetMidX(currentRect) + progress* distance, _shadow.center.y);
}

//更新标题颜色
- (void)updateItem:(CGFloat)progress {
    
//    _nextIndex = progress > 1 ? _selectedIndex + 1 : _selectedIndex - 1;
//    NSLog(@"_selectedIndex %ld nextIndex %ld", _selectedIndex, _nextIndex);
    CGFloat result = progress - 1;
    if (result == 1) {
        _nextIndex = _selectedIndex + 1;
    }
    else if (result == -1) {
        _nextIndex = _selectedIndex - 1;
    }
    else {
        _nextIndex = _selectedIndex;   
    }
    NSLog(@"progress %f", progress);
//    if (_nextIndex < 0 || _nextIndex == _arrTitles.count) {return;}
//
//    ZSlideSegmentCollectionViewCell *currentItem = (ZSlideSegmentCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
//    ZSlideSegmentCollectionViewCell *nextItem    = (ZSlideSegmentCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_nextIndex     inSection:0]];
//    progress = progress > 1 ? progress - 1 : 1 - progress;
    
    //更新颜色
//    currentItem.lblTitle.textColor = [self transformFromColor:_selectedColor toColor:_normalColor   progress:progress];
//    nextItem.lblTitle.textColor    = [self transformFromColor:_normalColor   toColor:_selectedColor progress:progress];

//    CGFloat currentItemScale = kItemMaxScale - (kItemMaxScale - 1) * progress;
//    CGFloat nextItemScale    = 1 + (kItemMaxScale - 1) * progress;
//    currentItem.transform = CGAffineTransformMakeScale(currentItemScale, currentItemScale);
//    nextItem.transform    = CGAffineTransformMakeScale(nextItemScale, nextItemScale);
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSlideSegmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZSlideSegmentCollectionViewCell" forIndexPath:indexPath];
    cell.data = _arrTitles[indexPath.row];
    cell.isSelected = indexPath.row == _nextIndex;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_canScroll) {
        return CGSizeMake([self itemWidthOfIndexPath:indexPath], _collectionView.height);
    }
    return CGSizeMake(Screen_Width/_arrTitles.count, _collectionView.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return _canScroll ? UIEdgeInsetsMake(0, 80, 0, 0) : UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return _canScroll ? kItemSpace : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _nextIndex = indexPath.row;
    self.selectedIndex = indexPath.row;
    _ignoreAnimation = YES;
}

#pragma mark - 更新阴影

//获取文字宽度
- (CGFloat)itemWidthOfIndexPath:(NSIndexPath*)indexPath {
    NSString *title = @"";
    
    if ([_arrTitles[indexPath.row] isKindOfClass:[NSString class]]) {
        title = _arrTitles[indexPath.row];
    }
    else if ([_arrTitles[indexPath.row] isKindOfClass:[ClassModel class]]) {
        ClassModel *classInfo = _arrTitles[indexPath.row];
        title = classInfo.className;
    }
    else {
        NSLog(@"ZSlideSegment 未知的类型");
        return 0;
    }
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:kItemFontSize], NSParagraphStyleAttributeName : style };
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)
                                          options:opts
                                       attributes:attributes
                                          context:nil].size;
    return textSize.width;
}

// 底部滑块的位置与大小
- (CGRect)shadowRectOfIndex:(NSInteger)index {
    // 获取选中 cell 相对于 collection 的位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ZSlideSegmentCollectionViewCell *cell = (ZSlideSegmentCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellRect = [_collectionView convertRect:cell.frame toView:_collectionView];
    
    // 设置阴影的 frame
    CGFloat x = 0;
    if (_canScroll) {
        // 可以滚动 label.frame = cell.frame, 所以直接 label.x = cell.x
        x = cellRect.origin.x;
    }
    else {
        // 不能滚动的 cell 的宽度为屏幕宽度比上 cell 数量
        // x = index * cell.width + label.x;
        // label.x = (cell.width - label.width)/2
        x = (self.width/_arrTitles.count*index) + ((self.width/_arrTitles.count) - [self itemWidthOfIndexPath:[NSIndexPath indexPathForRow:index inSection:0]])/2;
    }
    CGFloat y = self.height - kShadowHeight - 2;
    CGFloat w = [self itemWidthOfIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    CGFloat h = kShadowHeight;
    return CGRectMake(x, y, w, h);
}

#pragma mark - 功能性方法

- (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    
    if (!fromColor) {
        fromColor = [UIColor cm_blackColor_333333_1];
    }
    if (!toColor) {
        toColor = [UIColor cm_mainColor];
    }
    
    progress = progress >= 1 ? 1 : progress;
    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
    
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
    
    CGFloat red =   fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat green = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat blue =  fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark - 属性

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZSlideSegmentCollectionViewCell class] forCellWithReuseIdentifier:@"ZSlideSegmentCollectionViewCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.collectionViewLayout = self.layout;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0;
    }
    return _layout;
}

@end
